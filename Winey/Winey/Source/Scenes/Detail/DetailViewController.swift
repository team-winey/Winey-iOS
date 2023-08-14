//
//  DetailViewController.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/08.
//

import Combine
import UIKit

import DesignSystem
import Kingfisher
import SnapKit

final class DetailViewController: UIViewController {
    typealias Section = DetailSection
    typealias DataSource = UITableViewDiffableDataSource<Section, Section.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Section.Item>
    
    private let naviBar = WINavigationBar(leftBarItem: .back)
    private let tableView = UITableView()
    private let floatingCommentView = FloatingCommentView()
    private let keyboardFrameView = KeyboardFrameView()
    private var commentViewBottomConstraint: Constraint?
    private lazy var dataSource = dataSource(of: tableView)
    private var snapshot: Snapshot = Snapshot()
    private let commentService: CommentService = CommentService()
    private let feedService: FeedService = FeedService()
    private let mapper: DetailMapper = DetailMapper()
    
    private var feedId: Int
    
    private var bag = Set<AnyCancellable>()
    
    init(feedId: Int) {
        self.feedId = feedId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttribute()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFeedDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateTableViewContentInset()
    }
    
    private func updateTableViewContentInset() {
        var bottom = floatingCommentView.frame.height
        if keyboardFrameView.frame.height > 0 {
            bottom += keyboardFrameView.frame.height
        }
        tableView.contentInset.bottom = bottom
    }
    
    @objc private func didTapNaviBarLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController {
    private func setupAttribute() {
        view.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.dataSource = dataSource
        tableView.registerCell(CommentCell.self)
        tableView.registerCell(DetailInfoCell.self)
        tableView.registerCell(EmptyCommentCell.self)
        tableView.contentInsetAdjustmentBehavior = .never
        // TODO: 키보드 내리는 동작 UX 개선
        tableView.keyboardDismissMode = .interactive
        naviBar.leftButton.addTarget(self, action: #selector(didTapNaviBarLeftButton), for: .touchUpInside)
    }
    
    private func setupLayout() {
        setupKeyboardFrameView()
        
        view.addSubview(naviBar)
        view.addSubview(tableView)
        view.addSubview(floatingCommentView)
        
        naviBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        floatingCommentView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview()
            commentViewBottomConstraint = make.bottom.equalTo(keyboardFrameView.snp.top).constraint
        }
        
        setupSafeAreaBottomView()
    }
    
    private func setupSafeAreaBottomView() {
        let safeAreaBottomView = UIView()
        safeAreaBottomView.backgroundColor = .winey_gray100
        view.addSubview(safeAreaBottomView)
        safeAreaBottomView.snp.makeConstraints { make in
            make.height.equalTo(DeviceInfo.safeAreaBottomHeight)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupKeyboardFrameView() {
        view.addSubview(keyboardFrameView)
        keyboardFrameView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        bindCommentView()
        bindKeyboardFrameView()
    }
    
    private func bindCommentView() {
        floatingCommentView.didTapSendButtonPublisher
            .sink { [weak self] comment in
                self?.sendComment(comment)
            }
            .store(in: &bag)
    }
    
    private func bindKeyboardFrameView() {
        keyboardFrameView.keyboardWillHideNotification
            .sink { [weak self] _ in
                guard let self else { return }
                self.floatingCommentView.updateBottomInset(isKeyboardShown: false)
            }
            .store(in: &bag)
        
        keyboardFrameView.keyboardWillShowNotification
            .sink { [weak self] _ in
                guard let self else { return }
                self.floatingCommentView.updateBottomInset(isKeyboardShown: true)
            }
            .store(in: &bag)
    }
}

extension DetailViewController {
    private func dataSource(of tableView: UITableView) -> DataSource {
        return DataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
            guard let self else { return nil }
            
            switch itemIdentifier {
            case let .comment(viewModel):
                guard let cell = tableView.dequeue(CommentCell.self, for: indexPath)
                else { return nil }
                cell.configure(viewModel: viewModel)
                cell.subscribeTapMoreButton {
                    
                    self.resignFirstResponder()
                    
                    let commentId = viewModel.id
                    let action = viewModel.isMine
                    ? ActionHandler(title: "삭제하기", handler: { self.deleteComment(commentId: commentId) })
                    : ActionHandler(title: "신고하기", handler: { self.reportComment(commentId: commentId) })
                    self.presentActionSheet(actions: [action])
                }
                cell.selectionStyle = .none
                return cell
                
            case let .info(viewModel):
                guard let cell = tableView.dequeue(DetailInfoCell.self, for: indexPath)
                else { return nil }
                cell.configure(viewModel: viewModel)
                cell.selectionStyle = .none
                return cell
                
            case .emptyComment:
                guard let cell = tableView.dequeue(EmptyCommentCell.self, for: indexPath)
                else { return nil }
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    private func apply(sections: [Section]) {
        self.snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applyNewComment(item: Section.Item) {
        let section = dataSource.sectionIdentifier(for: 1)
        snapshot.appendItems([item], toSection: section)
        
        if snapshot.itemIdentifiers.contains(where: { $0 == .emptyComment }) {
            snapshot.deleteItems([.emptyComment])
        }
        dataSource.apply(snapshot) { [weak self] in
            guard let self,
                  let indexPath = self.dataSource.indexPath(for: item)
            else { return }
            
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func applyDeleteComment(item: Section.Item) {
        snapshot.deleteItems([item])
        dataSource.apply(snapshot)
    }
    
    private func applyDetailInfoItem(item: Section.Item) {
        let section = dataSource.sectionIdentifier(for: 0)
        guard let beforeItem = dataSource.itemIdentifier(for: .init(item: 0, section: 0))
        else { return }
        snapshot.appendItems([item], toSection: section)
        snapshot.deleteItems([beforeItem])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applyEmptyCommentIfNeeded() {
        snapshot.sectionIdentifiers.forEach {
            print("###", $0.type, $0.items.count)
        }
    }
}

extension DetailViewController {
    private func fetchFeedDetail() {
        Task(priority: .background) {
            let response = try await feedService.fetchDetailFeed(feedId: self.feedId)
            var commentItems: [Section.Item] = response.getCommentResponseList
                .compactMap { try? mapper.convertToCommentViewModel($0) }
                .map { .comment($0) }
            if commentItems.isEmpty {
                commentItems.append(.emptyComment)
            }
            let commentSection: Section = .init(type: .comments, items: commentItems)
            let detailInfoViewModel = try await mapper.convertToDetailInfoViewModel(response)
            let detailInfoItem: Section.Item = .info(detailInfoViewModel)
            let detailSection: Section = .init(type: .info, items: [detailInfoItem])
            
            self.apply(sections: [detailSection, commentSection])
        }
    }
    
    private func sendComment(_ comment: String) {
        Task(priority: .background) {
            let response = try await commentService.createComment(feedId: feedId, comment: comment)
            let commentViewModel = try mapper.convertToCommentViewModel(response)
            let newCommentItem: Section.Item = .comment(commentViewModel)
                
            guard let item = dataSource.itemIdentifier(for: .init(item: 0, section: 0)),
                  case let .info(viewModel) = item
            else { return }
            var newViewModel = viewModel
            newViewModel.commentCount += 1
            
            self.applyDetailInfoItem(item: .info(newViewModel))
            self.applyNewComment(item: newCommentItem)
        }
    }
    
    private func deleteComment(commentId: Int) {
        Task(priority: .background) { [weak self] in
            guard let self else { return }
            
            try await commentService.deleteComment(commentId: commentId)
            
            guard let itemDeleted = snapshot.itemIdentifiers.filter({
                guard case let .comment(viewModel) = $0 else { return false }
                return viewModel.id == commentId
            }).first
            else { return }
            
            guard let item = dataSource.itemIdentifier(for: .init(item: 0, section: 0)),
                  case let .info(viewModel) = item
            else { return }
            
            var newViewModel = viewModel
            newViewModel.commentCount -= 1
            
            self.applyDetailInfoItem(item: .info(newViewModel))
            self.applyDeleteComment(item: itemDeleted)
            self.applyEmptyCommentIfNeeded()
        }
    }
    
    private func reportComment(commentId: Int) {
        let popupController = MIPopupViewController(content: .init(title: "신고가 접수되었습니다."))
        popupController.addButton(title: "확인", type: .gray, tapButtonHandler: nil)
        self.present(popupController, animated: true)
    }
}

extension DetailViewController {
    struct ActionHandler {
        let title: String
        let handler: () -> Void
    }
    
    func presentActionSheet(actions: [ActionHandler]) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        actions.forEach { action in
            let action = UIAlertAction(title: action.title, style: .destructive) { _ in
                action.handler()
            }
            alertController.addAction(action)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}

enum DeviceInfo {
    static var safeAreaBottomHeight: CGFloat {
        guard let window = UIWindow.current else { return .zero }
        return window.safeAreaInsets.bottom
    }
    static var width: CGFloat {
        UIScreen.main.bounds.width
    }
}

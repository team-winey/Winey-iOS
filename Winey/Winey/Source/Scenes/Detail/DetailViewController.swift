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
            - DeviceInfo.safeAreaBottomHeight
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
        tableView.contentInsetAdjustmentBehavior = .never
        // TODO: 키보드 내리는 동작 UX 개선
        tableView.keyboardDismissMode = .onDrag
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
            switch itemIdentifier {
            case let .comment(viewModel):
                guard let cell = tableView.dequeue(CommentCell.self, for: indexPath)
                else { return nil }
                cell.configure(viewModel: viewModel)
                cell.selectionStyle = .none
                return cell
                
            case let .info(viewModel):
                guard let cell = tableView.dequeue(DetailInfoCell.self, for: indexPath)
                else { return nil }
                cell.configure(viewModel: viewModel)
                cell.selectionStyle = .none
                return cell

            case .emptyComment:
                return nil
            }
        }
    }
    
    private func apply(sections: [Section]) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func applyNewComment(item: Section.Item) {
        var snapshot = dataSource.snapshot()
        let section = dataSource.sectionIdentifier(for: 1)
        snapshot.appendItems([item], toSection: section)
        
        dataSource.apply(snapshot) { [weak self] in
            guard let self,
                  let indexPath = self.dataSource.indexPath(for: item)
            else { return }
            
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension DetailViewController {
    private func fetchFeedDetail() {
        Task(priority: .background) {
            let response = try await feedService.fetchDetailFeed(feedId: self.feedId)
            let commentItems: [Section.Item] = response.getCommentResponseList
                .compactMap { try? mapper.convertToCommentViewModel($0) }
                .map { .comment($0) }
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
            self.applyNewComment(item: newCommentItem)
        }
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

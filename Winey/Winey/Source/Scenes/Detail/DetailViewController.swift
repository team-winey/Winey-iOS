//
//  DetailViewController.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/08.
//

import Combine
import UIKit

import DesignSystem
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
    
    private var bag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttribute()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        testApplySection()
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
    
    private func testApplySection() {
        var snapshot = Snapshot()
        let commentItems: [Section.Item] = Self.dummyCommentsViewModel.map { .comment($0) }
        snapshot.appendSections([.info])
        snapshot.appendItems([Section.Item.info(Self.dummyInfoViewModel)], toSection: Section.info)
        dataSource.apply(snapshot)
        
        snapshot.appendSections([.comments])
        snapshot.appendItems(commentItems, toSection: .comments)
        dataSource.apply(snapshot)
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
        floatingCommentView.commentPublisher
            .sink { [weak self] comment in
                
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
                cell.selectionStyle = .none
                return cell
                
            case let .info(viewModel):
                guard let cell = tableView.dequeue(DetailInfoCell.self, for: indexPath)
                else { return nil }
                cell.configure(viewModel: viewModel)
                cell.subscribeReceiveImageSubject { imageInfo in
                    self.updateSnapshot(imageInfo: imageInfo)
                }
                cell.selectionStyle = .none
                return cell

            case .emptyComment:
                return nil
            }
        }
    }
    
    private func updateSnapshot(imageInfo: DetailInfoCell.ViewModel.ImageInfo) {
        var snapshot = dataSource.snapshot()
        guard snapshot.numberOfItems > 1,
              snapshot.numberOfSections > 1,
              case let .info(viewModel) = snapshot.itemIdentifiers[0]
        else { return }
        let beforeItem = snapshot.itemIdentifiers[0]
        let infoSection = snapshot.sectionIdentifiers[0]
        var newViewModel = viewModel
        newViewModel.imageInfo = imageInfo
        
        let newItem = Section.Item.info(newViewModel)
        snapshot.appendItems([newItem], toSection: infoSection)
        snapshot.deleteItems([beforeItem])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

private extension DetailViewController {
    static var dummyInfoViewModel: DetailInfoCell.ViewModel {
        .init(
            userLevel: .one,
            nickname: "카페인 중독자",
            isLike: false,
            title: "어디까지길어질까?어디까지길어질까?어디 ㅁㄴㅇㄹㅁㄴ?ghjkQP 🙏🏻 🤔",
            likeCount: 4,
            commentCount: 1,
            timeAgo: "몇 분전",
            imageInfo: .init(
                imageUrl: URL(string: "https://github.com/team-winey/Winey-iOS/assets/56102421/b31edbc5-4c42-4c83-9a2d-936ec1c4fc0a")!,
                height: 100
            ),
            money: 4500
        )
    }

    static var dummyCommentsViewModel: [CommentCell.ViewModel] {
        [
            .init(level: "황제", nickname: "김응관", comment: "잘하셧 어요... 훌 ~ 륭합니다 . ^^ ", isMine: false),
            .init(level: "황제", nickname: "김응관", comment: "굿... 기왕, 캐시워크까지 해서 꽁돈 버시는 건 어떨는지?.\n휘바고 ~ ", isMine: false),
            .init(level: "황제", nickname: "김응관", comment: "잘하셧 어요... 훌 ~ 륭합니다 . ^^ ", isMine: false),
            .init(level: "황제", nickname: "김응관", comment: "잘하셧 어요... 훌 ~ 륭합니다 . ^^ ", isMine: false)
        ]
    }
}

enum DeviceInfo {
    static var safeAreaBottomHeight: CGFloat {
        guard let window = UIWindow.current else { return .zero }
        return window.safeAreaInsets.bottom
    }
}

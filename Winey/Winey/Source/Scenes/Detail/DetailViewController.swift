//
//  DetailViewController.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/08.
//

import UIKit

import DesignSystem
import SnapKit

final class DetailViewController: UIViewController {
    typealias Section = DetailSection
    typealias DataSource = UITableViewDiffableDataSource<Section, Section.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Section.Item>
    
    private let naviBar = WINavigationBar(leftBarItem: .back)
    private let tableView = UITableView()
    private lazy var dataSource = dataSource(of: tableView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttribute()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        testApplySection()
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
    }
    
    private func setupLayout() {
        view.addSubview(naviBar)
        view.addSubview(tableView)
        
        naviBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
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
                imageUrl: URL(string: "https://i.namu.wiki/i/0dzqJuL0LTSp5yj0k0W5YMoBophY0WDVKRqU33VjbSH1GaCFCJHp0etEe0FPCVnPdPe0ykg4cpcPM117ECDt7w.webp")!,
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

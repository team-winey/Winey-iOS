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
        
        applySections()
    }
    
    private func applySections() {
        var snapshot = Snapshot()
        let viewModel = DetailInfoCell.ViewModel(
            userLevel: .one,
            nickname: "카페인 중독자",
            isLike: false,
            title: "dsafdsafsadf",
            likeCount: 4,
            commentCount: 1,
            timeAgo: "몇 분전",
            imageInfo: .init(
                imageUrl: URL(string: "https://i.namu.wiki/i/0dzqJuL0LTSp5yj0k0W5YMoBophY0WDVKRqU33VjbSH1GaCFCJHp0etEe0FPCVnPdPe0ykg4cpcPM117ECDt7w.webp")!,
                height: 100
            ),
            money: 4500
        )
        let section = Section.info(item: .info(viewModel))
        snapshot.appendSections([section])
        snapshot.appendItems([.info(viewModel)], toSection: section)
        dataSource.apply(snapshot)
    }
}
//https://i.namu.wiki/i/0dzqJuL0LTSp5yj0k0W5YMoBophY0WDVKRqU33VjbSH1GaCFCJHp0etEe0FPCVnPdPe0ykg4cpcPM117ECDt7w.webp
// https://github.com/team-winey/Winey-iOS/assets/56102421/958a96f1-3c20-4feb-b3df-5ac7bfdb4018
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
            }
        }
    }
    
    private func updateSnapshot(imageInfo: DetailInfoCell.ViewModel.ImageInfo) {
        var snapshot = dataSource.snapshot()
        guard snapshot.numberOfItems > 0,
              snapshot.numberOfSections > 0,
              case let .info(viewModel) = snapshot.itemIdentifiers[0]
        else { return }
        
        var newViewModel = viewModel
        newViewModel.imageInfo = imageInfo
        let newItem = Section.Item.info(newViewModel)
        let diff = [newItem].difference(from: snapshot.itemIdentifiers)
        guard let newIdentifiers = snapshot.itemIdentifiers.applying(diff) else { return }
        snapshot.deleteItems(snapshot.itemIdentifiers)
        snapshot.appendItems(newIdentifiers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

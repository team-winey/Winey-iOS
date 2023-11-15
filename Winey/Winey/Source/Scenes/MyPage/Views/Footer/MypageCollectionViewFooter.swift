//
//  MypageCollectionViewFooter.swift
//  Winey
//
//  Created by 김응관 on 2023/08/19.
//

import UIKit

import SnapKit
import DesignSystem

protocol withDrawAccountDelegate: AnyObject{
    func withDrawButtonTapped()
}

final class MypageCollectionViewFooter: UICollectionReusableView {

    weak var delegate: withDrawAccountDelegate?

    // MARK: - UIComponents
    private lazy var deletingAccountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(.winey_gray400, for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(deletingButtonTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SecondView Error!")
    }

    @objc
    private func deletingButtonTapped() {
        delegate?.withDrawButtonTapped()
    }



    // MARK: - Layout
    private func setUI() {
        self.backgroundColor = .winey_gray50
    }

    private func setLayout() {
        addSubview(deletingAccountButton)

        deletingAccountButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(23)
            make.bottom.equalToSuperview().inset(43)
        }
    }
}

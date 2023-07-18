//
//  TestPopupViewController.swift
//  Winey
//
//  Created by Woody Lee on 2023/07/14.
//

import UIKit

import DesignSystem
import SnapKit

class TestPopupViewController: UIViewController {
    private let button1 = UIButton()
    private let button2 = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        button1.addTarget(self, action: #selector(tapButton1), for: .touchUpInside)
        button2.addTarget(self, action: #selector(tapButton2), for: .touchUpInside)
        
        button1.setTitle("팝업 띄우기 - 메뉴 1개", for: .normal)
        button2.setTitle("팝업 띄우기 - 메뉴 2개", for: .normal)
        
        button1.layer.borderColor = UIColor.black.cgColor
        button2.layer.borderColor = UIColor.black.cgColor
        button1.layer.borderWidth = 2
        button2.layer.borderWidth = 2
        button1.setTitleColor(.black, for: .normal)
        button2.setTitleColor(.black, for: .normal)
        
        view.addSubview(button1)
        view.addSubview(button2)
      
        button1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        button2.snp.makeConstraints { make in
            make.top.equalTo(button1.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc private func tapButton1() {
        let popupController = MIPopupViewController(content: .cannotEditGoal)
        popupController.addButton(title: "취소", type: .gray) {
            print("취소")
        }
        self.present(popupController, animated: true)
    }
    
    @objc private func tapButton2() {
        let popupController = MIPopupViewController(content: .delete1)
        popupController.addButton(title: "취소", type: .gray) {
            print("취소")
        }
        popupController.addButton(title: "삭제하기", type: .yellow) {
            print("삭제하기")
        }
        self.present(popupController, animated: true)
    }
}

private extension MIPopupContent {
    static let delete1: Self = .init(
        title: "진짜 게시물을 삭제하시겠어요?",
        subtitle: "지금 게시물을 삭제하면 누적 금액이\n삭감되어 레벨이 내려갈 수 있으니 주의하세요!"
    )
    static let cannotEditGoal: Self = .init(
        title: "절약 목표 기간이 지나지 않아\n목표를 수정할 수 없어요 ",
        subtitle: nil
    )
}

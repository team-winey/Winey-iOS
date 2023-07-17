//
//  TestTypoViewController.swift
//  Winey
//
//  Created by Woody Lee on 2023/07/14.
//

import UIKit

import DesignSystem
import SnapKit

class TestTypoViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let label1 = UILabel()
    private let label2 = UILabel()
    private let label3 = UILabel()
    private let label4 = UILabel()
    private let label5 = UILabel()
    private let label6 = UILabel()
    private let label7 = UILabel()
    private let label8 = UILabel()
    private let label9 = UILabel()
    private let label10 = UILabel()
    private let label11 = UILabel()
    private let label12 = UILabel()
    private let label13 = UILabel()
    private let label14 = UILabel()
    private let label15 = UILabel()
    private let label16 = UILabel()
    private let label17 = UILabel()
    private let label18 = UILabel()
    private let label19 = UILabel()
    private let label20 = UILabel()
    private let label21 = UILabel()
    private let label22 = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupLayout()
        setupAttribute()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)
        stackView.addArrangedSubview(label3)
        stackView.addArrangedSubview(label4)
        stackView.addArrangedSubview(label5)
        stackView.addArrangedSubview(label6)
        stackView.addArrangedSubview(label7)
        stackView.addArrangedSubview(label8)
        stackView.addArrangedSubview(label9)
        stackView.addArrangedSubview(label10)
        stackView.addArrangedSubview(label11)
        stackView.addArrangedSubview(label12)
        stackView.addArrangedSubview(label13)
        stackView.addArrangedSubview(label14)
        stackView.addArrangedSubview(label15)
        stackView.addArrangedSubview(label16)
        stackView.addArrangedSubview(label17)
        stackView.addArrangedSubview(label18)
        stackView.addArrangedSubview(label19)
        stackView.addArrangedSubview(label20)
        stackView.addArrangedSubview(label21)
        stackView.addArrangedSubview(label22)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        for label in stackView.subviews.compactMap({ $0 as? UILabel }) {
            label.textColor = .black
        }
    }
    
    private func setupAttribute() {
        view.backgroundColor = .white
        
        label1.setText("Head line_b_28", attributes: .init(style: .headLine, weight: .bold))
        label2.setText("Head line2_b_24", attributes: .init(style: .headLine2, weight: .bold))
        label3.setText("headline3_b_20", attributes: .init(style: .headLine3, weight: .bold))
        label4.setText("headline4_b_18", attributes: .init(style: .headLine4, weight: .bold))
        
        label5.setText("body_b_16", attributes: .init(style: .body, weight: .bold))
        label6.setText("body_m_16", attributes: .init(style: .body, weight: .medium))
        label7.setText("body_b_15", attributes: .init(style: .body2, weight: .bold))
        label8.setText("body_m_15", attributes: .init(style: .body2, weight: .medium))
        label9.setText("body_b_14", attributes: .init(style: .body3, weight: .bold))
        label10.setText("body_m_14", attributes: .init(style: .body3, weight: .medium))
        
        label11.setText("detail_b_13", attributes: .init(style: .detail, weight: .bold))
        label12.setText("detail_m_13", attributes: .init(style: .detail, weight: .medium))
        label13.setText("detail2_b_12", attributes: .init(style: .detail2, weight: .bold))
        label14.setText("detail2_m_12", attributes: .init(style: .detail2, weight: .medium))
        
        label15.setText("detail_b_13", attributes: .init(style: .detail, weight: .bold))
        label16.setText("detail_m_13", attributes: .init(style: .detail, weight: .medium))
        label17.setText("detail2_b_12", attributes: .init(style: .detail2, weight: .bold))
        label18.setText("detail2_m_12", attributes: .init(style: .detail2, weight: .medium))
        label19.setText("detail3_b_11", attributes: .init(style: .detail3, weight: .bold))
        label20.setText("detail3_m_11", attributes: .init(style: .detail3, weight: .medium))
        label21.setText("detail4_b_10", attributes: .init(style: .detail4, weight: .bold))
        label22.setText("detail4_m_10", attributes: .init(style: .detail4, weight: .medium))
    }
}

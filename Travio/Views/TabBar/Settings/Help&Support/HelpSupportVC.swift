//
//  HelpSupportVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 7.09.2023.
//

import UIKit
import SnapKit

class HelpSupportVC: UIViewController {
    
    private lazy var btnBack: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(btnBackTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.text = "Help&Support"
        label.textColor = .white
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 32)
        return label
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = AppColor.backgroundLight.colorValue()
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 74
        tv.register(HelpSupportTVC.self, forCellReuseIdentifier: HelpSupportTVC.identifier)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        mainView.roundCorners(corners: [.topLeft], radius: 80)
    }
    
    @objc private func btnBackTapped() {
        print("back button tapped")
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = AppColor.primaryColor.colorValue()
        self.view.addSubviews(btnBack,
                              lblTitle,
                              mainView)
        self.mainView.addSubviews(tableView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        btnBack.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(22)
            make.width.equalTo(24)
        }
        
        lblTitle.snp.makeConstraints { make in
            make.leading.equalTo(btnBack.snp.trailing).offset(24)
            make.centerY.equalTo(btnBack.snp.centerY)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(lblTitle.snp.bottom).offset(58)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
        }
        
    }
    
}

extension HelpSupportVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HelpSupportTVC.identifier) as? HelpSupportTVC {
            if cell.isExpanded {
                return 140
            }
        }
        return 74
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = "FAQ"
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 24)
        label.textColor = AppColor.primaryColor.colorValue()
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}

extension HelpSupportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HelpSupportTVC.identifier, for: indexPath) as? HelpSupportTVC else { return UITableViewCell() }
        cell.configure()
        return cell
    }
    
    
}

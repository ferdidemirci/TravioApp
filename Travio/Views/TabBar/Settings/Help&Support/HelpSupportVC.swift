//
//  HelpSupportVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 7.09.2023.
//

import UIKit
import SnapKit

class HelpSupportVC: UIViewController {
    
    let viewModel = HelpSupportVM()
    
    var selectedIndex = -1
    var isExpand = false
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backBarButtonIcon"), for: .normal)
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
        tv.showsVerticalScrollIndicator = false
        tv.estimatedRowHeight = 86
        tv.rowHeight = UITableView.automaticDimension
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
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func calculateHeight(selectedIndexPath: IndexPath) -> CGFloat {
        guard let cell = self.tableView.cellForRow(at: selectedIndexPath) as? HelpSupportTVC else { return CGFloat() }
        var labelFrame = cell.descriptionLabel.frame
        let width = cell.descriptionLabel.frame.size.width
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = cell.descriptionLabel.sizeThatFits(maxSize)
        labelFrame.size.height = requiredSize.height
        return 86 + 12 + labelFrame.size.height + 16
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = AppColor.primaryColor.colorValue()
        self.view.addSubviews(backButton,
                              lblTitle,
                              mainView)
        self.mainView.addSubviews(tableView)
        setupLayouts()
    }
    
    private func setupLayouts() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(22)
            make.width.equalTo(24)
        }
        
        lblTitle.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(24)
            make.centerY.equalTo(backButton.snp.centerY)
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
        if selectedIndex == indexPath.row && isExpand == true {
            return self.calculateHeight(selectedIndexPath: indexPath)
        } else {
            return 110
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            if self.isExpand == true {
                isExpand = false
            } else {
                isExpand = true
            }
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
        }
        
        selectedIndex = indexPath.row
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
}

extension HelpSupportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.faqData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HelpSupportTVC.identifier, for: indexPath) as? HelpSupportTVC else { return UITableViewCell() }
        cell.configure(with: viewModel.faqData[indexPath.row])
        return cell
    }
}

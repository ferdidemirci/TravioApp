//
//  ViewController.swift
//  Travio
//
//  Created by Ferdi DEMİRCİ on 31.08.2023.
//

import UIKit
import SnapKit

protocol HomeCellDelegate: AnyObject {
    func cellDidTapButton(_ indexPath: IndexPath, _ vc: UIViewController)
}

class HomeVC: UIViewController {
    
    var viewModel = HomeVM()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.addArrangedSubview(titleLogoImageView)
        stackView.addArrangedSubview(titleLabel)
        return stackView
    }()
    
    private lazy var titleLogoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "travioLogo")
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "travio"
        label.font = UIFont(name: AppFont.bold.rawValue, size: 40)
        label.textColor = .white
        return label
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        view.addSubview(tableView)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTVC.self, forCellReuseIdentifier: HomeTVC.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        mainView.roundCorners(corners: [.topLeft], radius: 80)
    }
    
    func createHeaderView(sectionTitle: String, sectionIndex: Int) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        
        let titleLabel = UILabel(frame: CGRect(x: 24, y: 5, width: 200, height: 30))
        titleLabel.text = sectionTitle
        titleLabel.font = UIFont(name: AppFont.medium.rawValue, size: 20)
        
        let seeAllButton = UIButton(frame: CGRect(x: self.view.frame.width - 80, y: 5, width: 64, height: 30))
        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.titleLabel?.font = UIFont(name: AppFont.medium.rawValue, size: 14)
        seeAllButton.setTitleColor(AppColor.secondaryColor.colorValue(), for: .normal)
        seeAllButton.contentHorizontalAlignment = .trailing
        seeAllButton.tag = sectionIndex
        seeAllButton.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(seeAllButton)
        
        return headerView
    }

    @objc func seeAllButtonTapped(sender: UIButton) {
        let vc = HomeDetailVC()
        switch sender.tag {
        case 0:
            vc.viewTag = 0
        case 1:
            vc.viewTag = 1
        case 2:
            vc.viewTag = 2
        default:
            print("Tag yok")
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupViews(){
        view.backgroundColor = AppColor.primaryColor.colorValue()
        navigationController?.isNavigationBarHidden = true
        
        
        view.addSubviews(titleStackView, mainView)
        setupLayout()
    }
    
    private func setupLayout(){
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            make.leading.equalToSuperview().offset(24)
        }
        
        titleLogoImageView.snp.makeConstraints { make in
            make.width.equalTo(66)
            make.height.equalTo(62)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(35)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTVC.identifier, for: indexPath) as? HomeTVC else { return UITableViewCell() }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView(sectionTitle: viewModel.sectionTitles[section], sectionIndex: section)
    }
}

extension HomeVC: HomeCellDelegate {
    func cellDidTapButton(_ indexPath: IndexPath, _ vc: UIViewController) {
            navigationController?.pushViewController(vc, animated: true)
       
    }
    
    
}

//
//  SecuritySettingsVC.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 1.09.2023.
//

import UIKit
import SnapKit
import Alamofire
import CoreLocation
import AVFoundation
import Photos

class SecuritySettingsVC: UIViewController {
    
    let viewModel = SecuritySettingsVM()
    
    var cameraPermissionEnabled = false
    var photoLibraryPermissionEnabled = false
    var locationPermissionEnabled = false
    
    private lazy var btnBack: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(btnBackTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.text = "Security Settings"
        label.textColor = .white
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 32)
        return label
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.addCornerRadius(corners: [.layerMinXMinYCorner], radius: 80)
        view.backgroundColor = AppColor.backgroundLight.colorValue()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        tv.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        tv.register(PrivacyTVC.self, forCellReuseIdentifier: PrivacyTVC.identifier)
        tv.register(PasswordTVC.self, forCellReuseIdentifier: PasswordTVC.identifier)
        return tv
    }()
    
    private lazy var saveButton: CustomButton = {
        let button = CustomButton()
        button.title = "Save"
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        mainView.roundCorners(corners: [.topLeft], radius: 80)
        btnSave.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 12)
    }
    
    @objc private func btnSaveTapped() {
        let passwordIndex = IndexPath(row: 0, section: 0)
        let confirmPasswordIndex = IndexPath(row: 1, section: 0)
        guard let passwordCell = tableView.cellForRow(at: passwordIndex) as? PasswordTVC,
              let confirmPasswordCell = tableView.cellForRow(at: confirmPasswordIndex) as? PasswordTVC else { return }
        let password = passwordCell.textFieldView.textField.text
        let confirmPassword = confirmPasswordCell.textFieldView.textField.text
        if password == confirmPassword {
            guard let newPassword = password else { return }
            let params: Parameters = ["new_password": newPassword]
            viewModel.changePassword(newPassword: newPassword)
        } else {
            showAlert(title: "UYARI", message: "Şifre eşleştirilemedi! Lütfen şifrelerin aynı olduğundan emin olun!")
        }
    }
    
    @objc private func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func appDidBecomeActive() {
        checkLocationPermission()
        checkPhotoLibraryPermission()
        checkCameraPermission()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized, .restricted:
            permissionOnDeviceSettings()
            cameraPermissionEnabled = true
        case .denied, .notDetermined:
            permissionOnDeviceSettings()
            cameraPermissionEnabled = false
        @unknown default:
            print("Kamera izni: Bilinmeyen durum")
        }
    }
    
    @objc private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .restricted:
            permissionOnDeviceSettings()
            photoLibraryPermissionEnabled = true
        case .denied, .notDetermined:
            permissionOnDeviceSettings()
            photoLibraryPermissionEnabled = false
        @unknown default:
            photoLibraryPermissionEnabled = false
        }
    }
    
    @objc private func checkLocationPermission() {
        let locationManager = CLLocationManager()
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            permissionOnDeviceSettings()
            locationPermissionEnabled = true
        case .denied, .restricted:
            permissionOnDeviceSettings()
            locationPermissionEnabled = false
        case .notDetermined:
            locationPermissionEnabled = false
        @unknown default:
            print("Konum izni: Bilinmeyen durum")
        }
    }
    
    private func permissionOnDeviceSettings() {
        DispatchQueue.main.async {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = AppColor.primaryColor.colorValue()
        self.view.addSubviews(btnBack,
                              lblTitle,
                              mainView)
        self.mainView.addSubviews(tableView,
                                  saveButton)
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
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(19)
            make.leading.equalTo(btnBack.snp.trailing).offset(24)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(lblTitle.snp.bottom).offset(58)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-18)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(54)
        }
    }
}

extension SecuritySettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = viewModel.sectionTitles[section]
        label.font = UIFont(name: AppFont.semiBold.rawValue, size: 16)
        label.textColor = AppColor.primaryColor.colorValue()
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = UIColor.clear
        }
    }
}

extension SecuritySettingsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PasswordTVC.identifier, for: indexPath) as? PasswordTVC else { return UITableViewCell() }
            cell.configure(title: viewModel.cellTitles[section][row])
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PrivacyTVC.identifier, for: indexPath) as? PrivacyTVC else { return UITableViewCell() }
            cell.configure(title: viewModel.cellTitles[section][row])
            let toggle = cell.privacyView.switchOnOff
            
            switch row {
            case 0:
                toggle.isOn = cameraPermissionEnabled
                toggle.addTarget(self, action: #selector(checkCameraPermission), for: .valueChanged)
            case 1:
                toggle.isOn = photoLibraryPermissionEnabled
                toggle.addTarget(self, action: #selector(checkPhotoLibraryPermission), for: .valueChanged)
            case 2:
                toggle.isOn = locationPermissionEnabled
                toggle.addTarget(self, action: #selector(checkLocationPermission), for: .valueChanged)
            default:
                break
            }
            return cell
        }
        
    }
    
}

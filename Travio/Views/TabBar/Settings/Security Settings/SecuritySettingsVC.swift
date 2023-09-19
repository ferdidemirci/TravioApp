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

protocol ReturnToSecuritySettings: AnyObject {
    func passwordTransfer(password text: String)
    func confirmPasswordTransfer(confirmPassword text: String)
}

class SecuritySettingsVC: UIViewController {
    
    let viewModel = SecuritySettingsVM()
    weak var delegate: ReturnToSettings?
    
    var cameraPermissionEnabled = false
    var photoLibraryPermissionEnabled = false
    var locationPermissionEnabled = false
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backBarButtonIcon"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
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
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: Notification.Name("appDidBecomeActive"), object: nil)
        setupViews()
        appDidBecomeActive()
        permissionRequests()
    }
    
    @objc private func saveButtonTapped() {
        guard let password = viewModel.passwords["password"],
              let confirmPassword = viewModel.passwords["confirmPassword"] else {
            showAlert(title: "Error!", message: "Password fields are missing.")
            return
        }
        
        if password == confirmPassword {
            if (8...16).contains(password.count) {
                let params: Parameters = ["new_password": password]
                viewModel.changePassword(newPassword: params) { [weak self] status in
                    guard let self = self else { return }
                    if status {
                        self.navigationController?.popViewController(animated: true)
                        self.delegate?.returned(message: "Security settings have been saved successfully.")
                    } else {
                        self.showAlert(title: "Error!", message: "Something went wrong while performing the password change. Please try again.")
                    }
                }
            } else {
                showAlert(title: "Password Length", message: "Make sure your password is between 8 - 16 characters.")
            }
        } else {
            showAlert(title: "Password Mismatch", message: "The entered passwords do not match. Please make sure you've entered the same password twice.")
        }
    }

    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Permission Functions
    
    @objc private func appDidBecomeActive() {
        checkCameraPermission()
        checkPhotoLibraryPermission()
        checkLocationPermission()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func permissionRequests() {
        PermissionHelper.requestCameraPermission { granted in
            if granted {
                self.cameraPermissionEnabled = true
                self.tableView.reloadData()
            } else {
                self.cameraPermissionEnabled = false
            }
        }
        
        PermissionHelper.requestPhotoLibraryPermission { granted in
            if granted {
                self.photoLibraryPermissionEnabled = true
                self.tableView.reloadData()
            } else {
                self.photoLibraryPermissionEnabled = false
            }
        }
        
        PermissionHelper.requestLocationPermission { granted in
            if granted {
                self.locationPermissionEnabled = true
                self.tableView.reloadData()
            } else {
                self.locationPermissionEnabled = false
            }
        }
    }
    
    @objc private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized, .restricted:
            cameraPermissionEnabled = true
        case .denied, .notDetermined:
            cameraPermissionEnabled = false
        @unknown default:
            cameraPermissionEnabled = false
        }
    }
    
    @objc private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .restricted:
            photoLibraryPermissionEnabled = true
        case .denied, .notDetermined:
            photoLibraryPermissionEnabled = false
        case .limited:
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
            locationPermissionEnabled = true
        case .denied, .restricted:
            locationPermissionEnabled = false
        case .notDetermined:
            locationPermissionEnabled = false
        @unknown default:
            locationPermissionEnabled = false
        }
    }
    
    // MARK: View Functions
    
    private func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = AppColor.primaryColor.colorValue()
        self.view.addSubviews(backButton,
                              titleLabel,
                              mainView)
        self.mainView.addSubviews(tableView,
                                  saveButton)
        setupLayouts()
    }
    
    private func setupLayouts() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(22)
            make.width.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(19)
            make.leading.equalTo(backButton.snp.trailing).offset(24)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(58)
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

// MARK: TableView Delegate and DataSource Functions

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
            cell.delegate = self
            cell.configure(title: viewModel.cellTitles[section][row], tag: indexPath.row)
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PrivacyTVC.identifier, for: indexPath) as? PrivacyTVC else { return UITableViewCell() }
            cell.configure(title: viewModel.cellTitles[section][row])
            cell.selectionStyle = .none
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

extension SecuritySettingsVC: ReturnToSecuritySettings {
    func passwordTransfer(password: String) {
        viewModel.passwords["password"] = password
    }
    
    func confirmPasswordTransfer(confirmPassword: String) {
        viewModel.passwords["confirmPassword"] = confirmPassword
    }
}

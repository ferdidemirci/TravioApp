//
//  SettingsVM.swift
//  Travio
//
//  Created by Mahmut Gazi Doğan on 31.08.2023.
//

import Foundation

class SettingsViewModel {
    var settingsParameters: [SettingsModel] = [SettingsModel(leftImage: "user", text: "Security Settings"),
                                               SettingsModel(leftImage: "scope", text: "App Defaults"),
                                               SettingsModel(leftImage: "mapIcon", text: "My Added Places"),
                                               SettingsModel(leftImage: "headphone", text: "Help&Support"),
                                               SettingsModel(leftImage: "info", text: "About"),
                                               SettingsModel(leftImage: "termsofuse", text: "Terms of Use")]
}

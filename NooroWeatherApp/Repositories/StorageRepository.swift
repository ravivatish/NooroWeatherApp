//
//  StorageRepository.swift
//  NooroWeatherApp
//
//  Created by ravinder vatish on 12/17/24.
//

import Foundation

protocol StorageInterface {
    var savedCity : String? {
        get set
    }
}

class StorageRepository : StorageInterface {
    var savedCity: String? {
        get {
            UserDefaults.standard.string(forKey: "savedCityName")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "savedCityName")
        }
    }
}

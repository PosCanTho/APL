//
//  Prefs.swift
//  AntiPlagiarism
//
//  Created by Tran Bao Toan on 9/25/17.
//  Copyright © 2017 POS. All rights reserved.
//

import Foundation

class Prefs {
    static let shared = Prefs()
    static func set(key:String, value: Any){
        UserDefaults.standard.set(value, forKey: key)
    }
    static func get(key:String) -> Any?{
        return UserDefaults.standard.value(forKey: key)
    }
}

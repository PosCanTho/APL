//
//  Constants.swift
//  AntiPlagiarism
//
//  Created by Tran Bao Toan on 9/25/17.
//  Copyright © 2017 POS. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    public static let ERROR_CODE_ERROR:Int = 0
    
    struct LOGIN {
        public static let LOGGED_IN:String = "LOGGED_IN"
    }
    
    struct ERROR {
        public static let NETWORK_ERROR:String = "NETWORK ERROR"
    }
    
    struct DIALOG {
         public static let size = CGSize(width: 30, height: 30)
    }
    
    struct URL {
          public static let LOGIN:String = "http://dev.duytan.edu.vn:8075/ConnectService.asmx/Login"
    }
    
    struct COLOR {
        public static let BLUE:String = "007685"
        public static let BLUE_TINTS:String = "7fbac2"
        public static let RED:String = "FC605E"
        public static let ARRAY:[String] = ["007685","7fbac2","FC605E","D81B60","607D8B","FF9800","FFEB3B","CDDC39","8BC34A","4CAF50","009688","00BCD4","2196F3","3949AB","D81B60","673AB7","D500F9","9C27B0"]
        
    }
    
    struct PREF_USER {
        public static let USERNAME:String = "US_USERNAME"
        public static let PASSWORD:String = "US_PASSWORD"
        public static let FULL_NAME:String = "US_FULLNAME"
    }
    
}

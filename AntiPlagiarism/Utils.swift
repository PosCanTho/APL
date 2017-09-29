//
//  Utils.swift
//  AntiPlagiarism
//
//  Created by Tran Bao Toan on 9/25/17.
//  Copyright © 2017 POS. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class Utils {
    
    static func random(max maxNumber: Int) -> Int {
        return Int(arc4random_uniform(UInt32(maxNumber)))
    }
    
     static func showStandardDialog(title:String, msg:String) -> PopupDialog {
        let title = title
        let message = msg
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
            
        }
        let buttonOne = DefaultButton(title: "OK") {}
        
        popup.addButtons([buttonOne])
        return popup
    }
    
    
    public static func showDialogProcess(msg:String) {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        NVActivityIndicatorPresenter.sharedInstance.setMessage(msg)
        //NVActivityIndicatorView
    }
    
    public static func nullToNil(value: AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        }else {
            return value
        }
    }
    
    public static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    //String to hex md5
    private static func hexMD5(string: String) -> String {
        
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        let hexMd5 = digestData.map { String(format: "%02hhx", $0) }.joined()
        return hexMd5
    }
    
    //String to encrypt sha1
    private static func encyptSha1(string: String) -> String {
        
        let data = string.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        return Data(bytes: digest).base64EncodedString()
        
    }
    
    //Password encrypt
    public static func passwordEncrypt (password: String) -> String {
        let hash = encyptSha1(string: hexMD5(string: password)).data(using: .utf8)
        let pass = hash?.base64EncodedString()
        return pass!
    }
    
    public static func jsonToHash(data: String) -> [[String:Any]] {
        var dictonary:[[String:Any]]?
        if let dataJson = data.data(using: String.Encoding.utf8) {
            do {
                dictonary = try JSONSerialization.jsonObject(with: dataJson, options: []) as? [[String:Any]]
                    return dictonary!
            } catch let error as NSError {
                print(error)
            }
        }
        return []
    }
    
    public static func hashMapToJson(any: Any) -> String{
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: any,
            options: []) {
            guard let json = String(data: theJSONData, encoding: .utf8)else{
                return ""
            }
            return json
        }
        return ""
    }
    
    static func addImage(name: String, textfield: UITextField, holder: String){
        let imageView = UIImageView();
        let image = UIImage(named: name);
        let leftImageView = UIImageView()
        leftImageView.image = image
        let leftView = UIView()
        let view = UIView()
        leftView.addSubview(leftImageView)
        leftView.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
        leftImageView.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        view.addSubview(imageView)
        textfield.leftView = leftView;
        textfield.leftViewMode = UITextFieldViewMode.always
        textfield.attributedPlaceholder = NSAttributedString(string: holder, attributes: [NSForegroundColorAttributeName: UIColor.init(hex: Constants.COLOR.BLUE_TINTS)])
    }
    
    static func convertDateToString(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
    static func convertStringToDate(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date? = dateFormatter.date(from: date)!
        return date!
    }
    
    
    static func dateAtBeginningOfDay(inputDate: Date) -> Date {
        var calendar = Calendar.current
        let timeZ: NSTimeZone = NSTimeZone.init(forSecondsFromGMT: 0)
        calendar.timeZone = timeZ as TimeZone
        var dateComps: DateComponents? = calendar.dateComponents([.year, .month, .day], from: inputDate)
        dateComps?.hour = 0
        dateComps?.minute = 0
        dateComps?.second = 0
        let beginningOfDay: Date? = calendar.date(from: dateComps!)
        return beginningOfDay!
    }
    
    static  func dateAtEndOfDayForDate(inputDate: Date) -> Date {
        var calendar = Calendar.current
        let timeZ: NSTimeZone = NSTimeZone.init(forSecondsFromGMT: 0)
        calendar.timeZone = timeZ as TimeZone
        var dateComps: DateComponents? = calendar.dateComponents([.year, .month, .day], from: inputDate)
        dateComps?.hour = 23
        dateComps?.minute = 59
        dateComps?.second = 59
        let endOfDay: Date? = calendar.date(from: dateComps!)
        return endOfDay!
    }
    
    static func settingsButton(btn: UIButton) {
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = btn.tintColor.cgColor
        btn.layer.masksToBounds = true
    }
    
}

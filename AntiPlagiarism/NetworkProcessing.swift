//
//  NetworkProcessing.swift
//  AntiPlagiarism
//
//  Created by Tran Bao Toan on 9/26/17.
//  Copyright © 2017 POS. All rights reserved.
//

import Foundation
import UIKit

class NetWorkProcessing  {
    
    public static func GET(url: String, showDialog: Bool, downloadCalback: @escaping (_ errorCode: Int, _ message: String, _ data: String?) -> Void){
        if Utils.isConnectedToNetwork() == false {/*Rớt mạng*/
            DispatchQueue.main.async {
                downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry, no Internet connectivity detected. Please reconnect and try again.", nil)
            }
        }else{
            let session = URLSession.shared
            let headers = [
                "content-type": "application/json",
                "cache-control": "no-cache",
                "postman-token": "f05da2d1-ffe9-895f-baf0-8dfb3a5b0fcb"
            ]
            if url.isEmpty { /*Truyền tham số sai*/
                //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+":Đường dẫn (URL) truyền vào rỗng.")
                //SwiftOverlays.removeAllBlockingOverlays()
                return
            }
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            if showDialog {
                Utils.showDialogProcess(msg: "Loading...")
            }
            //DebugLog.printLog(msg: "URL_REQUEST: "+url)
            
            let task = session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                DispatchQueue.main.async {
                    //SwiftOverlays.removeAllBlockingOverlays()
                }
                if error != nil {/*Lỗi trong quá trình tải*/
                    //DebugLog.printLog(msg: "DOWNLOAD_ERROR: Lỗi trong quá trình tải, tên lỗi: "+error!.localizedDescription)
                    DispatchQueue.main.async {
                        downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                    }
                }else{
                    /*Dữ liệu trả về rỗng*/
                    guard let data = data else{
                        //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Dữ liệu trả về rỗng.")
                        DispatchQueue.main.async {
                            downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                        }
                        return
                    }
                    
                    do{
                        let jsonEncode = String(data: data, encoding: .utf8)
                        let dataEncode = jsonEncode?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                        //DebugLog.printLog(msg: Constants.DOWNLOAD_RESPONSE+": "+jsonEncode!)
                        
                        if dataEncode == nil || jsonEncode == nil{/*Lỗi trong quá trình encode*/
                            //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Lỗi trong quá trình encode.")
                            DispatchQueue.main.async {
                                downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                            }
                        }else{
                            let json = try? JSONSerialization.jsonObject(with: dataEncode!, options: []) as! [String: AnyObject]
                            
                            guard let errorCode = json?["errorCode"] as? Int else {
                                //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Chuỗi json không có errorCode.")
                                DispatchQueue.main.async {
                                    downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", jsonEncode)
                                }
                                return
                            }
                            guard let message = json?["message"] as? String else {
                                //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Chuỗi json không có message.")
                                DispatchQueue.main.async {
                                    downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", jsonEncode)
                                }
                                return
                            }
                            
                            guard let data = json?["data"] else {/*Data trả về nil*/
                                DispatchQueue.main.async {
                                    downloadCalback(errorCode, message, nil)
                                }
                                return
                            }
                            
                            if Utils.nullToNil(value: data) == nil {/*"data" trả về là null*/
                                DispatchQueue.main.async {
                                    downloadCalback(errorCode, message, nil)
                                }
                                return
                            }
                            
                            DispatchQueue.main.async {
                                downloadCalback(errorCode, message, Utils.hashMapToJson(any: data))
                            }
                        }
                    } catch{
                        //DebugLog.printLog(msg: "Dữ liệu trả về không đúng định dạng Json.")
                        DispatchQueue.main.async {
                            downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                        }
                    }
                    
                }
            }
            task.resume()
            
        }
    }
    
    public static func POST(url: String, body: [String: Any], showDialog: Bool, downloadCalback: @escaping (_ errorCode: Int, _ message: String, _ data: String?) -> Void){
        if Utils.isConnectedToNetwork() == false {/*Rớt mạng*/
            DispatchQueue.main.async {
                downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry, no Internet connectivity detected. Please reconnect and try again.", nil)
            }
            //SwiftOverlays.removeAllBlockingOverlays()
        }else{
            let session = URLSession.shared
            let headers = [
                "content-type": "application/json",
                "cache-control": "no-cache",
            ]
            if url.isEmpty { /*Truyền tham số sai*/
                //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+":Đường dẫn (URL) truyền vào rỗng.")
                //SwiftOverlays.removeAllBlockingOverlays()
                return
            }
            let postData = try? JSONSerialization.data(withJSONObject: body, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData
            
            if showDialog {
                Utils.showDialogProcess(msg: "Loading...")
            }
            //DebugLog.printLog(msg: "URL_REQUEST: "+url)
            
            let task = session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                DispatchQueue.main.async {
                    //SwiftOverlays.removeAllBlockingOverlays()
                }
                if error != nil {/*Lỗi trong quá trình tải*/
                    //DebugLog.printLog(msg: "DOWNLOAD_ERROR: Lỗi trong quá trình tải, tên lỗi: "+error!.localizedDescription)
                    DispatchQueue.main.async {
                        downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                    }
                }else{
                    /*Dữ liệu trả về rỗng*/
                    guard let data = data else{
                        //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Dữ liệu trả về rỗng.")
                        DispatchQueue.main.async {
                            downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                        }
                        return
                    }
                    
                    do{
                        let jsonEncode = String(data: data, encoding: .utf8)
                        let dataEncode = jsonEncode?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                        //DebugLog.printLog(msg: Constants.DOWNLOAD_RESPONSE+": "+jsonEncode!)
                        
                        if dataEncode == nil || jsonEncode == nil{/*Lỗi trong quá trình encode*/
                            //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Lỗi trong quá trình encode.")
                            DispatchQueue.main.async {
                                downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                            }
                        }else{
                            let json = try? JSONSerialization.jsonObject(with: dataEncode!, options: []) as! [String: AnyObject]
                            
                            guard let errorCode = json?["errorCode"] as? Int else {
                                //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Chuỗi json không có errorCode.")
                                DispatchQueue.main.async {
                                    downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", jsonEncode)
                                }
                                return
                            }
                            guard let message = json?["message"] as? String else {
                                //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Chuỗi json không có message.")
                                DispatchQueue.main.async {
                                    downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", jsonEncode)
                                }
                                return
                            }
                            guard let data = json?["data"] else {/*Chuỗi json trả về không có data */
                                DispatchQueue.main.async {
                                    downloadCalback(errorCode, message, nil)
                                }
                                return
                            }
                            
                            if Utils.nullToNil(value: data) == nil {/*"data" trả về là null*/
                                DispatchQueue.main.async {
                                    downloadCalback(errorCode, message, nil)
                                }
                                return
                            }
                            
                            DispatchQueue.main.async {
                                downloadCalback(errorCode, message, Utils.hashMapToJson(any: data))
                            }
                        }
                    } catch{
                        DispatchQueue.main.async {
                            downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                        }
                    }
                    
                }
            }
            task.resume()
            
        }
    }
    
    public static func POST(url: String, body: NSMutableData, showDialog: Bool, downloadCalback: @escaping (_ errorCode: Int, _ message: String, _ data: String?) -> Void){
        if Utils.isConnectedToNetwork() == false {/*Rớt mạng*/
            DispatchQueue.main.async {
                downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry, no Internet connectivity detected. Please reconnect and try again.", Constants.ERROR.NETWORK_ERROR)
            }
        }else{
        
            let session = URLSession.shared
            let headers = [
                "content-type": "application/x-www-form-urlencoded",
                "cache-control": "no-cache"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = body as Data
      
            if showDialog {
                Utils.showDialogProcess(msg: "Loading...")
            }
            //DebugLog.printLog(msg: "URL_REQUEST: "+url)
            
            let task = session.dataTask(with: request as URLRequest) {
                (data, response, error) in
                DispatchQueue.main.async {
                    //SwiftOverlays.removeAllBlockingOverlays()
                }
                if error != nil {/*Lỗi trong quá trình tải*/
                    //DebugLog.printLog(msg: "DOWNLOAD_ERROR: Lỗi trong quá trình tải, tên lỗi: "+error!.localizedDescription)
                    DispatchQueue.main.async {
                        downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                    }
                }else{
                    /*Dữ liệu trả về rỗng*/
                    guard let data = data else{
                       //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Dữ liệu trả về rỗng.")
                        DispatchQueue.main.async {
                            downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                        }
                        return
                    }
                    
                    do{
                        let jsonEncode = String(data: data, encoding: .utf8)
                        let dataEncode = jsonEncode?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                        //DebugLog.printLog(msg: Constants.DOWNLOAD_RESPONSE+": "+jsonEncode!)
                        
                        if dataEncode == nil || jsonEncode == nil{/*Lỗi trong quá trình encode*/
                            //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Lỗi trong quá trình encode.")
                            DispatchQueue.main.async {
                                downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                            }
                        }else{
                            let json = try? JSONSerialization.jsonObject(with: dataEncode!, options: []) as! [String: AnyObject]
                            
                            if let table = json?["Table"] as? [[String:Any]]  {
                                
                                DispatchQueue.main.async {
                                    downloadCalback(1, "", Utils.hashMapToJson(any: table))
                                }
                                return
                            }
                            
                            
                            guard let errorCode = json?["errorCode"] as? Int else {
                                //DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Chuỗi json không có errorCode.")
                                DispatchQueue.main.async {
                                    downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", jsonEncode)
                                }
                                return
                            }
                            guard let message = json?["message"] as? String else {
                               // DebugLog.printLog(msg: Constants.DOWNLOAD_ERROR+": Chuỗi json không có message.")
                                DispatchQueue.main.async {
                                    downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", jsonEncode)
                                }
                                return
                            }
                            guard let data = json?["data"] else {/*Data trả về nil*/
                                DispatchQueue.main.async {
                                    downloadCalback(errorCode, message, nil)
                                }
                                return
                            }
                            
                            if Utils.nullToNil(value: data) == nil {/*"data" trả về là null*/
                                DispatchQueue.main.async {
                                    downloadCalback(errorCode, message, nil)
                                }
                                return
                            }
                            DispatchQueue.main.async {
                                downloadCalback(errorCode, message, Utils.hashMapToJson(any: data))
                            }
                        }
                    } catch {
                        //DebugLog.printLog(msg: "Dữ liệu trả về không đúng định dạng Json.")
                        DispatchQueue.main.async {
                            downloadCalback(Constants.ERROR_CODE_ERROR, "Sorry an error has occurred.", nil)
                        }
                    }
                    
                }
            }
            task.resume()
        }
    }
}

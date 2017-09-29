//
//  NetworkProcessor.swift
//  AntiPlagiarism
//
//  Created by Tran Bao Toan on 9/25/17.
//  Copyright © 2017 POS. All rights reserved.
//

import Foundation

class NetworkProcessor
{
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    let url:URL
    init(url: URL)
    {
        self.url = url
    }
    typealias JsonCallback = (([String : Any]?) -> Void)
    
    func downloadJson(post: PostParameter,_ completion: @escaping JsonCallback)
    {
        var request = URLRequest(url: self.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
        let postString:String = post.getString()
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
  
        let dataTask = session.dataTask(with: request) { (data, response, error) in
        
            if error == nil {
                
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                completion(json as? [String : Any])
                            } catch let error as NSError {
                                print(error.localizedDescription)
                            }
                        }
                        break
                    default:
                        
                        break
                    }
                }
                
            } else {
                print(error?.localizedDescription ??  "ERROR")
            }
            
        }
        dataTask.resume()
    }
}

class PostParameter{
    
    private var keyArray:Array = ["username", "password"]
    private var valueArray:Array = ["",""]
    
    func add(key:String, value:String){
        if(key == "username"){
            valueArray[0] = value
 
            return
        }
        
        if(key == "password"){
            valueArray[1] = value

            return
        }
        
        keyArray.append(key)
        valueArray.append(value)
    }
    
    func getString() -> String{
        var str:String = ""
        let total = keyArray.count - 1
        for i in 0...total{
            if(i == total){
                str += keyArray[i] + "=" + valueArray[i]
            }else{
                str += keyArray[i] + "=" + valueArray[i] + "&"
            }
        }
        
        return str
    }
    
    func isLogin() -> Bool{
        if(!valueArray[0].isEmpty && !valueArray[1].isEmpty){
            return true
        }
        
        return false
    }
}

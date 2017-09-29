//
//  LoginController.swift
//  AntiPlagiarism
//
//  Created by Tran Bao Toan on 9/25/17.
//  Copyright © 2017 POS. All rights reserved.
//

import UIKit

class LoginController: UIViewController, NVActivityIndicatorViewable {
    
    /*OUTLETS*/
    
    @IBOutlet weak var lblUserNil: UILabel!
    @IBOutlet weak var lblPassNil: UILabel!
    @IBOutlet weak var tfUsername: LocalizableTextField!
    @IBOutlet weak var tfPassword: LocalizableTextField!

    /*ACTIONS*/
    
    @IBAction func btnLogIn(_ sender: Any) {
        checkText()
    }
    
    /*END*/
    let userReference = UserDefaults.standard
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        // Do any additional setup after loading the view, typically from a nib.
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: LOGIN
extension LoginController : UITextFieldDelegate  {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.tfUsername && !(textField.text?.isEmpty)!) {
            self.tfPassword.becomeFirstResponder()
            lblUserNil.isHidden = true
        }
        else if (textField == self.tfPassword && !(textField.text?.isEmpty)!) {
            textField.resignFirstResponder()
            checkText()
        }
        return true
    }
    
    func getUser(username:String, password:String){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
        }
        let encryptPass = Utils.passwordEncrypt(password: password)
        let postData = NSMutableData(data: "username=\(username)".data(using: String.Encoding.utf8)!)
        postData.append("&password=\(encryptPass)".data(using: String.Encoding.utf8)!)
        postData.append("&imei=".data(using: String.Encoding.utf8)!)
        NetWorkProcessing.POST(url: Constants.URL.LOGIN, body: postData, showDialog: true) { (code, msg, data) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                self.stopAnimating()
                if data == "" {
                    self.refreshUI()
                } else {
                    let user = Utils.jsonToHash(data: data!)
                    Prefs.set(key: Constants.PREF_USER.USERNAME, value: user[0]["UserName"]!)
                    self.userReference.set(true, forKey: Constants.LOGIN.LOGGED_IN)
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = mainStoryboard.instantiateViewController(withIdentifier: "NavigationThesisController") as! NavigationThesisController
                    self.presentDetail(vc)
                }
            }
        }
   
    }
    
    func getController(storyboard: String, withIdentifier: String) -> UIViewController{
        let vc = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
        return vc
    }
    
    func  refreshUI()  {
        self.present(Utils.showStandardDialog(title: "Sorry", msg: "Username or password is incorrect!"), animated: true, completion: {
                self.tfPassword.text = ""
        })
    }
    
    func initUI(){
        Utils.addImage(name: "user", textfield: tfUsername, holder: "Username")
        Utils.addImage(name: "lock", textfield: tfPassword, holder: "Password")
        self.tfPassword.delegate = self
        self.tfUsername.delegate = self
    }
    
    func checkText(){
        let username = tfUsername.text!
        let password = tfPassword.text!
        lblUserNil.isHidden = true
        lblPassNil.isHidden = true
        if username.isEmpty  && password.isEmpty {
            lblPassNil.isHidden = false
            lblUserNil.isHidden = false
            tfUsername.becomeFirstResponder()
        } else  if username.isEmpty {
            lblUserNil.isHidden = false
        } else if password.isEmpty {
            lblPassNil.isHidden = false
        } else {
            getUser(username: tfUsername.text!, password: tfPassword.text!)
        }
    }
}


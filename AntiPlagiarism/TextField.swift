//
//  TextField.swift
//  AntiPlagiarism
//
//  Created by Tran Bao Toan on 9/25/17.
//  Copyright © 2017 POS. All rights reserved.
//

import UIKit

class LocalizableTextField: UITextField,  UITextFieldDelegate {
    
    private var localizeKey: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        localizeKey = placeholder
        placeholder = localizeKey
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
    }
    
    override public var placeholder:String?  {
        set (newValue) {
            localizeKey = newValue
            //super.placeholder = LocalizationHelper.shared.localized(localizeKey)
        }
        get {
            return super.placeholder
        }
    }
    
//    override func onUpdateLocale() {
//        super.onUpdateLocale()
//        placeholder = localizeKey
//    }
    
    let border = CALayer()
    let width = CGFloat(1.0)
    
    required init?(coder aDecoder: (NSCoder!)) {
        super.init(coder: aDecoder)
        self.delegate=self;
        border.borderColor = UIColor.init(hex: Constants.COLOR.BLUE).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
    }
}

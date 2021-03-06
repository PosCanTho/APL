//
//  User.swift
//  AntiPlagiarism
//
//  Created by Tran Bao Toan on 9/26/17.
//  Copyright © 2017 POS. All rights reserved.
//

import Foundation

class User {
    
    var userId:String
    var userName:String
    var studentIdNumber:String
    var instructorIdNumber:String
    var currentLastName:String
    var currentMiddleName:String
    var currentFirstName:String
    var roleType:String
    
    init(
        userId:String,
        userName:String,
        studentIdNumber:String,
        instructorIdNumber:String,
        currentLastName:String,
        currentMiddleName:String,
        currentFirstName:String,
        roleType:String) {
        
        self.instructorIdNumber = instructorIdNumber
        self.userName = userName
        self.currentLastName = currentLastName
        self.roleType = roleType
        self.studentIdNumber = studentIdNumber
        self.currentFirstName = currentFirstName
        self.userId = userId
        self.currentMiddleName = currentMiddleName
        
    }
}

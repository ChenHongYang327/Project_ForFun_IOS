//
//  ReportChatMsg.swift
//  Project_ForFun_IOS
//
//  Created by 陳鋐洋 on 2021/8/8.
//

import Foundation


struct ReportChatMsg:Codable {
    var reportId: Int
    var whistleblowerId: Int
    var member: Member //reported_id;
    var type: Int
    var message: String?
    var reportClass: Int
    //var postId: Int?
    var comment: Comment //chatroomId;
    var item: Int?
    var createTime: Date?
    var deleteTime: Date?
    
    enum CodingKeys: String, CodingKey {
           case reportId = "report_id"
           case whistleblowerId = "whistleblower_id"
           case member
           case type
           case message
           case reportClass = "report_class"
           case comment
           case item
           case createTime
           case deleteTime
           
       }
  
}

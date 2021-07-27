//
//  Publish.swift
//  Project_ForFun_IOS
//
//  Created by 姜宗暐 on 2021/7/26.
//

import Foundation

class Publish : Codable {
    var publishId: Int;
    var ownerId: Int;
    var title: String;
    var titleImg: String;
    var publishInfo: String;
    var publishImg1: String;
    var publishImg2: String;
    var publishImg3: String;
    var cityId: Int;
    var areaId: Int;
    var address: String;
    var latitude: Double;
    var longitude: Double;
    var rent: Int;
    var deposit: Int;
    var square: Int;
    var gender: Int;
    var type: Int;
    var furnished: String;
    var status: Int;
    var createTime: Date;
    var updateTime: Date?;
    var deleteTime: Date?;
}

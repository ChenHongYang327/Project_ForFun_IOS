//
//  Area.swift
//  Project_ForFun_IOS
//
//  Created by 姜宗暐 on 2021/7/25.
//

import Foundation

class Area : Codable {
    var areaId: Int;
    var cityId: Int;
    var areaName: String;
    var createTime: Date;
    var updateTime: Date?;
    var deleteTime: Date?;
}

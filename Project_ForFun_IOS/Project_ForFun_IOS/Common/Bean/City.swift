//
//  City.swift
//  Project_ForFun_IOS
//
//  Created by 姜宗暐 on 2021/7/25.
//

import Foundation

class City : Codable {
    var cityId: Int;
    var cityName: String;
    var createTime: Date;
    var updateTime: Date?;
    var deleteTime: Date?;
}

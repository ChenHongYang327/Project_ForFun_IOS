//
//  CityAreaUtil.swift
//  Project_ForFun_IOS
//
//  Created by 姜宗暐 on 2021/7/25.
//

import Foundation

class CityAreaUtil {
    static let instance = CityAreaUtil()
    
    var cityList = [City]();
    var areaList = [Area]();
    var areaMap = [Int : [Area]]();
    
    private init() {
        // 取得縣市級行政區資料
        let url = URL(string: common_url + "getCityAreaData")
        
        let requestParam = ["action" : "getAll"]
        
        executeTask(url!, requestParam) { data, resp, error in
            if let data = data {
                do {
                    // 解析資料
                    let respDic = try JSONDecoder().decode([String : String].self, from: data)
//                    let respDic = try JSONSerialization.jsonObject(with: data) as? [String : String]
//                    print(respDic!["city"])
//                    print(respDic!["area"])
                    
                    // 設定轉換的日期格式
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    self.cityList = try decoder.decode([City].self, from: (respDic["city"]?.data(using: .utf8))!)
                    self.areaList = try decoder.decode([Area].self, from: (respDic["area"]?.data(using: .utf8))!)
                    
//                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                    print(dateFormatter.string(from: self.cityList[0].createTime))
//                    print(self.areaList[0].createTime)
                    
                    // 資料整理
                    for area in self.areaList {
                        if (self.areaMap[area.cityId!] == nil) {
                            var areaList = [Area]()
                            areaList.append(area)
                            
                            self.areaMap[area.cityId!] = areaList
                        } else {
                            self.areaMap[area.cityId!]?.append(area)
                        }
                    }

//                    for value in self.areaMap.values {
//                        for area in value {
//                            print("cityId : \(area.cityId) ___  areaID : \(area.areaId) ___ areaName : \(area.areaName)")
//                        }
//                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

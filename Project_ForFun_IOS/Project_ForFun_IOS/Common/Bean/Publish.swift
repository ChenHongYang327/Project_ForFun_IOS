

import Foundation

struct Publish:Codable {
    var publishId: Int
    var ownerId: Int
    var title: String
    var titleImg: String?
    var publishInfo: String
    var publishImg1: String?
    var publishImg2: String?
    var publishImg3: String?
    var cityId: Int?
    var areaId: Int?
    var address: String
    var latitude: Double
    var longitude:Double
    var rent: Int?
    var deposit: Int?
    var square: Int?
    var gender: Int?
    var type: Int?
    var furnished: Int?
    var status: Int?
    var createTime: Date?
    var updateTime: Date?
    var deleteTime: Date?
    
    public init( _ publishId: Int, _ ownerId: Int,_ title: String, _ titleImg: String?, _ publishInfo: String,_ publishImg1: String?,_ publishImg2: String?,_ publishImg3: String?,_ cityId: Int?,_ areaId: Int?,_ address: String,_ latitude: Double,_ longitude:Double,_ rent: Int?,_ deposit: Int?,_ square: Int?,_ gender: Int?,_ type: Int?,_ furnished: Int?,_ status: Int?,_ createTime: Date?,_ updateTime: Date?,_ deleteTime: Date?){
        self.publishId = publishId
        self.ownerId = ownerId
        self.title = title
        self.titleImg = titleImg
        self.publishInfo = publishInfo
        self.publishImg1 = publishImg1
        self.publishImg2 = publishImg2
        self.publishImg3 = publishImg3
        self.cityId = cityId
        self.areaId = areaId
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.rent = rent
        self.deposit = deposit
        self.square = square
        self.gender = gender
        self.type = type
        self.furnished = furnished
        self.createTime = createTime
        self.updateTime = updateTime
        self.deleteTime = deleteTime
        self.status = status
    }
}

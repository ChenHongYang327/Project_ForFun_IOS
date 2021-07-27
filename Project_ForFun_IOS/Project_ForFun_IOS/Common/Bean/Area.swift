import Foundation

struct Area: Codable {
    var areaId: Int
    var cityId: Int?
    var areaName: String?
    var createTime: Date?
    var updateTime: Date?
    var deleteTime: Date?
    
    public init( _ areaId: Int,_ cityId: Int?,_ areaName: String?,_ createTime: Date?,_ updateTime: Date?,_ deleteTime: Date?){
        self.areaId = areaId
        self.cityId = cityId
        self.areaName = areaName
        self.createTime = createTime
        self.updateTime = updateTime
        self.deleteTime = deleteTime
    }
}

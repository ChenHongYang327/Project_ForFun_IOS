
import Foundation

struct City:Codable {
    var cityId: Int
    var cityName: String?
    var createTime: Date?
    var updateTime: Date?
    var deleteTime: Date?
    
    public init( _ cityId: Int,_ cityName: String?,_ createTime: Date?,_ updateTime: Date?,_ deleteTime: Date?){
        self.cityId = cityId
        self.cityName = cityName
        self.createTime = createTime
        self.updateTime = updateTime
        self.deleteTime = deleteTime
    }
}

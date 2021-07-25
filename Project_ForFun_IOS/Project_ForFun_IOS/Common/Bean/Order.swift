
import Foundation

struct Order: Codable {
    var orderId: Int
    var publishId: Int?
    var teantId: Int?
    var publishStar: Int?
    var publishComment: String?
    var orderStatus: Int?
    var read: Bool?
    var createTime: Date?
    var updateTime: Date?
    var deleteTime: Date?
    
    public init (_ orderId: Int,_ publishId: Int?,_ teantId: Int?,_ publishStar: Int?,_ publishComment: String?,_ orderStatus: Int?,_ read: Bool?,_ createTime: Date?,_ updateTime: Date?,_ deleteTime: Date?){
        self.orderId = orderId
        self.publishId = publishId
        self.teantId = teantId
        self.publishStar = publishStar
        self.publishComment = publishComment
        self.orderStatus = orderStatus
        self.read = read
        self.createTime = createTime
        self.updateTime = updateTime
        self.deleteTime = deleteTime
    }
}

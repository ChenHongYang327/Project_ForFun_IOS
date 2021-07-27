
import Foundation

struct Message: Codable {
    var msgId: Int
    var chatRoomId: Int
    var memberId: Int
    var msgChat: String?
    var msgImg: String?
    var record: String?
    var read: Bool?
    var createTime: Date?
    var updateTime: Date?
    var deleteTime: Date?
    
    public init(_ msgId: Int, _ chatRoomId: Int, _ memberId: Int, _ msgChat: String?, _ msgImg: String?, _ record: String?, _ read: Bool?, _ createTime: Date?, _ updateTime: Date?, _ deleteTime: Date?){
        self.msgId = msgId
        self.chatRoomId = chatRoomId
        self.memberId = memberId
        self.msgChat = msgChat
        self.msgImg = msgImg
        self.record = record
        self.read = read
        self.createTime = createTime
        self.updateTime = updateTime
        self.deleteTime = deleteTime
    }
}

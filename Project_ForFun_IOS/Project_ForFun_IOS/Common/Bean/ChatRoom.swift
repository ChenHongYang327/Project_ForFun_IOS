

import Foundation

struct ChatRoom: Codable {
    var chatRoomId: Int
    var memberId1: Int?
    var memberId2: Int?
    var createTime: Date?
    var updateTime: Date?
    var deleteTime: Date?
    
    public init(_ chatRoomId: Int, _ memberId1: Int?, _ memberId2: Int?, _ createTime: Date?, _ updateTime: Date?, _ deleteTime: Date?){
        self.chatRoomId = chatRoomId
        self.memberId1 = memberId1
        self.memberId2 = memberId2
        self.createTime = createTime
        self.updateTime = updateTime
        self.deleteTime = deleteTime
    }
    
}



import Foundation

struct Comment: Codable {
    var commentId: Int
    var memberId: Int
    var postId: Int
    var commentMsg: String?
    var read: Bool?
    var createTime: Date?
    var updateTime: Date?
    var deleteTime: Date?
    
    public init( _ commentId: Int, _ memberId: Int, _ postId: Int, _ commentMsg: String?, _ read: Bool?, _ createTime: Date?, _ updateTime: Date?, _ deleteTime: Date?){
        self.commentId = commentId
        self.memberId = memberId
        self.postId = postId
        self.commentMsg = commentMsg
        self.read = read
        self.createTime = createTime
        self.updateTime = updateTime
        self.deleteTime = deleteTime
    }
}

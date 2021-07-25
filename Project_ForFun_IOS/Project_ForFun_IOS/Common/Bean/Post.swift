
import Foundation

struct Post: Codable {
    var postId: Int
    var boardId: Int?
    var posterId: Int?
    var postTitle: String?
    var postImg: String?
    var content: String?
    var createTime: Date?
    var updateTime: Date?
    var deleteTime: Date?
    
    public init(_ postId: Int, _ boardId: Int?, _ posterId: Int?, _ postTitle: String?, _ postImg: String?, _ content: String?, _ createTime: Date?, _ updateTime: Date?, _ deleteTime: Date?){
        self.postId = postId
        self.boardId = boardId
        self.posterId = posterId
        self.postTitle = postTitle
        self.postImg = postImg
        self.content = content
        self.createTime = createTime
        self.updateTime = updateTime
        self.deleteTime = deleteTime
    }
}

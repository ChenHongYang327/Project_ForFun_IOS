
import Foundation

struct Report:Codable {
    var reportId: Int
    var whistleblowerId: Int
    var reportedId: Int
    var type: Int
    var message: String?
    var reportClass: Int
    var postId: Int?
    var chatroomId: Int?
    var item: Int
    var createTime: Date?
    var deleteTime: Date?
    
    enum CodingKeys: String, CodingKey {
           case reportId = "report_id"
           case whistleblowerId = "whistleblower_id"
           case reportedId = "reported_id"
           case type
           case message
           case reportClass = "report_class"
           case postId = " post_id"
           case chatroomId = "chatroom_id "
           case item
           case createTime
           case deleteTime
           
       }
    
    public init( _ reportId: Int, _ whistleblowerId: Int, _ reportedId: Int,_ type: Int, _ message: String?,_ reportClass: Int, _ postId: Int?,_ chatroomId: Int?,_ item: Int,_ createTime: Date?,_ deleteTime: Date?){
        self.reportId = reportId
        self.whistleblowerId = whistleblowerId
        self.reportedId = reportedId
        self.type = type
        self.message = message
        self.reportClass = reportClass
        self.postId = postId
        self.chatroomId = chatroomId
        self.item = item
        self.createTime = createTime
        self.deleteTime = deleteTime
    }
}

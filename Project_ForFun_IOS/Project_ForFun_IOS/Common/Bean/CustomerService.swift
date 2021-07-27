

import Foundation

struct CustomerServise:Codable {
    var customerId: Int
    var type: Int
    var memnerId: Int?
    var nickName: String?
    var mail: String?
    var phone: Int?
    var msg: String?
    var createTime: Date?
    var deleteTime: Date?
    
    public init(_ customerId: Int, _ type: Int, _ memnerId: Int?, _ nickName: String?,_ mail: String?, _ phone: Int?,_ msg: String?, _ createTime: Date?,_ deleteTime: Date?){
        self.customerId = customerId
        self.type = type
        self.memnerId = memnerId
        self.nickName = nickName
        self.mail = mail
        self.phone = phone
        self.msg = msg
        self.createTime = createTime
        self.deleteTime = deleteTime
    }
}

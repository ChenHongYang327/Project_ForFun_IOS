import Foundation
struct Member:Codable{
    var memberId:Int
    var role:Int
    var nameL:String
    var nameF:String
    var phone:Int
    var headshot:String
    var gender:Int
    var id:String
    var birthday:Date?
    var address:String
    var mail:String
    var type:Int
    var token:String?
    var idImgf:String
    var idImgb:String
    var citizen:String?
    var createTime:String
    var updateTime:String?
    var deleteTime:String?
    //時間轉字串
//    var createTimeStr: String {
//        let format = DateFormatter()
//        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        return format.string(from: createTime)
//    }
//    var updateTimeStr: String {
//        if updateTime != nil {
//            let format = DateFormatter()
//            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            return format.string(from: updateTime!)
//        } else {
//            return ""
//        }
//    }
//    var deleteTimeStr: String {
//        if deleteTime != nil {
//            let format = DateFormatter()
//            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            return format.string(from: deleteTime!)
//        } else {
//            return ""
//        }
//    }
    
}

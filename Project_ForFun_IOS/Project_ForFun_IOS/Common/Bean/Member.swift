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
    var creatTime:Date?
    var updateTime:Date?
    var deleteTime:Date?
    
    public init(_ memberId:Int,_ role:Int, _ nameL:String, _ nameF:String, _ phone:Int, _ headshot:String, _ gender:Int,_ id:String, _ birthday:Date?, _ address:String, _ mail:String, _ type:Int, _ token:String?, _ idImgf:String, _ idImgb:String,_ citizen:String?, _ creatTime:Date?, _ updateTime:Date?, _ deleteTime:Date?){
        self.memberId = memberId
        self.role = role
        self.nameL = nameL
        self.nameF = nameF
        self.phone = phone
        self.headshot = headshot
        self.gender = gender
        self.id = id
        self.birthday = birthday
        self.address = address
        self.mail = mail
        self.type = type
        self.token = token
        self.idImgf = idImgf
        self.idImgb = idImgb
        self.citizen = citizen
        self.creatTime = creatTime
        self.updateTime = updateTime
        self.deleteTime = deleteTime
        
    }
}

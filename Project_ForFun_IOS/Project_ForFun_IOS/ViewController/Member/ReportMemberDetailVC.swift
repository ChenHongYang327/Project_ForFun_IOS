//
//  ReportMemberDetailVC.swift
//  Project_ForFun_IOS
//
//  Created by WEI on 2021/8/8.
//

import UIKit

class ReportMemberDetailVC: UIViewController {
    var report:Report!
    var reported:Member!
    var data:Data?//被檢舉者的頭像
    var whistleblower:Member!
    let url = URL(string: common_url + "reportMemberController")
    @IBOutlet weak var reportedName: UILabel!
    @IBOutlet weak var ivReport: UIImageView!
    @IBOutlet weak var ivWhistleblower: UIImageView!
    @IBOutlet weak var whistleblowerName: UILabel!
    @IBOutlet weak var reportMessage: UILabel!
    @IBOutlet weak var memberDetail1: UIButton!
    @IBOutlet weak var memberDetail2: UIButton!
    @IBOutlet weak var memberPrivate1: UIButton!
    @IBOutlet weak var memberPrivate2: UIButton!
    @IBOutlet weak var btSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="檢舉詳細"
        if data != nil{
            ivReport.image=UIImage(data: data!)
        }
        //防止圖片未載入完成就點選就再抓一次圖
        else if(data == nil){
//                print("圖片未載入完成")
            //從FireStore下載圖片
            getImage(url: reported.headshot) { data in
                self.ivReport.image=UIImage(data: data!)
            }
        }
        setData()
    }
    func setData() {
        reportedName.text="\(reported.nameL)\(reported.nameF)"
        reportMessage.text=report.message==nil ? "檢舉原因:無" : "檢舉原因:\(report.message!)"
        // JSON含有日期時間，解析必須指定日期時間格式
        let decoder = JSONDecoder()
        let format = DateFormatter()
        //後端沒設定GSON日期的格式
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(format)
        var requestParam=[String : Any]()
        requestParam["action"]="selectMember"
        requestParam["memberId"]=report.whistleblowerId
        executeTask(url!, requestParam) { data, resp, error in
            if(error != nil){
                print(error!)
                return
            }
            //檢查伺服器連線狀態
            if let httpResponse = resp as? HTTPURLResponse {
                if(httpResponse.statusCode != 200){
                    print("與伺服器連線狀態碼:\(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                    showSimpleAlert(message: "請嘗試將伺服器重新啟動", viewController: self)
                    }
                }
               }
            if let data = data{
                do {
//                    print(String(data: data!, encoding: .utf8))
                    let result = try JSONDecoder().decode(Member.self, from: data)
                    self.whistleblower=result
                    DispatchQueue.main.async {
                        getImage(url: result.headshot) { data in
                            self.ivWhistleblower.image=UIImage(data: data!)
                        }
                        self.whistleblowerName.text="\(result.nameL)\(result.nameF)"
                    }
                                            
                }
                catch {
                    print(error)
                }
            }
    }

    }
    @IBAction func goMemberDetail(_ sender: UIButton) {
        //指定storyboard(當前的可不寫)
        let storyboard = UIStoryboard(name: "MemberStoryboard", bundle: nil)
        //取得頁面
        let memberDetailVC = storyboard.instantiateViewController(withIdentifier: "memberDetailVC") as! MemberDatailVC
        if(sender==memberDetail1){
                //將值指定給下頁
                memberDetailVC.member=whistleblower
                //將前一頁的data(頭貼)帶到下一頁減少抓圖次數
                memberDetailVC.data=ivWhistleblower.image?.jpegData(compressionQuality: CGFloat(1.0))
                //跳轉
                self.navigationController?.pushViewController(memberDetailVC, animated: true)
        }
        else if(sender==memberDetail2){
            //將值指定給下頁
            memberDetailVC.member=reported
            //將前一頁的data(頭貼)帶到下一頁減少抓圖次數
            memberDetailVC.data=ivReport.image?.jpegData(compressionQuality: CGFloat(1.0))
            //跳轉
            self.navigationController?.pushViewController(memberDetailVC, animated: true)
            
        }
    }
    
    @IBAction func getPrivateDetail(_ sender: UIButton) {
        //取得頁面
        let reportMemberPrivateVC = self.storyboard!.instantiateViewController(withIdentifier: "reportMemberPrivateVC") as! ReportMemberPrivateVC
        if(sender==memberPrivate1){
                //將值指定給下頁
            reportMemberPrivateVC.member=whistleblower
                //跳轉
                self.navigationController?.pushViewController(reportMemberPrivateVC, animated: true)
        }
        else if(sender==memberPrivate2){
            //將值指定給下頁
            reportMemberPrivateVC.member=reported
            //跳轉
            self.navigationController?.pushViewController(reportMemberPrivateVC, animated: true)
            
        }
        
        
    }
    
    
    @IBAction func submit(_ sender: Any) {
        showAlert(message: "結案後將無法再開啟", viewController: self) {
            self.submitReport()
        }
    }
    
    func submitReport(){
        var requestParam=[String : Any]()
        requestParam["action"]="updateReport"
        requestParam["reportId"]=self.report.reportId
        executeTask(url!, requestParam) {data, resp, error in
            if(error != nil){
           
                print(error!)
                return
            }
            //檢查伺服器連線狀態
            if let httpResponse = resp as? HTTPURLResponse {
                if(httpResponse.statusCode != 200){
                    print("與伺服器連線狀態碼:\(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                    showSimpleAlert(message: "請嘗試將伺服器重新啟動", viewController: self)
                    }
                }
            }
            if let data=data{
                do {
                    let result = try JSONDecoder().decode([String:Int].self, from: data)
                    if(result["result"]==0){
                        DispatchQueue.main.async {
                        showSimpleAlert(message: "更新失敗", viewController: self)
                        }
                    }
                    else if(result["result"]==1){
                        DispatchQueue.main.async {
                        showSimpleAlert(message: "更新成功", viewController: self)
                        self.btSubmit.isEnabled=false
                        }
                    }
                }
                catch {
                    print(error)
                }
            }
        
        }
    }
    
}

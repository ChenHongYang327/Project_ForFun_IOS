//
//  HouseOwnerDetailVC.swift
//  Project_ForFun_IOS
//
//  Created by WEI on 2021/7/31.
//

import UIKit

class HouseOwnerDetailVC: UIViewController {
    var member:Member!
    var data:Data?
    
    @IBOutlet weak var ivHeadshot: UIImageView!
    @IBOutlet weak var lbMemberId: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbGender: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbRole: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbCreatTime: UILabel!
    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var ivIdF: UIImageView!
    @IBOutlet weak var ivIdb: UIImageView!
    @IBOutlet weak var lbGoodPeople: UILabel!
    @IBOutlet weak var ivGoodPeople: UIImageView!
    @IBOutlet weak var btPass: UIButton!
    @IBOutlet weak var btNopass: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var secondView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if data != nil{
            ivHeadshot.image=UIImage(data: data!)
        }
        //防止圖片未載入完成就點選就再抓一次圖
        else if(data == nil||ivHeadshot.image==UIImage(named: "noimage")){
//                print("圖片未載入完成")
            getImage(url: member.headshot) { data in
                self.ivHeadshot.image = UIImage(data: data!)
            }
        }
        setData()
        // Do any additional setup after loading the view.
    }
    
    func setData()
    {
        lbMemberId.text="會員ID:\(member.memberId)"
        lbName.text="姓名:\(member.nameL+member.nameF)"
        lbGender.text="性別:\(member.gender==1 ?"男":"女")"
        lbPhone.text="電話:0\(member.phone)"
        lbCreatTime.text="註冊時間:\n\(member.createTime)"
        getImage(url: member.idImgf) { data in
            self.ivIdF.image = UIImage(data: data!)
        }
        getImage(url: member.idImgb) { data in
            self.ivIdb.image = UIImage(data: data!)
        }
        //會進來的都是有良民證的
        getImage(url: member.citizen!) { data in
            self.ivGoodPeople.image = UIImage(data: data!)
        }
        switch member.role {
        case 0:
            lbRole.text="帳號權限:管理員"
        case 1:
            lbRole.text="帳號權限:房客"
        case 2:
            lbRole.text="帳號權限:房東"
        default:
            lbRole.text="帳號權限:設定錯誤"
        }
        
        switch member.type {
        case 0:
            lbType.text="帳號狀態:停權中"
        case 1:
            lbType.text="帳號狀態:開通中"
        default:
            lbType.text="帳號狀態:設定錯誤"
        }
        lbId.text="身分證號碼:\(member.id)"
        lbGoodPeople.text="良民證:"
      
    }
    @IBAction func pass(_ sender: Any) {
        member.role=2
        sendReq()
        btPass.setTitleColor(.black, for: .normal)
        
    }
    @IBAction func noPass(_ sender: Any) {
        member.role=1
        member.citizen=nil
        sendReq()
        btNopass.setTitleColor(.black, for: .normal)
    }
   
    func sendReq(){
        let url = URL(string: common_url + "adminMemberController")
        var requestParam = [String:Any]()
        requestParam["action"] = "applyMemberResult"
        //將物件轉換成JSON格式
        requestParam["member"] = try? String(data: JSONEncoder().encode(member), encoding: .utf8)
//        print("轉成JSON後的格式\(requestParam["member"]!)")
        executeTask(url!, requestParam) { data, resp, error in
            //錯誤
            if let error = error{
                DispatchQueue.main.async {
                showSimpleAlert(message: "請先檢查與伺服器的連線狀態", viewController: self)
                }
                print(error)
                return
            }
            if let httpResponse = resp as? HTTPURLResponse {
                print("與伺服器連線狀態碼:\(httpResponse.statusCode)")
                if(httpResponse.statusCode != 200){
                    DispatchQueue.main.async {
                    showSimpleAlert(message: "請嘗試將伺服器重新啟動", viewController: self)
                    }
                }
               }
            if let data = data{
                do {
                    let result = try JSONDecoder().decode([String:Bool].self, from: data)
                    //更新成功
                    if (result["result"]!){
                            DispatchQueue.main.async {
                            showSimpleAlert(message: "更新成功", viewController: self)
                                self.btPass.isEnabled=false
                                self.btNopass.isEnabled=false
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                        showSimpleAlert(message: "更新失敗", viewController: self)
                    }
                    }
                }
                catch  {
                    print(error)
                }
          
               
            }
        }
    
}
    @IBAction func clickHeadShot(_ sender: UILongPressGestureRecognizer) {
        ivHeadshot.tag=1
        controlView(sender: sender, imageView: ivHeadshot)
    }

    @IBAction func clickId1(_ sender: UILongPressGestureRecognizer) {
        ivIdF.tag=1
        controlView(sender: sender, imageView: ivIdF)

    }

    @IBAction func clickId2(_ sender: UILongPressGestureRecognizer) {
        ivIdb.tag=1
        controlView(sender: sender, imageView: ivIdb)
    }

    @IBAction func clickGoodPeople(_ sender: UILongPressGestureRecognizer) {
        ivGoodPeople.tag=1
        controlView(sender: sender, imageView: ivGoodPeople)
    }

    func controlView(sender: UILongPressGestureRecognizer,imageView: UIImageView){
//        let y = (UIScreen.main.bounds.height-(imageView.frame.origin.y*0.5)) * 0.5
        let y = (UIScreen.main.bounds.height+scrollView.contentOffset.y)/2
//        let y = view.frame.origin.y/2
        //元件的比例
        let scale = UIScreen.main.bounds.width / imageView.bounds.width
        switch sender.state {
        case .began:
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            print(":\(y)")
            imageView.frame.origin.y += y < imageView.frame.origin.y ? -y: y
            
            for subView in secondView.subviews{
                if(subView.tag != 1){
                    subView.alpha=0.4
                }
            }

        case .ended:
            imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            imageView.frame.origin.y -= y < imageView.frame.origin.y ? y: -y
            print("::\(y)")
            for subView in secondView.subviews{
                if(subView.tag != 1){
                    subView.alpha=1
                }
            }
            imageView.tag=0//恢復預設
        default:
            break
    }
}
}

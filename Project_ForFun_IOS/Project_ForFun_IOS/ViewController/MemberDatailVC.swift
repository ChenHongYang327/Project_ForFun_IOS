//
//  MemberDatailVC.swift
//  Project_ForFun_IOS
//
//  Created by WEI on 2021/7/26.
//

import UIKit
import FirebaseStorage

class MemberDatailVC: UIViewController {
    var member:Member!
//    var updateMember:Member!
    var data:Data?
    var types=[String]()
    var roles=[String]()
    @IBOutlet weak var ivHeadshot: UIImageView!
    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbGender: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbRole: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbCreatTime: UILabel!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var rolePicker: UIPickerView!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var btRole: UIButton!
    @IBOutlet weak var btType: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateMember=member
        self.title="會員資訊"
        tfPhone.isHidden=true
        //開啟編輯按鈕
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.title="編輯"
            if data != nil{
                ivHeadshot.image=UIImage(data: data!)
            }
            //防止圖片未載入完成就點選就再抓一次圖
            else if(data == nil||ivHeadshot.image==UIImage(named: "noimage")){
//                print("圖片未載入完成")
                //從FireStore下載圖片
                let imageRef = Storage.storage().reference().child(member.headshot)
                // 設定最大可下載10M
                imageRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                    if let imageData = data {
                        self.ivHeadshot.image = UIImage(data: imageData)
                    } else {
                        self.ivHeadshot.image = UIImage(named: "noimage")
                        print(error != nil ? error!.localizedDescription : "Downloading error!")
                    }
                }
            }
        
        setData()
        setTypePicker()
        setRolePicker()
        
    }
    //覆寫編輯按鈕
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        //點擊編輯
        if(editing==true){
        editButtonItem.title="完成"
        tfPhone.isHidden=false
        lbPhone.text="電話:"
        tfPhone.text="0\(member.phone)"
        btRole.isEnabled=true
        btType.isEnabled=true
        }
        //點擊完成
        else{
            editButtonItem.title="編輯"
            guard let phone=tfPhone.text?.trimmingCharacters(in: .whitespaces) else{
                showSimpleAlert(message: "電話號碼不可為空", viewController: self)
                return
            }
            if(phone.isEmpty){
                showSimpleAlert(message: "電話號碼不可為空", viewController: self)
                return
            }
            else if(phone.count != 10){
                showSimpleAlert(message: "電話號碼格式錯誤", viewController: self)
                return
            }
        lbPhone.text="電話:\(phone)"
        tfPhone.isHidden=true
        btRole.isEnabled=false
        btType.isEnabled=false
        }

    }

    func setData() {
        lbId.text="會員ID:\(member.memberId)"
        lbName.text="姓名:\(member.nameL+member.nameF)"
        lbGender.text="性別:\(member.gender==1 ?"男":"女")"
        lbPhone.text="電話:0\(member.phone)"
        lbCreatTime.text="註冊時間:\n\(member.createTimeStr)"
        lbRole.text="帳號權限:"
        lbType.text="帳號狀態:"
        switch member.role {
        case 0:
            btRole.setTitle("管理員", for: UIControl.State.normal)
        case 1:
            btRole.setTitle("房客", for: UIControl.State.normal)
        case 2:
            btRole.setTitle("房東", for: UIControl.State.normal)
        default:
            btRole.setTitle("設定異常", for: UIControl.State.normal)
        }
        switch member.type {
        case 0:
            btType.setTitle("停權中", for: UIControl.State.normal)
        case 1:
            btType.setTitle("開通中", for: UIControl.State.normal)
        default:
            btType.setTitle("設定異常", for: UIControl.State.normal)
        }
        
    }
    

    
    @IBAction func showRole(_ sender: Any) {
        rolePicker.selectRow(member.role, inComponent: 0, animated: false)
        typePicker.isHidden=true
        rolePicker.isHidden=false
    }
    
    @IBAction func showType(_ sender: Any) {
        typePicker.selectRow(member.type, inComponent: 0, animated: false)
        typePicker.isHidden=false
        rolePicker.isHidden=true
    }
    
   
}
extension MemberDatailVC: UIPickerViewDataSource,UIPickerViewDelegate{
    
    func setTypePicker(){
        types.insert("停權中", at: 0)
        types.insert("開通中", at: 1)
        
    }
    
    func setRolePicker(){
        roles.insert("管理員", at: 0)
        roles.insert("房客", at: 1)
        roles.insert("房東", at: 2)
    }
    /* 希望picker view一次顯示幾個欄位的選項 */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    /* 產生picker view時會自動呼叫此方法以取得選項數 */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case rolePicker:
            return  roles.count
        case typePicker:
            return  types.count
        default:
            return 0
   
        }
    }
    /* picker view顯示時會自動呼叫此方法以取得欲顯示的選項名稱 */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case rolePicker:
            return  roles[row]
        case typePicker:
            return  types[row]
        default:
            return ""
        }
    }
    
    // 選中時呼叫
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case rolePicker:
            rolePicker.isHidden=true
            member.role=row
            btRole.setTitle(roles[row], for: UIControl.State.normal)
//            print("原始權限\(member.role)")
//            print("更新後權限\(updateMember.role)")
        case typePicker:
            typePicker.isHidden=true
            member.type=row
            btType.setTitle(types[row], for:UIControl.State.normal)
//            print("原始權限\(member.type)")
//            print("更新後權限\(updateMember.type)")
        default: break
          
        }
        
       
    }
    
}


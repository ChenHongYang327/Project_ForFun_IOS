//
//  MemberDatailVC.swift
//  Project_ForFun_IOS
//
//  Created by WEI on 2021/7/26.
//

import UIKit

class MemberDatailVC: UIViewController {
    var member:Member!
    var data:Data?
    var updateResp=false
    var types=[String]()
    var roles=[String]()
    var roleIsSelect=false //判斷點選哪一個
    @IBOutlet weak var ivHeadshot: UIImageView!
    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbGender: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbRole: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbCreatTime: UILabel!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var btRole: UIButton!
    @IBOutlet weak var btType: UIButton!
    @IBOutlet var selectView: UIView!
    @IBOutlet weak var selectNote: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="會員資訊"
        ivHeadshot.isUserInteractionEnabled = true
        tfPhone.isHidden=true
        //開啟編輯按鈕
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.title="編輯"
            if data != nil{
                ivHeadshot.image=UIImage(data: data!)
            }
            //防止圖片未載入完成就點選就再抓一次圖
            else if(data == nil||ivHeadshot.image==UIImage(named: "noimage.jpg")){
//                print("圖片未載入完成")
                //從FireStore下載圖片
                getImage(url: member.headshot) { data in
                    self.ivHeadshot.image=UIImage(data: data!)
                }
            }
        
        setData()
        setTypePicker()
        setRolePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardObserver() //初始化鍵盤監聽
        self.view.addSubview(selectView)//將子view加入
        selectView.translatesAutoresizingMaskIntoConstraints=false//關閉AutoResize避免排版問題
        selectView.heightAnchor.constraint(equalToConstant: 150).isActive=true//設定高度並執行
        selectView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10).isActive=true //view的左邊x軸座標此view的x軸座標
        selectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive=true //view的右邊x軸座標此view的x軸座標
        let toHide=selectView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 150)
        //設定與高同數值用來隱藏此view
        toHide.identifier = "bottom"
        toHide.isActive=true
//        selectView.layer.cornerRadius = 10 //圓角
        
        
        
        
        super.viewWillAppear(true)
    }
    //呼叫此方法按下return即可隱藏鍵盤
    @IBAction func didEndOnExit(_ sender: Any) {
    }
    
    //背景點擊監聽點擊背景隱藏鍵盤
    @IBAction func touchDown(_ sender: Any) {
        //停止textfield的Focus(?)
        tfPhone.resignFirstResponder()
    }
    
    //座標移動會重複呼叫(未完成)
    @IBAction func picLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            ivHeadshot.transform = CGAffineTransform(scaleX: 2, y: 2)
//            ivHeadshot.center=self.view.center
//            ivHeadshot.frame.origin
//            ivHeadshot.frame.origin.y=UIScreen.main.bounds.width/2
        case .ended:
            ivHeadshot.transform = CGAffineTransform(scaleX: 1, y: 1)
        default:
            break
        }
    }
    
    
    
    
    //覆寫編輯按鈕
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        //點擊編輯
        if(editing==true){
        //停止textfield的Focus(?)
        tfPhone.resignFirstResponder()
        editButtonItem.title="完成"
        tfPhone.isHidden=false
        lbPhone.text="電話:"
        tfPhone.text="0\(member.phone)"
        btRole.isEnabled=true
        btType.isEnabled=true
        }
        //點擊完成
        else{
            //停止textfield的Focus(?)
            tfPhone.resignFirstResponder()
            guard let inputPhone=tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) else{
                showSimpleAlert(message: "電話號碼不可為空", viewController: self)
                editButtonItem.title="完成"
                setEditing(true, animated: false) //會重新呼叫setEditing
                return
            }
            if(inputPhone.isEmpty){
                showSimpleAlert(message: "電話號碼不可為空", viewController: self)
                editButtonItem.title="完成"
                setEditing(true, animated: false) //會重新呼叫setEditing
                return
            }
            else if(inputPhone.count != 10){
                showSimpleAlert(message: "電話號碼格式錯誤", viewController: self)
                editButtonItem.title="完成"
                setEditing(true, animated: false) //會重新呼叫setEditing
                return
            }
        let phone = Int(inputPhone) ?? -1
        if(phone == -1){
        showSimpleAlert(message: "電話號碼格式錯誤", viewController: self)
         }
        member.phone=phone //設定新的電話
        sendReq { updateState in
                if(updateState){
                    DispatchQueue.main.async {
                    //恢復顯示
                    self.editButtonItem.title="編輯"
                    self.tfPhone.isHidden=true
                    self.btRole.isEnabled=false
                    self.btType.isEnabled=false
                    //將view歸位
                    for toHide in self.view.constraints{
                     if toHide.identifier == "bottom"{
                        toHide.constant = 150
                        break
                        }
                    }
                    self.lbPhone.text="電話:0\(self.member.phone)"
                    }
                }
                else{
                    DispatchQueue.main.async {
                    self.editButtonItem.title="完成"
                    }
                }
                
            }
        
        }

    }

    func setData() {
        lbId.text="會員ID:\(member.memberId)"
        lbName.text="姓名:\(member.nameL+member.nameF)"
        lbGender.text="性別:\(member.gender==1 ?"男":"女")"
        lbPhone.text="電話:0\(member.phone)"
        lbCreatTime.text="註冊時間:\n\(member.createTime)"
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
    //修改會員資料
    func sendReq(completionHandler:@escaping (Bool)->Void){
        let url = URL(string: common_url + "adminMemberController")
        var requestParam = [String:Any]()
        requestParam["action"] = "updateMember"
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
                    let result = try JSONDecoder().decode([String:Int].self, from: data)
                    if (result["pass"]==0){
                        completionHandler(true)
                            DispatchQueue.main.async {
                                showSimpleAlert(message: "更新成功", viewController: self)
                                }
                        }
                    else if(result["pass"]==1){
                        completionHandler(false)
                        DispatchQueue.main.async {
                        showSimpleAlert(message: "更新失敗", viewController: self)
                        self.editButtonItem.title="編輯"
                            self.setEditing(true, animated: true)
                        }
                    }
                    else if(result["pass"]==2){
                        completionHandler(false)
                        DispatchQueue.main.async {
                        showSimpleAlert(message: "電話號碼已被使用", viewController: self)
                        self.editButtonItem.title="編輯"
                            self.setEditing(true, animated: true)
                        }
                    }
                    else if(result["pass"]==3){
                        completionHandler(true)
                            DispatchQueue.main.async {
                                showSimpleAlert(message: "資料無變更", viewController: self)
                                }
                    }
                    else{
                    completionHandler(false)
                    }
                    }
                catch {
                    print(error)
                }
            }
        }
    }

    @IBAction func showCancel(_ sender: Any) {
        //將view歸位
        for toHide in view.constraints{
            if toHide.identifier == "bottom"{
                toHide.constant = 150
                break
            }
        }
    }
    
    
    
    @IBAction func showRole(_ sender: Any) {
        //停止textfield的Focus(?)
        tfPhone.resignFirstResponder()
        selectNote.text="請選擇變更後的帳號權限:"
        roleIsSelect=true
        picker.reloadAllComponents() //刷新picker
        picker.selectRow(member.role, inComponent: 0, animated: false)//選取預設
        for toHide in view.constraints{
            if toHide.identifier == "bottom"{
                toHide.constant = -5 //顯示view的底部間距
                break
            }
        }
//        picker.isHidden=false//顯示
    }
    
    @IBAction func showType(_ sender: Any) {
        //停止textfield的Focus(?)
        tfPhone.resignFirstResponder()
        selectNote.text="請選擇變更後的帳號狀態:"
        roleIsSelect=false
        picker.reloadAllComponents()  //刷新picker
        picker.selectRow(member.type, inComponent: 0, animated: false)//選取預設
        for toHide in view.constraints{
            if toHide.identifier == "bottom"{
                toHide.constant = -5
                break
            }
        }
//        picker.isHidden=false//顯示
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
        switch roleIsSelect {
        case true:
            return  roles.count
        case false:
            return  types.count
   
        }
    }
    /* picker view顯示時會自動呼叫此方法以取得欲顯示的選項名稱 */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch roleIsSelect {
        case true:
            return  roles[row]
        case false:
            return  types[row]
        }
    }
    
    // 選中時呼叫
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch roleIsSelect {
        case true:
            member.role=row
            btRole.setTitle(roles[row], for: UIControl.State.normal)
            roleIsSelect=false
            //將view歸位
            for toHide in view.constraints{
                if toHide.identifier == "bottom"{
                    toHide.constant = 150
                    break
                }
            }
        case false:
            member.type=row
            btType.setTitle(types[row], for:UIControl.State.normal)
            roleIsSelect=false
            //將view歸位
            for toHide in view.constraints{
                if toHide.identifier == "bottom"{
                    toHide.constant = 150
                    break
                }
            }
          
        }
        
       
    }
    
}
extension MemberDatailVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //第一次點擊輸入時隱藏view
        for toHide in view.constraints{
            if toHide.identifier == "bottom"{
                toHide.constant = 150
                break
            }
        }
        return true
    }
  
}
//鍵盤事件處理
extension MemberDatailVC{
    //定義方法增加監聽來處理特定事件
        func addKeyboardObserver() {
            //監聽鍵盤顯示
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            //監聽鍵盤隱藏
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        @objc func keyboardWillShow(notification: Notification) {
            // 能取得鍵盤高度就讓view上移鍵盤高度，否則上移view的1/3高度
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRect = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRect.height
                view.frame.origin.y = -keyboardHeight
            } else {
                view.frame.origin.y = -view.frame.height / 3
            }
        }
        
        @objc func keyboardWillHide(notification: Notification) {
            view.frame.origin.y = 0 //歸位
        }
        //當頁面消失時移除監聽(減少資源消耗)
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(true)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }

}



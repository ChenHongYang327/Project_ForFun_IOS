//
//  RegistVC.swift
//  Project_ForFun_IOS
//
//  Created by 陳鋐洋 on 2021/7/25.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    var phone=""
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var btLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btSend(_ sender: Any) {
        phone = tfPhone.text ?? "".trimmingCharacters(in: .whitespacesAndNewlines)
        if(phone.isEmpty){
            showSimpleAlert(message: "請輸入電話號碼", viewController: self)
            return
        }
        if(phone.count != 10){
            showSimpleAlert(message: "電話號碼格式錯誤", viewController: self)
            return
        }
        PhoneAuthProvider.provider().verifyPhoneNumber("+886\(phone)", uiDelegate: nil) { verificationID, error in
                  if let error = error {
                      // 發送驗證碼失敗
                      print("錯誤\(error)")
                      return
                  }
                  
                  // 將 ID 儲存到 UserDefaults 中，驗證時需要一起發送給 Firebase
                  UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
              }
        btLogin.alpha = 1
    }
    @IBAction func btSignin(_ sender: Any) {   let code = tfCode.text ?? "".trimmingCharacters(in: .whitespacesAndNewlines)
        if code.isEmpty{
            showSimpleAlert(message: "請輸入驗證碼", viewController: self)
            return
        }
        if (code.count != 6){
            showSimpleAlert(message: "驗證碼格式錯誤", viewController: self)
            return
        }
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
                   // 沒有 ID 就跳掉不處理
                   return
               }
               
               let credential = PhoneAuthProvider.provider().credential(
                   withVerificationID: verificationID,
                   verificationCode:code
               )
            
            
               // 送出驗證
                Auth.auth().languageCode = "zh-Hant";
               Auth.auth().signIn(with: credential) { authResult, error in
                   if let error = error {
                    let authError = error as NSError
                    if (authError.code == AuthErrorCode.invalidVerificationCode.rawValue){
                    DispatchQueue.main.async {
                    showSimpleAlert(message: "驗證碼輸入錯誤", viewController: self)
                     }
                       return
                    }
                   }
                   // 驗證成功後移除 ID
                   UserDefaults.standard.set(nil, forKey: "authVerificationID")
                   self.phoneSure(_phone: self.phone)
                   
               }
           }
    func phoneSure(_phone:String){
        let url = URL(string: common_url + "signInController")
        var requestParam = [String:Any]()
        requestParam["action"] = "rootSingIn"
        requestParam["phone"] = Int(tfPhone.text!)
        executeTask(url!, requestParam) { data, resp, error in
            //錯誤
            if(error != nil){
                logOut()
                print(error!)
                return
            }
            if let data = data{
                do {
                    let result = try JSONDecoder().decode([String:Int].self, from: data)
                    if (result["pass"]!==0){
                            print(result["pass"]!)
                            DispatchQueue.main.async {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                //成功驗證跳轉首頁
                                let homeNav = storyboard.instantiateViewController(identifier: "homeNav")
                                self.view.window?.rootViewController = homeNav
                            }
                        }
                    else if(result["pass"]!==1){
                        logOut()
                        DispatchQueue.main.async {
                        showSimpleAlert(message: "非管理者權限", viewController: self)
                        }
                    }
                    else if(result["pass"]!==2){
                        logOut()
                        DispatchQueue.main.async {
                        showSimpleAlert(message: "電話號碼尚未註冊", viewController: self)
                        }
                    }
                    }
                catch {
                    logOut()
                    print(error)
                }
            }
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

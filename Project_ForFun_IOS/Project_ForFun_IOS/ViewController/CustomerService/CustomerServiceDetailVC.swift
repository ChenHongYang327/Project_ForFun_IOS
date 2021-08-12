//
//  CustomerServiceDetailVC.swift
//  Project_ForFun_IOS
//
//  Created by 姜宗暐 on 2021/8/10.
//

import UIKit

class CustomerServiceDetailVC: UIViewController {
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var eMail: UILabel!
    @IBOutlet weak var reply: UITextView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    
    var customerServise : CustomerServise?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let customerServise = customerServise {
            nickname.text = customerServise.nickName
            message.text = customerServise.mag
            phone.text = customerServise.phone
            eMail.text = customerServise.mail
        }
        
        reply.backgroundColor = primaryColor
        addKeyboardObserver()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func callToUser(_ sender: Any) {
        if let customerServise = customerServise,
           let url = URL(string: "tel:\(customerServise.phone!)") {
            if (UIApplication.shared.canOpenURL(url)) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("無法開啟電話")
            }
        }
    }
    
    @IBAction func sendReply(_ sender: Any) {
        // 顯示loading畫面
        loadingAnimation.startAnimating()
        loadingView.isHidden = false
        
        let reply = reply.text ?? ""
        
        let url = URL(string: common_url + "CUSTOMER_SERVICE_Servlet")
        
        let requestParam: [String: Any] = ["action" : "sendMail",
                            "customerServiseId" : customerServise!.customerId,
                            "customerReply" : reply]
        
        executeTask(url!, requestParam) { data, resp, error in
            if let data = data {
                do {
                    // 解析資料
                    let respDic = try JSONDecoder().decode([String : Int].self, from: data)
                    
                    if let result = respDic["result_code"],
                       result == 1 {
                        // 取得資料後刷新畫面
                        DispatchQueue.main.async {
                            // 隱藏loading畫面
                            self.loadingAnimation.stopAnimating()
                            self.loadingView.isHidden = true
                            
                            showConfirmAlert(message: "發送成功", viewController: self) { uiAlertAction in
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } else {
                        // 取得資料後刷新畫面
                        DispatchQueue.main.async {
                            // 隱藏loading畫面
                            self.loadingAnimation.stopAnimating()
                            self.loadingView.isHidden = true
                            
                            showConfirmAlert(message: "發送失敗", viewController: self) { uiAlertAction in
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                    
//                    for publish in self.customerServiceList {
//                        print("\(publish.mag)")
//                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    @IBAction func clickReply(_ gesture: UITapGestureRecognizer) {
        if (gesture.state == .ended) {
            reply.text = "感謝您的回覆\n我們會盡快幫您處理\n請耐心等候\n\n謝謝"
        }
    }
        
    //背景點擊監聽點擊背景隱藏鍵盤
    @IBAction func touchDown(_ sender: Any) {
        //停止textfield的Focus(?)
        reply.resignFirstResponder()
    }
}

//鍵盤事件處理
extension CustomerServiceDetailVC {
    //呼叫此方法按下return即可隱藏鍵盤

    
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

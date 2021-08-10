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
                            showConfirmAlert(message: "發送成功", viewController: self) { uiAlertAction in
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } else {
                        // 取得資料後刷新畫面
                        DispatchQueue.main.async {
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
}

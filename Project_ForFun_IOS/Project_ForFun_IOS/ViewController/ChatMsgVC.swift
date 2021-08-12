//
//  ChatMsgVC.swift
//  Project_ForFun_IOS
//
//  Created by 陳鋐洋 on 2021/7/26.
//

import UIKit
import FirebaseStorage

class ChatMsgVC: UIViewController {
    var reportChatMsg: ReportChatMsg?

    @IBOutlet weak var tcmsgOrginal: UITextView!
    @IBOutlet weak var tvName: UILabel!
    @IBOutlet weak var tvType: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var imgHead: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let member = reportChatMsg!.member
        let comment = reportChatMsg!.comment
        
        
        print(member.nameL+comment.commentMsg!)
        
        
        tvName.text = member.nameL+member.nameF
        tvContent.text = reportChatMsg?.message
        tcmsgOrginal.text = comment.commentMsg
        
        switch reportChatMsg?.reportClass {
        case 0:
            tvType.text = "冒充他人"
        case 1:
            tvType.text = "謾罵他人"
        case 2:
            tvType.text = "不當留言"
        case 3:
            tvType.text = "內容誇大"
        case 4:
            tvType.text = "態度惡劣"
        default:
            tvType.text = ""
        }
        
        imgHead.image = UIImage(named: "noimage.jpg")
        getImage(url: member.headshot) { data in
            if let data = data {
                self.imgHead.image = UIImage(data: data)
            }
        }
        
     
    }
    
    @IBAction func btPass(_ sender: Any) {
        /* 建立標題為"Exit"，訊息為"Do you really want to exit?"，樣式為.alert(長得像Alert View)的Alert Controller */
        let alertController = UIAlertController(title: "警告", message: "是否要刪除此留言？", preferredStyle: .alert)
        
        /* 建立標題為"Ok"，樣式為.default(預設樣式)的按鈕 */
        let ok = UIAlertAction(title: "確定", style: .default) {
            /* alertAction代表被點擊的按鈕 */
            (alertAction) in
            /* 取得被點擊按鈕的標題文字後顯示在lbMessage上 */
           // self.label.text = "\(alertAction.title!) clicked"
        }
        /* 建立標題為"Cancel"，樣式為.cancel(取消樣式)的按鈕 */
        let cancel = UIAlertAction(title: "取消", style: .cancel) {_ in
          //  (alertAction) in self.label.text = "\(alertAction.title!) clicked"
        }
        /* Alert Controller加上ok與cancel按鈕 */
        alertController.addAction(ok)
        alertController.addAction(cancel)

        /* 呼叫present()才會跳出Alert Controller */
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func btDelete(_ sender: Any) {
        
    }
    
    //從firestore下載圖片(失敗回傳內部圖片)
    func  getImage(url:String,completionHandler: @escaping (Data?)-> Void) {
        //從FireStore下載圖片
        let imageRef = Storage.storage().reference().child(url)
        // 設定最大可下載10M
        imageRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            if let data = data {
                completionHandler(data)
            } else {
                //沒取到圖片時失敗回傳
                completionHandler(UIImage(named: "noimage.jpg")!.jpegData(compressionQuality: 1.0))
                print(error != nil ? error!.localizedDescription : "Downloading error!")
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

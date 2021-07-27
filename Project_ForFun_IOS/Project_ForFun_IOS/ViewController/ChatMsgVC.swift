//
//  ChatMsgVC.swift
//  Project_ForFun_IOS
//
//  Created by 陳鋐洋 on 2021/7/26.
//

import UIKit

class ChatMsgVC: UIViewController {
    var report: Report?
    var name: String?
    var memberId: Int?
    var chatroomId: Int?

    @IBOutlet weak var tcmsgOrginal: UITextView!
    @IBOutlet weak var tvName: UILabel!
    @IBOutlet weak var tvType: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = name{
            tvName.text = name
        }

        //判斷檢舉類別
        if let report = report{
            switch report.reportClass {
            case 0:
                tvType.text = "冒充他人"
            case 1:
                tvType.text = "謾罵他人"
            case 2:
                tvType.text = "不當檢舉"
            case 3:
                tvType.text = "內容誇大"
            case 4:
                tvType.text = "態度惡劣"
            default:
                tvType.text = ""
            }
        }
        tvContent.text = report?.message
    }
    
    @IBAction func btPass(_ sender: Any) {
    }
    @IBAction func btDelete(_ sender: Any) {
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

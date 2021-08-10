//
//  PostListVC.swift
//  Project_ForFun_IOS
//
//  Created by 王威力 on 2021/8/7.
//

import UIKit

class PostListDetailVC: UIViewController {
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postContext: UITextView!
    @IBOutlet weak var reportContext: UITextView!
    
    var post : Post?
    var report : Report?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //標題
        postTitle.text = post?.postTitle
        
        // 處理圖片
        postImg.image = UIImage(named: "noimage.jpg")
        getImage(url: (post?.postImg)!) { data in
            if let data = data {
                self.postImg.image = UIImage(data: data)
            }
        }
        
        //檢舉內文
        reportContext.text = report?.message
        
        //內文
        postContext.text = post?.postContext
       

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btNoPass(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btPassDelete(_ sender: Any) {
        
        showAlert(message: "是否確定刪除？", viewController: self) {
            let url = URL(string: common_url + "DiscussionBoardController")
            
            let requestParam: [String : Any] = ["action" : "postDelete",
                                "postId" : self.post!.postId]
            
            executeTask(url!, requestParam) { data, resp, error in
                if let data = data {
                    do {
                        // 解析資料
                        let resp = try JSONDecoder().decode(Int.self, from: data)
                        if resp != 0 {
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } catch {
                        print(error)
                    }
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

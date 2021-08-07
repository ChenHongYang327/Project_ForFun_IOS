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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btNoPass(_ sender: Any) {
    }
    @IBAction func btPassDelete(_ sender: Any) {
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

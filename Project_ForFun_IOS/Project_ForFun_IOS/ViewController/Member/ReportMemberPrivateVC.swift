//
//  ReportMemberPrivateVC.swift
//  Project_ForFun_IOS
//
//  Created by WEI on 2021/8/8.
//

import UIKit

class ReportMemberPrivateVC: UIViewController {
    var member:Member!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var ivIdF: UIImageView!
    @IBOutlet weak var ivIdB: UIImageView!
    @IBOutlet weak var ivGoodPeople: UIImageView!
    @IBOutlet var lcIdF: UILongPressGestureRecognizer!
    @IBOutlet var lcIdB: UILongPressGestureRecognizer!
    @IBOutlet var lcIdG: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="\(member.nameL)\(member.nameF)詳細資訊"
        setData()
       
    }
    
    func setData() {
        lbAddress.text="地址:\n\(member.address)"
        lbId.text="身分證字號:\(member.id)"
        getImage(url: member.idImgf) { data in
            self.ivIdF.image=UIImage(data: data!)
        }
        getImage(url: member.idImgb) { data in
            self.ivIdB.image=UIImage(data: data!)
        }
        if member.citizen != nil{
        getImage(url: member.citizen!) { data in
            self.ivGoodPeople.image=UIImage(data: data!)
        }
        }
        else{
            self.ivGoodPeople.image=UIImage(named: "noimage.jpg")
        }
    }
   
    @IBAction func clickIdF(_ sender: UILongPressGestureRecognizer) {
//        ivIdF.tag=1
//        controlView(sender: sender, imageView: ivIdF)
    }
    @IBAction func clickIdB(_ sender: UILongPressGestureRecognizer) {
//        ivIdB.tag=1
//        controlView(sender: sender, imageView: ivIdB)
    }
    @IBAction func clickGoodPeople(_ sender: UILongPressGestureRecognizer) {
//        ivGoodPeople.tag=1
//        controlView(sender: sender, imageView: ivGoodPeople)
        
    }
    func controlView(sender: UILongPressGestureRecognizer,imageView: UIImageView){
        //座標偏移量
        let y = (UIScreen.main.bounds.height*0.5 - imageView.bounds.height) * 0.5
        //元件的比例
        let scale = UIScreen.main.bounds.width / imageView.bounds.width
        switch sender.state {
        case .began:
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            print(":\(y)")
            imageView.frame.origin.y += y
            for subView in view.subviews{
                if(subView.tag != 1){
                    subView.alpha=0.4
                }
            }

        case .ended:
            imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            imageView.frame.origin.y -= y
            for subView in view.subviews{
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

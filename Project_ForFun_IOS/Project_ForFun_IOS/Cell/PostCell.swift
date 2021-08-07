//
//  PostCell.swift
//  Project_ForFun_IOS
//
//  Created by 王威力 on 2021/8/6.
//


//tableViewCell預設的imageView點擊後會改變尺寸，所以建立UITableViewCell子類別PostCell
import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postReport: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
}

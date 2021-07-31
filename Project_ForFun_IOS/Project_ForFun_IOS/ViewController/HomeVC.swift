//
//  HomeVC.swift
//  Project_ForFun_IOS
//
//  Created by WEI on 2021/7/25.
//

import UIKit
import FirebaseAuth

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet var collectionView: UICollectionView!
    
    var fullScreenSize :CGSize!
    var homeMenus: [Menu]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenSize = UIScreen.main.bounds.size
        // 設定UICollectionView背景色
        collectionView.backgroundColor = UIColor.white
        // 取得UICollectionView排版物件
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // 設定內容與邊界的間距
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 25, right: 5);
        // 設定每一列的間距
        layout.minimumLineSpacing = 10
        // 設定每個項目的尺寸
        layout.itemSize = CGSize(
            width: CGFloat(fullScreenSize.width)/3 - 10.0,
            height: CGFloat(fullScreenSize.width)/3 - 10.0)
        homeMenus=loadMenu()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeMenus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let menu = homeMenus[indexPath.row]
        let cellId = "menuCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.contentView.backgroundColor = UIColor.gray
        cell.imageView.image = menu.image
        cell.label.text = menu.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menu = homeMenus[indexPath.row]
        //點擊跳轉
        //
        if(menu.name=="會員列表"){
        let storyboard = UIStoryboard(name: "MemberStoryboard", bundle: nil)
        //沒搜尋
//      let memberListVC = storyboard.instantiateViewController(withIdentifier: "memberListVC") as! MemberListVC
//      self.navigationController?.pushViewController(memberListVC, animated: true)
        //有搜尋
        let memberSearchListVC = storyboard.instantiateViewController(withIdentifier: "memberSearchListVC") as! MemberSearchListVC
        self.navigationController?.pushViewController(memberSearchListVC, animated: true)
        }
        //
        else if(menu.name=="登出"){
            let controller = UIAlertController(title: nil, message: "是否確定要登出?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                logOut()
                let signIn = self.storyboard?.instantiateViewController(identifier: "signIn")
                self.view.window?.rootViewController = signIn
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(okAction)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)

           
        } else if (menu.name == "刊登表審核") {
            let publishStoryboard = UIStoryboard(name: "PublishStoryboard", bundle: nil)
            let publishListTVC = publishStoryboard.instantiateViewController(identifier: "publishListTVC") as! PublishListTVC
            self.navigationController?.pushViewController(publishListTVC, animated: true)
        }
        else if(menu.name=="房東證審核"){
        let storyboard = UIStoryboard(name: "HouseOwnerStoryboard", bundle: nil)
        let houseOwnerListVC = storyboard.instantiateViewController(withIdentifier: "houseOwnerListVC") as! HouseOwnerListVC
        self.navigationController?.pushViewController(houseOwnerListVC, animated: true)
        }
    }
    
    func loadMenu()->[Menu]{
        var menus=[Menu]()
        menus.append(Menu(name: "刊登表審核", image: UIImage(named: "publishcheck")!))
        menus.append(Menu(name: "客服回應", image: UIImage(named: "customerresp")!))
        menus.append(Menu(name: "會員列表", image: UIImage(named: "memberstatus")!))
        menus.append(Menu(name: "留言審核", image: UIImage(named: "commoncheck")!))
        menus.append(Menu(name: "文章審核", image: UIImage(named: "postcheck")!))
        menus.append(Menu(name: "房東證審核", image: UIImage(named: "landlordcheck")!))
        menus.append(Menu(name: "其他", image: UIImage(named: "else")!))
        menus.append(Menu(name: "登出", image: UIImage(named: "logout")!))
        return menus
    }
    
}

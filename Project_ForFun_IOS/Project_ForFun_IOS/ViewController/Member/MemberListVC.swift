//
//  MemberListVC.swift
//  Project_ForFun_IOS
//
//  Created by WEI on 2021/7/25.
//

import UIKit
import FirebaseStorage

class MemberListVC: UITableViewController {
    var members=[Member]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="會員列表"
    }
    //返回刷新
    override func viewWillAppear(_ animated: Bool) {
       getAllMember()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return members.count
    }

    //設定資料
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let member=members[indexPath.row]
        //客製化需強制轉型
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! MemberCell
        cell.nameMemberCell.text=member.nameL+member.nameF
        cell.phoneMemberCell.text="0\(member.phone)"
        cell.ivMemberCell.image = UIImage(named: "noimage")
        getImage(url: member.headshot) { data in
            cell.ivMemberCell.image = UIImage(data: data!)
        }
        return cell
    }
 
    //資料被選取時呼叫
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //指定storyboard(當前的可不寫)
    let storyboard = UIStoryboard(name: "MemberStoryboard", bundle: nil)
    //取得頁面
    let memberDetailVC = storyboard.instantiateViewController(withIdentifier: "memberDetailVC") as! MemberDatailVC
        let member=members[indexPath.row]
        //將值指定給下頁
        memberDetailVC.member=member
        //將前一頁的data(頭貼)帶到下一頁減少抓圖次數
        let cell=tableView.cellForRow(at: indexPath) as! MemberCell
        memberDetailVC.data=cell.ivMemberCell.image?.jpegData(compressionQuality: CGFloat(1.0))
        //跳轉
        self.navigationController?.pushViewController(memberDetailVC, animated: true)
    }
    
    //取得所有用戶資料
    func  getAllMember() {
        let url = URL(string: common_url + "adminMemberController")
        var requestParam = [String:Any]()
        requestParam["action"] = "getAllMember"
        // JSON含有日期時間，解析必須指定日期時間格式
        let decoder = JSONDecoder()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(format)
        executeTask(url!, requestParam) { data, resp, error in
            if(error != nil){
                print(error!)
                return
            }
            //檢查伺服器連線狀態
            if let httpResponse = resp as? HTTPURLResponse {
                print("與伺服器連線狀態碼:\(httpResponse.statusCode)")
                if(httpResponse.statusCode != 200){
                    DispatchQueue.main.async {
                    showSimpleAlert(message: "請嘗試將伺服器重新啟動", viewController: self)
                    }
                }
               }
            if let data = data{
                //顯示傳進來的資料
//                print(String(data: data, encoding: .utf8)!)
                do {
                    let result = try decoder.decode([Member].self, from: data)
                        self.members = result
                    DispatchQueue.main.async {
                        /* 抓到資料後重刷table view */
                        self.tableView.reloadData()
                    }
                }
                catch {
                    print(error)
                }
            
            
        }
    }
}
    
}

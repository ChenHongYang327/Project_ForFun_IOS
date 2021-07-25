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
        getAllMember()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return members.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let member=members[indexPath.row]
        //客製化需強制轉型
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! MemberCell
//        cell.ivMemberCell.image
        cell.nameMemberCell.text=member.nameL+member.nameF
        cell.phoneMemberCell.text="0\(member.phone)"
        cell.ivMemberCell.image = UIImage(named: "noimage")
        //從FireStore下載圖片
        let imageRef = Storage.storage().reference().child(member.headshot)
        // 設定最大可下載10M
        imageRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            if let imageData = data {
                cell.ivMemberCell.image = UIImage(data: imageData)
            } else {
                cell.ivMemberCell.image = UIImage(named: "noimage")
                print(error != nil ? error!.localizedDescription : "Downloading error!")
            }
        }
        // Configure the cell...

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
            if let data = data{
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

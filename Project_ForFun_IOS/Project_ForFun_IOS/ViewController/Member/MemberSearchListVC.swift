//
//  MemberSearchListVC.swift
//  Project_ForFun_IOS
//
//  Created by WEI on 2021/7/29.
//

import UIKit
import FirebaseStorage

class MemberSearchListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var members=[Member]()
    var searchMembers=[Member]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="會員列表"
        //有拉線不需寫
//        tableView.dataSource = self
//        tableView.delegate = self
//        searchBar.delegate = self
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if searchText.isEmpty {
            getAllMember()
        } else {
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            searchMembers = members.filter({ member in
                "\(member.nameL)\(member.nameF)".uppercased().contains(searchText.uppercased())
            })
        }
        tableView.reloadData()
    }
    
    
    //返回刷新
    override func viewWillAppear(_ animated: Bool) {
       getAllMember()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return searchMembers.count
    }

    //設定資料
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let member=searchMembers[indexPath.row]
        //客製化需強制轉型
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! MemberCell
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
        return cell
    }
 
    //資料被選取時呼叫
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    searchBar.text="" //清空搜尋欄的字
    //指定storyboard(當前的可不寫)
    let storyboard = UIStoryboard(name: "MemberStoryboard", bundle: nil)
    //取得頁面
    let memberDetailVC = storyboard.instantiateViewController(withIdentifier: "memberDetailVC") as! MemberDatailVC
        let member=searchMembers[indexPath.row]
        //將值指定給下頁
        memberDetailVC.member=member
        //將前一頁的data(頭貼)帶到下一頁減少抓圖次數
        let cell=tableView.cellForRow(at: indexPath) as! MemberCell
        memberDetailVC.data=cell.ivMemberCell.image?.jpegData(compressionQuality: CGFloat(100))
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
            //檢查連線狀態
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
                    //保留原始資料用
                    self.members = result
                    //搜尋結果用
                    self.searchMembers=result
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

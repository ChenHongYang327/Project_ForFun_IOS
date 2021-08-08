//
//  ReportMemberListVC.swift
//  Project_ForFun_IOS
//
//  Created by WEI on 2021/8/7.
//

import UIKit
class ReportMemberListVC: UITableViewController {
    var reports=[Report]()
    var reporteds=[Member]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="會員檢舉"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func viewWillAppear(_ animated: Bool) {
        getReportList()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reports.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //客製化需強制轉型
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportMemberCell", for: indexPath) as! ReportMembeerCell
        let report=reports[indexPath.row]
        let member=reporteds[indexPath.row]
        getImage(url: member.headshot) { data in
            cell.ivWhistleblower.image=UIImage(data: data!)
        }
        cell.lbWhistleblowerName.text="\(member.nameL)\(member.nameF)"
        let attributedString = NSMutableAttributedString(string: "\(report.message==nil ? "檢舉原因:無":"檢舉原因:\(report.message!)")")
        //從第1個字開始，5個字都改變字體大小與字型
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica-Bold", size: 22.0)!, range: NSMakeRange(0, 5))
        cell.lbReportNote.attributedText=attributedString
        return cell
    }
  

    func getReportList() {
        let url = URL(string: common_url + "reportMemberController")
        // JSON含有日期時間，解析必須指定日期時間格式
        let decoder = JSONDecoder()
        let format = DateFormatter()
        //後端沒設定GSON日期的格式
        format.dateFormat = "MMM dd, yyyy hh:mm:ss a"
        decoder.dateDecodingStrategy = .formatted(format)
        var requestParam=[String : Any]()
        requestParam["action"]="getReportMember"
        executeTask(url!, requestParam) { data, resp, error in
            if(error != nil){
                print(error!)
                return
            }
            //檢查伺服器連線狀態
            if let httpResponse = resp as? HTTPURLResponse {
                if(httpResponse.statusCode != 200){
                    print("與伺服器連線狀態碼:\(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                    showSimpleAlert(message: "請嘗試將伺服器重新啟動", viewController: self)
                    }
                }
               }
            if let data = data{
                do {
//                    print(String(data: data!, encoding: .utf8))
                    let result = try JSONDecoder().decode([String:String].self, from: data)
                    self.reports = try decoder.decode([Report].self, from: (result["reports"]!.data(using: .utf8)!))
                    self.reporteds = try decoder.decode([Member].self, from: (result["reporteds"]!.data(using: .utf8)!))
//                    print(self.reports.count)
//                    print(self.reporteds.count)
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

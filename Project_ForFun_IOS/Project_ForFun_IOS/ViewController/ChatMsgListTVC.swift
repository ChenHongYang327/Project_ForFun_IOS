

import UIKit
import FirebaseStorage

class ChatMsgListTVC: UITableViewController {
    
    var reportChatMsgs = [ReportChatMsg]()
    var reportChatMsg: ReportChatMsg?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showReportChatMsgs()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // like android recycleviw item count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reportChatMsgs.count
    }

    // like android recycleview onbindviewholder
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMsgCell", for: indexPath) as! ChatMsgCell
        let reportList = reportChatMsgs[indexPath.row]
        let member = reportList.member
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        print(dateFormatter.string(from: self.cityList[0].createTime))
//        print(self.areaList[0].createTime)
        
        
        
        cell.tvDate.text = dateFormatter.string(from: reportList.createTime!)
        cell.tvName.text = member.nameL+member.nameF
        cell.tvContent.text = reportList.message
        
        switch reportList.reportClass {
        case 0:
            cell.tvType.text = "冒充他人"
        case 1:
            cell.tvType.text = "謾罵他人"
        case 2:
            cell.tvType.text = "不當留言"
        case 3:
            cell.tvType.text = "內容誇大"
        case 4:
            cell.tvType.text = "態度惡劣"
        default:
            cell.tvType.text = ""
        }
        
        cell.imgHead.image = UIImage(named: "noimage.jpg")
        getImage(url: member.headshot) { data in
            if let data = data {
                cell.imgHead.image = UIImage(data: data)
            }
        }
        
        return cell
    }
    
    //傳值到下一頁
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 點擊跳頁
        let chatMsgDetail = storyboard?.instantiateViewController(identifier: "ChatMsgVC") as! ChatMsgVC
        chatMsgDetail.reportChatMsg = reportChatMsgs[indexPath.row]
        self.navigationController?.pushViewController(chatMsgDetail, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
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

    //連線拿資料
    func showReportChatMsgs(){
        let url_server = URL(string: common_url + "ReportChatMsg")
        var request = [String:Any]()
        request["RESULTCODE"] = 1
        // 設定轉換的日期格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"
        
        //設定為英文
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        executeTask(url_server!, request) { data, responds, error in
            if error == nil{
                if data != nil{
                    // 將輸入資料列印出來除錯用 json格式要解碼
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    do {
                        let result = try decoder.decode([String:String].self, from: data!)
                            
                        self.reportChatMsgs = try decoder.decode([ReportChatMsg].self, from: (result["REPORTCHATMSG"]?.data(using: .utf8))!)
                            
                            DispatchQueue.main.async {
                                /* 抓到資料後重刷table view */
                                self.tableView.reloadData()
                            }
                        
                    } catch  {
                        print(error)
                    }
                  
                }
            }else{
                print(error!.localizedDescription)
            }
        }
}

    //從firestore下載圖片(失敗回傳內部圖片)
    func  getImage(url:String,completionHandler: @escaping (Data?)-> Void) {
        //從FireStore下載圖片
        let imageRef = Storage.storage().reference().child(url)
        // 設定最大可下載10M
        imageRef.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            if let data = data {
                completionHandler(data)
            } else {
                //沒取到圖片時失敗回傳
                completionHandler(UIImage(named: "noimage.jpg")!.jpegData(compressionQuality: 1.0))
                print(error != nil ? error!.localizedDescription : "Downloading error!")
            }
        }
    }
    
    
}

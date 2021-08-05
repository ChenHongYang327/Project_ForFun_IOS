//
//  ChatMsgListTVC.swift
//  Project_ForFun_IOS
//
//  Created by 陳鋐洋 on 2021/7/27.
//

import UIKit

class ChatMsgListTVC: UITableViewController {
    let url_server = URL(string: common_url + "")
    var fakeArr: [String] = ["123","456","789"]
    var reportChatMsgs: [Report]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reportChatMsgs = getReportChatMsgs()
    }

 
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // like android recycleviw item count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fakeArr.count
    }

    // like android recycleview onbindviewholder
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMsgCell", for: indexPath) as! ChatMsgCell
        
        cell.tvType.text = fakeArr[indexPath.row]
        return cell
        
        
    }
    
    //傳值到下一頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if let indexPath = tableView.indexPathForSelectedRow {
            //
            
            let vc = segue.destination as? ChatMsgVC
            
        //}
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

}
extension ChatMsgListTVC {
    
    //連線拿資料
    func getReportChatMsgs()->[Report] {
        
        
    }
    
    
    
}

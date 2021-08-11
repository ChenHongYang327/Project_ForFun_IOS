//
//  CustomerServiceVC.swift
//  Project_ForFun_IOS
//
//  Created by 姜宗暐 on 2021/8/7.
//

import UIKit

class CustomerServiceVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var customerServiceList = [CustomerServise]()
    var searchList = [CustomerServise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCustomerServiceData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func getCustomerServiceData() {
        let url = URL(string: common_url + "CUSTOMER_SERVICE_Servlet")
        
        let requestParam = ["action" : "getAll"]
        
        executeTask(url!, requestParam) { data, resp, error in
            if let data = data {
                do {
                    // 解析資料
                    let respDic = try JSONDecoder().decode([String : String].self, from: data)
                    
                    // 設定轉換的日期格式
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    self.customerServiceList = try decoder.decode([CustomerServise].self, from: (respDic["customerList"]?.data(using: .utf8))!)
                    
                    self.searchList = self.customerServiceList
                    
                    // 取得資料後刷新畫面
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
//                    for publish in self.customerServiceList {
//                        print("\(publish.mag)")
//                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

extension CustomerServiceVC : UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    
    // tableView 資料筆數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    // tableView 資料綁定到畫面上
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CustomerServiceCell.self)", for: indexPath) as! CustomerServiceCell
        
        // 轉換日期格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        cell.nickname.text = "\(searchList[indexPath.row].nickName!) 聯絡客服"
        cell.message.text = searchList[indexPath.row].mag
        cell.createTime.text = dateFormatter.string(from: searchList[indexPath.row].createTime!)
        
        return cell
    }
    
    // 資料被選取的時候呼叫
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = self.storyboard?.instantiateViewController(identifier: "\(CustomerServiceDetailVC.self)") as! CustomerServiceDetailVC
        // 傳送資料到下一頁
        detailView.customerServise = customerServiceList[indexPath.row]
        
        // 跳頁
        self.navigationController?.pushViewController(detailView, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension CustomerServiceVC : UISearchBarDelegate {
    // MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text ?? ""
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if (text.isEmpty) {
            searchList = customerServiceList
        } else {
            searchList = customerServiceList.filter({ (customerService) -> Bool in
                return customerService.nickName!.uppercased().contains(text.uppercased())
            })
        }
        
        tableView.reloadData()
    }
    
    // 點擊鍵盤上的Search按鈕時將鍵盤隱藏
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

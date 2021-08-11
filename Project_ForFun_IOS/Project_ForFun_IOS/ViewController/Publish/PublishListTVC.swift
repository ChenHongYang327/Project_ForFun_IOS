//
//  publishListTVC.swift
//  Project_ForFun_IOS
//
//  Created by 姜宗暐 on 2021/7/25.
//

import UIKit
import FirebaseStorage

class PublishListTVC: UITableViewController {

    var cityList = [City]()
    var areaList = [Area]()
    var publishList = [Publish]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 取得縣市資料
        // 剛開始執行時會沒有資料
        cityList = CityAreaUtil.instance.cityList
        areaList = CityAreaUtil.instance.areaList
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        // 取得刊登資料
        getPublishData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return publishList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(PublishCell.self)", for: indexPath) as! PublishCell

        // 取得縣市名稱
        var cityName = ""
        for city in cityList {
            if (city.cityId == publishList[indexPath.row].cityId) {
                cityName = city.cityName!
                break
            }
        }
        
        // 取得行政區名稱
        var areaName = ""
        for area in areaList {
            if (area.areaId == publishList[indexPath.row].areaId) {
                areaName = area.areaName!
                break
            }
        }
//        print("\(cityName)\(areaName)")
        cell.publishName.text = publishList[indexPath.row].title
        cell.publishArea.text = "\(cityName)\(areaName)"
        cell.publishSquare.text = "\(publishList[indexPath.row].square!)坪"
        cell.publishRent.text = "\(publishList[indexPath.row].rent!)/月"

        // 處理圖片
        cell.publishImage.image = UIImage(named: "noimage.jpg")
        getImage(url: publishList[indexPath.row].titleImg!) { data in
            if let data = data {
                cell.publishImage.image = UIImage(data: data)
            }
        }
//        downloadImage(path: publishList[indexPath.row].titleImg!) { data, error in
//            if let data = data {
//                cell.publishImage.image = UIImage(data: data)
//            } else {
//                cell.publishImage.image = UIImage(named: "noimage")
//                print(error != nil ? error!.localizedDescription : "下載失敗")
//            }
//        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 點擊跳頁
        let publishDetail = storyboard?.instantiateViewController(identifier: "PublishDetailVC") as! PublishDetailVC
        publishDetail.publish = publishList[indexPath.row]
        self.navigationController?.pushViewController(publishDetail, animated: true)
        
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

    func getPublishData() {
        let url = URL(string: common_url + "getPublishData")
        
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
                    
                    self.publishList = try decoder.decode([Publish].self, from: (respDic["publishList"]?.data(using: .utf8))!)
                    
                    // 取得資料後刷新畫面
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
//                    for publish in self.publishList {
//                        print("\(publish.title)")
//                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func downloadImage (path: String, completion: @escaping (Data?, Error?) -> Void) {
        let imageRef = Storage.storage().reference().child(path)
        imageRef.getData(maxSize: 10 * 1024 * 1024, completion: completion)
    }
}

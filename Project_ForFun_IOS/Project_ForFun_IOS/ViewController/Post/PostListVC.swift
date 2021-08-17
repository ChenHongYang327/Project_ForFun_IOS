//
//  PostListVC.swift
//  Project_ForFun_IOS
//
//  Created by 王威力 on 2021/8/8.
//

import UIKit
import FirebaseStorage

class PostListVC: UITableViewController {
    
    var postList = [Post]()
    var reportList = [Report]()
    var searchposts=[Post]()
    @IBOutlet weak var searchBar: UISearchBar!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    
    func tableViewAddRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(getPostData), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //取得貼文資料
        getPostData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchposts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        // 取得貼文名稱
       
       
        let postImgPath = searchposts[indexPath.row].postImg
    
        let reportItem = reportList[indexPath.row].reportClass
        print("test:\(reportItem)")
        
        switch reportItem {
        case 0:
            cell.postReport.text = "冒充他人"
        case 1:
            cell.postReport.text = "謾罵他人"
        case 2:
            cell.postReport.text = "不當留言"
        case 3:
            cell.postReport.text = "內容誇大"
        default:
            cell.postReport.text = "態度惡劣"
        }
            
        
        cell.postTitle.text = searchposts[indexPath.row].postTitle
        cell.postBoardId.text = searchposts[indexPath.row].boardId
        
        // 處理圖片
        cell.postImage.image = UIImage(named: "noimage.jpg")
        getImage(url: postImgPath!) { data in
            if let data = data {
                cell.postImage.image = UIImage(data: data)
            }
        }
        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 點擊跳頁
        let postDetail = storyboard?.instantiateViewController(identifier: "PostDetail") as! PostListDetailVC
        postDetail.post = searchposts[indexPath.row]
        postDetail.report = reportList[indexPath.row]
        self.navigationController?.pushViewController(postDetail, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    
    @objc func getPostData() {
        let url = URL(string: common_url + "DiscussionBoardController")
        
        var requestParam = ["action" : "getAllReport"]
        executeTask(url!, requestParam) { data, resp, error in
            if let data = data {
            
                do {
                    // 設定轉換的日期格式
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm:ss a"
                    //設定為英文
                    dateFormatter.locale = Locale(identifier: "en_US")
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    // 解析資料
                    let respDic = try decoder.decode([String : String].self, from: data)
                    
                    self.reportList = try decoder.decode([Report].self, from: (respDic["reportList"]?.data(using: .utf8))!)
                    
                    self.postList = try decoder.decode([Post].self, from: (respDic["postList"]?.data(using: .utf8))!)
                    self.searchposts = self.postList
                    
                    
                    // 取得資料後刷新畫面
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
 
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

extension PostListVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if searchText.isEmpty {
            searchposts = postList
        } else {
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            searchposts = postList.filter({ post in
                post.postTitle!.uppercased().contains(searchText.uppercased())
            })
        }
        tableView.reloadData()
    }
    
    // 點擊鍵盤上的Search按鈕時將鍵盤隱藏
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

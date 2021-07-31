import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

// 實機
// let URL_SERVER = "http://192.168.0.101:8080/Spot_MySQL_Web/"
// 模擬器
let common_url = "http://127.0.0.1:8080/ForFun_DB/"

//送出請求
func executeTask(_ url_server: URL, _ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    // requestParam值為Any就必須使用JSONSerialization.data()，而非JSONEncoder.encode()
    let jsonData = try! JSONSerialization.data(withJSONObject: requestParam)
    var request = URLRequest(url: url_server)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpBody = jsonData
    let sessionData = URLSession.shared
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}
//對話框
func showSimpleAlert(message: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "確定", style: .default)
    alertController.addAction(cancel)
    /* 呼叫present()才會跳出Alert Controller */
    viewController.present(alertController, animated: true, completion:nil)
}
//清除Firebase電話認證
func logOut(){
    guard let _ = try? Auth.auth().signOut()
    else {
        print("登出錯誤")
        return
}
}
func showAlert(message: String, viewController: UIViewController,completionHandler:@escaping ()->Void) {
let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "確定", style: .default) { UIAlertAction in
        completionHandler()//按下確定要執行的動作
    }
let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
controller.addAction(okAction)
controller.addAction(cancelAction)
viewController.present(controller, animated: true, completion: nil)
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
            completionHandler(UIImage(named: "noimage")?.jpegData(compressionQuality: 100))
            print(error != nil ? error!.localizedDescription : "Downloading error!")
        }
    }
}

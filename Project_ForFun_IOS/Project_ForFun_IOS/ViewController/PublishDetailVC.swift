//
//  PublishDetailVC.swift
//  Project_ForFun_IOS
//
//  Created by 姜宗暐 on 2021/7/27.
//

import UIKit
import CoreLocation
import MapKit
import SDWebImage
import SnapKit

class PublishDetailVC: UIViewController {
    @IBOutlet weak var publishDetailTitle: UILabel!
    @IBOutlet weak var publishDetailRent: UILabel!
    @IBOutlet weak var publishDetailArea: UILabel!
    @IBOutlet weak var publishDetailSquare: UILabel!
    @IBOutlet weak var publishDetailGender: UILabel!
    @IBOutlet weak var publishDetailType: UILabel!
    @IBOutlet weak var publishDetailDeposit: UILabel!
    @IBOutlet weak var publishDetailInfo: UITextView!
    @IBOutlet var furnishedArray: [UILabel]!
    @IBOutlet weak var publishDetailMap: MKMapView!
    @IBOutlet weak var contentView: UIStackView!
    
    var locationManager: CLLocationManager!
    var userLocation: CLLocationCoordinate2D?
    
    var cityList = [City]()
    var areaList = [Area]()
    var publish: Publish?
    
    var publishImg = [UIImage]()
    
    private lazy var bannerView: ZCycleView = {
//        let width = view.bounds.width - 20
        let cycleView1 = ZCycleView()
        cycleView1.placeholderImage = UIImage(named: "noimage.jpg")
        cycleView1.scrollDirection = .horizontal
        cycleView1.delegate = self
        cycleView1.reloadItemsCount(publishImg.count)
//        cycleView1.itemZoomScale = 1.2
        cycleView1.itemSpacing = 10
        cycleView1.initialIndex = 1
        cycleView1.isAutomatic = true
//        cycleView1.isInfinite = false
        cycleView1.itemSize = CGSize(width: view.bounds.width, height: 200)
        return cycleView1
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 取得縣市資料
        cityList = CityAreaUtil.instance.cityList
        areaList = CityAreaUtil.instance.areaList
        
        self.title = "刊登詳細"
        
        // 定位資訊設定
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization() // 要求定位權限
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1 // 移動1公尺以上才重新抓位置
        locationManager.startUpdatingLocation()
        
        if let publish = publish {
            setPublishData(publish: publish)
            setupMap(publish: publish)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func makeBanner() {
        if (publishImg.count == 3) {
            contentView.addSubview(bannerView)
            bannerView.snp.makeConstraints {
                $0.left.equalTo(0)
                $0.top.equalTo(0)
//                $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
                $0.right.equalTo(0)
                $0.height.equalTo(200)
            }
        }
    }
    
    func setPublishData(publish: Publish) {
        // 抓取刊登圖片做成輪播圖
        getImage(url: publish.publishImg1!) { data in
            if let data = data {
                self.publishImg.append(UIImage(data: data)!)
                self.makeBanner()
            }
        }
        
        getImage(url: publish.publishImg2!) { data in
            if let data = data {
                self.publishImg.append(UIImage(data: data)!)
                self.makeBanner()
            }
        }
        
        getImage(url: publish.publishImg3!) { data in
            if let data = data {
                self.publishImg.append(UIImage(data: data)!)
                self.makeBanner()
            }
        }
        
        // 取得縣市名稱
        var cityName = ""
        for city in cityList {
            if (city.cityId == publish.cityId) {
                cityName = city.cityName!
                break
            }
        }
        
        // 取得行政區名稱
        var areaName = ""
        for area in areaList {
            if (area.areaId == publish.areaId) {
                areaName = area.areaName!
                break
            }
        }
        
        // 性別限制
        var gender = ""
        switch Gender(rawValue: publish.gender!) {
        case .BOTH:
            gender = "無限制"
        case .MALE:
            gender = "限男性"
        case .FEMALE:
            gender = "限女性"
        default:
            gender = "資料錯誤"
        }
        
        // 房型
        var type = ""
        switch HouseType(rawValue: publish.type!) {
        case .WITH_BATH:
            type = "套房"
        case .NO_BATH:
            type = "雅房"
        default:
            type = "資料錯誤"
        }
        
        publishDetailTitle.text = publish.title
        publishDetailRent.text = "\(publish.rent!)/月"
        publishDetailArea.text = "\(cityName)\(areaName)"
        publishDetailSquare.text = "\(publish.square!)坪"
        publishDetailGender.text = "\(gender)"
        publishDetailType.text = "\(type)"
        publishDetailDeposit.text = "\(publish.deposit!)個月"
        publishDetailInfo.text = publish.publishInfo
        
        // 可用來設定內容與編框的間距
//        publishDetailInfo.textContainerInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
//        publishDetailInfo.textContainerInset = .zero
        
        let furnished = publish.furnished!.split(separator: "|")
        
        for i in 0 ..< furnished.count {
            furnishedArray[i].isEnabled = "1" == furnished[i]
        }
    }
    
    func setupMap(publish: Publish) {
        publishDetailMap.delegate = self
        
        // 設定地圖顯示範圍
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        var region = MKCoordinateRegion()
        region.span = span
        
        publishDetailMap.setRegion(region, animated: true)
        publishDetailMap.regionThatFits(region)
        publishDetailMap.mapType = .standard

        // 設定房屋位置
        let houseLocation = CLLocationCoordinate2D(latitude: publish.latitude, longitude: publish.longitude)
        publishDetailMap.setCenter(houseLocation, animated: true)
        
        // 上標記
        let marker = MKPointAnnotation()
        marker.coordinate = houseLocation
        publishDetailMap.addAnnotation(marker)
    }
    
    func goNavigation(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        // 建立MKPlacemark
        let markStart = MKPlacemark(coordinate: start)
        let markEnd = MKPlacemark(coordinate: end)
        
        // 建立MKMapItem
        let mapItemStart = MKMapItem(placemark: markStart)
        let mapItemEnd = MKMapItem(placemark: markEnd)
        mapItemStart.name = "起點"
        mapItemEnd.name = "目的地"
        
        // 設定導航模式(開車)
        let option = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        MKMapItem.openMaps(with: [mapItemStart, mapItemEnd], launchOptions: option)
    }
    
    @IBAction func clickDelete(_ sender: Any) {
        showAlert(message: "是否確定刪除？", viewController: self) {
            let url = URL(string: common_url + "publishListController")
            
            let requestParam: [String : Any] = ["action" : "pubishDelete",
                                "publishId" : self.publish!.publishId]
            
            executeTask(url!, requestParam) { data, resp, error in
                if let data = data {
                    do {
                        // 解析資料
                        let resp = try JSONDecoder().decode([String : Bool].self, from: data)
                        if let result = resp["result"], result {
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    @IBAction func clickMap(_ gesture: UITapGestureRecognizer) {
        if (gesture.state == .ended) {
            // 點擊地圖進行導航
            if let userLocation = userLocation {
                let houseLocation = CLLocationCoordinate2D(latitude: publish!.latitude, longitude: publish!.longitude)
                goNavigation(start: userLocation, end: houseLocation)
            }
            
        }
    }
}

// 圖片輪播
extension PublishDetailVC: ZCycleViewProtocol {
    func cycleViewRegisterCellClasses() -> [String: AnyClass] {
        return ["CustomCollectionViewCell": CustomCollectionViewCell.self]
    }

    func cycleViewConfigureCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, realIndex: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.imageView.image = publishImg[realIndex]
        return cell
    }
    
    func cycleViewDidScrollToIndex(_ cycleView: ZCycleView, index: Int) {
        
    }
    
    func cycleViewConfigurePageControl(_ cycleView: ZCycleView, pageControl: ZPageControl) {
        pageControl.isHidden = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.frame = CGRect(x: 0, y: cycleView.bounds.height-25, width: cycleView.bounds.width, height: 25)
    }
}

// 使用者定位
extension PublishDetailVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // 記錄使用者位置
            userLocation = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// 自訂地圖標記
extension PublishDetailVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 取得重複使用的圖標
        let identifier = "marker"
        var marker = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if (marker == nil) {
            marker = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        // 圖標設定
        marker?.pinTintColor = .red
        marker?.animatesDrop = true
        marker?.canShowCallout = false
        
        return marker
    }
}

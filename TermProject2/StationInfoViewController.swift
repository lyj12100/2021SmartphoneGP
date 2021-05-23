//
//  StationInfoViewController.swift
//  TermProject2
//
//  Created by KpuGame on 2021/05/19.
//

import UIKit

class StationInfoViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, XMLParserDelegate{

    @IBOutlet weak var tbData: UITableView!
    
    
    
    var url : String?
    var parser = XMLParser()
    let postsname : [String] = ["편의시설", "대표음식", "테마휴게소","날씨정보","전화번호"]
    var posts : [String] = ["","","","",""]
    var element = NSString()
    
    var convenience = NSMutableString()
    var batchMenu = NSMutableString()
    var theme = NSMutableString()
    var weather = NSMutableString()
    var telNo = NSMutableString()
    
    var serviceAreaCode = NSMutableString()
    var serviceAreaCodeNum = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbData.delegate = self
        tbData.dataSource = self
        
        beginParsing()
        // Do any additional setup after loading the view.
    }
    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
    }
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "list"){
            posts = ["","","","","",""]
            
            convenience = NSMutableString()
            convenience = ""
            batchMenu = NSMutableString()
            batchMenu = ""
            telNo = NSMutableString()
            telNo = ""
            serviceAreaCode = NSMutableString()
            serviceAreaCode = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "convenience"){
            convenience.append(string)
        }else if element.isEqual(to: "batchMenu"){
            batchMenu.append(string)
        }else if element.isEqual(to: "telNo"){
            telNo.append(string)
        }else if element.isEqual(to: "serviceAreaCode"){
            serviceAreaCode.append(string)
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "list"){
            if !convenience.isEqual(nil){
                posts[0] = convenience as String
            }
            if !batchMenu.isEqual(nil){
                posts[1] = batchMenu as String
            }
            
            if !telNo.isEqual(nil){
                posts[4] = telNo as String
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let convenienceCell = tableView.dequeueReusableCell(withIdentifier: "ConvenienceCell", for: indexPath)
            
            convenienceCell.detailTextLabel?.text = posts[0]
            return convenienceCell
        }else if indexPath.row == 1 {
            let foodCell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
            //cell.textLabel?.text = postsname[indexPath.row]
            foodCell.detailTextLabel?.text = posts[1]
            return foodCell
        }
        else if indexPath.row == 4 {
            let telNoCell = tableView.dequeueReusableCell(withIdentifier: "TelNoCell", for: indexPath)
            //cell.textLabel?.text = postsname[indexPath.row]
            telNoCell.detailTextLabel?.text = posts[4]
            return telNoCell
        }
        else{
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
            emptyCell.detailTextLabel?.text = ""
            return emptyCell
        }
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "segueToMapView"{
                serviceAreaCodeNum = serviceAreaCode as String
                if let mapViewController = segue.destination as? MapViewController{
                    mapViewController.url = "http://data.ex.co.kr/openapi/locationinfo/locationinfoRest?key=test&type=xml&numOfRows=100&serviceAreaCode=" + serviceAreaCodeNum
                }
            }
        /*if segue.identifier == "segueToDetailView"{
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                stationName = (posts.object(at: (indexPath?.row)!)as AnyObject).value(forKey: "serviceAreaName")as! NSString as String
                //url에서 한글을 쓸 수 있도로 코딩
                stationName_utf8 = stationName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                //선택한 row의 병원명을 추가해 url을 구성하고 넘겨줌
                if let navController = segue.destination as? UINavigationController{
                    if let stationInfoViewController = navController.topViewController as? StationInfoViewController{
                        stationInfoViewController.url = url! + "&serviceAreaName="+stationName_utf8*/
        if segue.identifier == "segueToThemeView"{
            
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

}

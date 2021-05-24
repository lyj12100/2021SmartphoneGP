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
    var serviceAreaCode2 = NSMutableString()
    var serviceAreaCodeNum2 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbData.delegate = self
        tbData.dataSource = self
        
        beginParsing()
        // Do any additional setup after loading the view.
    }
    @IBAction func doneToStationInfoView(segue:UIStoryboardSegue){
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
            serviceAreaCode2 = NSMutableString()
            serviceAreaCode2 = ""
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
        }else if element.isEqual(to: "serviceAreaCode2"){
            serviceAreaCode2.append(string)
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
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let convenienceCell = tableView.dequeueReusableCell(withIdentifier: "ConvenienceCell", for: indexPath)
            convenienceCell.detailTextLabel?.text = posts[0]
            return convenienceCell
        }else if indexPath.row == 1 {
            let foodCell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
            foodCell.detailTextLabel?.text = posts[1]
            return foodCell
        }
        else if indexPath.row == 2{
            let themeCell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell",for: indexPath)
            themeCell.textLabel?.text = "테마휴게소"
            return themeCell
        }
        else if indexPath.row == 4 {
            let telNoCell = tableView.dequeueReusableCell(withIdentifier: "TelNoCell", for: indexPath)
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
     
        //먹거리url "http://data.ex.co.kr/openapi/restinfo/restBestfoodList?key=7237197557&type=xml&numOfRows=100" + "&stdRestCd=" + serviceAreaCodeNum2
        
            if segue.identifier == "segueToThemeView"{
                serviceAreaCodeNum2 = serviceAreaCode2 as String
                if let navController = segue.destination as? UINavigationController{
                    if let themeViewController = navController.topViewController as? ThemeViewController{
                        themeViewController.url = "http://data.ex.co.kr/openapi/restinfo/restThemeList?key=7237197557&type=xml&stdRestCd=" + serviceAreaCodeNum2
                    }
                }
            }
        
        }
    
    }


//
//  RestAreaListViewController.swift
//  TermProject2
//
//  Created by KpuGame on 2021/05/18.
//

import UIKit

class RestAreaListViewController: UITableViewController,  XMLParserDelegate  {

    var foodsAndFacilitiesUrl: String = "http://data.ex.co.kr/openapi/business/conveniServiceArea?key=test&type=xml&numOfRows=100"
    
    var url: String?
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var serviceAreaName = NSMutableString()
  
    
    var stationName = ""
    var stationName_utf8 = ""
    
    @IBOutlet var tbData: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
    }
    
    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
    }
    
    @IBAction func doneToListTableView(segue:UIStoryboardSegue){
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] ) {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "list")
        {
            elements = NSMutableDictionary()
            elements = [:]
            serviceAreaName = NSMutableString()
            serviceAreaName = ""
         
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "serviceAreaName"){
            serviceAreaName.append(string)
        }
        
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName as NSString).isEqual(to: "list"){
            if !serviceAreaName.isEqual(nil){
                elements.setObject(serviceAreaName, forKey: "serviceAreaName" as NSCopying)
            }
          
            posts.add(elements)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segueToDetailView"{
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                stationName = (posts.object(at: (indexPath?.row)!)as AnyObject).value(forKey: "serviceAreaName")as! NSString as String
                //url에서 한글을 쓸 수 있도로 코딩
                stationName_utf8 = stationName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                //선택한 row의 병원명을 추가해 url을 구성하고 넘겨줌
                if let navController = segue.destination as? UINavigationController{
                    if let stationInfoViewController = navController.topViewController as? StationInfoViewController{
                        stationInfoViewController.url = url! + "&serviceAreaName="+stationName_utf8
                    }
                    
                }
            }
        }
    }
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "segueToTableView"{
             if let navController = segue.destination as? UINavigationController{
                 if let restAreaListViewController = navController.topViewController as? RestAreaListViewController{
                     restAreaListViewController.url = locationInfoUrl + routeNum
                 }
             }
         }
     }*/
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return posts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row)as AnyObject).value(forKey: "serviceAreaName") as! NSString as String
        
        return cell
    }
}

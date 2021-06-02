//
//  FoodListViewController.swift
//  TermProject2
//
//  Created by KpuGame on 2021/05/23.
//

import UIKit

class FoodListViewController: UIViewController , UITextViewDelegate, XMLParserDelegate{
    
    

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var recommendTableView: UITableView!
    
    @IBOutlet weak var AllTableView: UITableView!
    
    var url: String?
    var parser = XMLParser()
    //var posts = NSMutableArray()
    var recommendPosts = NSMutableArray()
    var allPosts = NSMutableArray()
    var bestmenu : String = ""
    //var bestmenu = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var bestfoodyn = NSMutableString()
    var foodNm = NSMutableString()
    var recommendyn = NSMutableString()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        
        recommendTableView.delegate = self
        recommendTableView.dataSource = self
        recommendTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        AllTableView.delegate = self
        AllTableView.dataSource = self
        AllTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        textView.delegate = self
        bestmenuTextView()
        // Do any additional setup after loading the view.
    }
    
    
    func beginParsing(){
        //posts = []
        bestmenu = ""
        recommendPosts = []
        allPosts = []
       // bestmenu = []
        parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser.delegate = self
        parser.parse()
        recommendTableView!.reloadData()
        AllTableView!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] ) {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "list")
        {
            elements = NSMutableDictionary()
            elements = [:]
            bestfoodyn = NSMutableString()
            bestfoodyn = ""
            foodNm = NSMutableString()
            foodNm = ""
            recommendyn = NSMutableString()
            recommendyn = ""
         
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "bestfoodyn"){
            bestfoodyn.append(string)
        }else if element.isEqual(to: "foodNm"){
            foodNm.append(string)
        }else if element.isEqual(to: "recommendyn"){
            recommendyn.append(string)
        }
        
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName as NSString).isEqual(to: "list"){
            
            
           if bestfoodyn.isEqual("Y"){
                //elements.setObject(foodNm, forKey: "foodNm" as NSCopying)
                bestmenu = foodNm as String
            }
            if recommendyn.isEqual("Y"){
            //if !recommendyn.isEqual(nil){
                elements.setObject(foodNm, forKey: "foodNm" as NSCopying)
                recommendPosts.add(elements)
            }
            if recommendyn.isEqual("N") && !bestfoodyn.isEqual("Y"){
            //if !foodNm.isEqual(nil){
                elements.setObject(foodNm, forKey: "foodNm" as NSCopying)
                allPosts.add(elements)
            }
          
           
        }
    }
    
    func bestmenuTextView(){
        if(!bestmenu.isEqual(nil)){
            textView.text = bestmenu //as String
        }else{
            textView.text = " "
        }
    }
 
    
}
extension FoodListViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recommendTableView{
            return recommendPosts.count
        }
        if tableView == AllTableView{
            return allPosts.count
        }
        return 0
        //return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if tableView == recommendTableView{
            cell.textLabel?.text = (recommendPosts.object(at: indexPath.row)as AnyObject).value(forKey: "foodNm") as! NSString as String
        }
        if tableView == AllTableView{
            cell.textLabel?.text = (allPosts.object(at: indexPath.row)as AnyObject).value(forKey: "foodNm") as! NSString as String
        }
        return cell

    }
    
    
    
}


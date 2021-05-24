//
//  ThemeViewController.swift
//  TermProject2
//
//  Created by KpuGame on 2021/05/24.
//

import UIKit

class ThemeViewController: UIViewController, XMLParserDelegate,
                           UITextViewDelegate{
    

    @IBOutlet weak var themeText: UITextView!
    @IBOutlet weak var themeTitleText: UITextView!
    
    
    var url: String?
    var parser = XMLParser()
  
    var posts : [String] = ["",""]

    var element = NSString()
    
    var itemNm = NSMutableString()
    var detail = NSMutableString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //themeTable.delegate = self
        //themeTable.dataSource = self
        beginParsing()
        themeText.delegate = self
        
        
            themeText.text = posts[0]
            themeTitleText.text = posts[1]
        
        // Do any additional setup after loading the view.
    }
    
    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser.delegate = self
        parser.parse()
      
    }
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "list"){
            posts = ["",""]
            
            itemNm = NSMutableString()
            itemNm = ""
            detail = NSMutableString()
            detail = ""
            
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "detail"){
            detail.append(string)
        }else if element.isEqual(to: "itemNm"){
            itemNm.append(string)
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "list"){
            if !detail.isEqual(nil){
                posts[0] = detail as String
            }
            if !itemNm.isEqual(nil){
                posts[1] = itemNm as String
            }
            if detail.isEqual(nil){
                posts[0] = ""
            }
            if itemNm.isEqual(nil){
                posts[1] = ""
            }
           
        }
    }
    
   /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let itemNm = tableView.dequeueReusableCell(withIdentifier: "itemN", for: indexPath)
            convenienceCell.detailTextLabel?.text = posts[0]
            return convenienceCell
        }else if indexPath.row == 1 {
            let foodCell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
            foodCell.detailTextLabel?.text = posts[1]
            return foodCell
    }*/
    
    /*func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        themeText.text = itemNm as String
        return true
    }*/


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

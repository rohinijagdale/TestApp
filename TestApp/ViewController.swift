//
//  ViewController.swift
//  TestApp
//
//  Created by Rohini on 23/03/18.
//  Copyright © 2018 Rohini. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SVProgressHUD

class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    let objAJProgressView = AJProgressView()
    @IBOutlet var backgroungView: UIView!
    var activityIndicator = UIActivityIndicatorView()

    var arrCount:Int = 0
    var str:String = ""
    var myArr:NSArray = []
     var resultDataArr: [String:Any]!
    var myArray: [[String:AnyObject]] = [[ : ]]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pass your image here which will come in center of ProgressView
        objAJProgressView.imgLogo = UIImage(named:"pb_back")!
        
        // Pass the color for the layer of progressView
        objAJProgressView.firstColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        // If you  want to have layer of animated colors you can also add second and third color
        objAJProgressView.secondColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        objAJProgressView.thirdColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        // Set duration to control the speed of progressViewa
        objAJProgressView.duration = 2.0
        
        // Set width of layer of progressView
        objAJProgressView.lineWidth = 4.0
        
        //Set backgroundColor of progressView
        objAJProgressView.bgColor =  UIColor.black.withAlphaComponent(0.3)
        
        //Get the status of progressView, if view is animating it will return true.
        _ = objAJProgressView.isAnimating
        
        //Use show() and hide() to manage progressView
        objAJProgressView.show()
        
        // spinnerCreation()
        
           SVProgressHUD.setForegroundColor(.white)
           SVProgressHUD.setBackgroundColor(.clear)
           SVProgressHUD.setRingThickness(4)
           tableView.dataSource = self
           tableView.delegate = self
        
          //Call web servise
         getJsonResult()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Method get JSON Data
    func getJsonResult()
    {
        self.backgroungView.isHidden = false
        let urlString = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json" //json url
        var error:Error?
        var string: String? = nil
        if let aString = URL(string: urlString)
        {
            string = try? String(contentsOf: aString, encoding: .isoLatin1)
        }
        var resData: Data? = string?.data(using: .utf8)
        if let aData = resData
        {
            let parsedData = try? JSONSerialization.jsonObject(with: aData as Data, options: .allowFragments)
            //Store response in NSDictionary for easy access
            let dict = parsedData as? NSDictionary
            let currentConditions = "\(dict!["rows"]!)"
            var variableName = [Any]()
            variableName = [dict!["rows"]!]
            let arr = variableName[0] as! NSArray
            arrCount = arr.count
            for index in 0...arr.count-1
            {
                myArray.append(arr[index] as! [String : AnyObject])
            }
            myArray.remove(at: 0)
            print(myArray)
            print(myArray.count)
            let currentConditions1 = "\(dict!["title"]!)"
            str = currentConditions1
            self.navigationItem.title = str
            tableView.reloadData()
        }
        if error != nil
        {
            //Error handling
        }
        //After load data hide background view
        self.objAJProgressView.hide()
        self.backgroungView.isHidden = true
        
    }// end of getJSONResult() methoda
    
    
    //Table view controller methods for load ,manage and display json data

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200.0;//Choose your custom row height
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
      let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell",
                                                 for: indexPath) as! TableViewCell
      let data = myArray[indexPath.row]
      let disc = data["description"]
      print(disc)
      
        if let title = data["title"] as? String
        {
          cell.titleLbl.text = title
        }
        else
        {
            cell.titleLbl.text = "Title Not Available"
           // cell.titleLbl.textColor=#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
        if let disc = data["description"] as? String
        {
            cell.discTextview.text = disc
        }
       else
        {
            cell.discTextview.text = "Description Not Available*"
        }
        
        cell.imageHrefView.sd_setShowActivityIndicatorView(true)
        cell.imageHrefView.sd_setIndicatorStyle(.whiteLarge)
        
        DispatchQueue.global().async
        {
            DispatchQueue.main.async // UI handle
            {
                 if let imageURL = data["imageHref"]as? String
                 {
                    let url = URL(string: imageURL)
                    cell.imageHrefView.sd_setImage(with: url, placeholderImage: UIImage(named: "dummyImage"), options: SDWebImageOptions(rawValue: 0), completed:
                        {(image,error, cacheType, imagrURL) in})
                 }
                 else
                 {
                    let url = URL(string: "")
                    cell.imageHrefView.sd_setImage(with: url, placeholderImage: UIImage(named: "dummyImage"), options: SDWebImageOptions(rawValue: 0), completed: { (image,error, cacheType, imagrURL) in})
                }
            }
        }
        return cell
    } //end of json data display
    
}


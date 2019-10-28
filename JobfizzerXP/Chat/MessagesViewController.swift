//
//  MessagesViewController.swift
//  UberdooXP
//
//  Created by admin on 7/30/18.
//  Copyright © 2018 Uberdoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
//import KRProgressHUD
import SwiftSpinner


class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var msgList = Array<Any>()
    
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var emptyChatView: UIView!
    @IBOutlet weak var noMessageLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emptyChatView.isHidden = true
        noMessageLbl.text = "You have no messages".localized()
        noMessageLbl.font = FontBook.Medium.of(size: 18)
        titleLbl.text = "Chat List".localized()
        
        tableView.separatorStyle = .none

        titleLbl.font = FontBook.Medium.of(size: 20)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.getChatsList()
        
    }
    
    func getChatsList()
    {
        
        if let provider_id = UserDefaults.standard.string(forKey: "provider_id")
        {
            
            
            
            SwiftSpinner.show("Loading...".localized())

            
            let params: Parameters = [
                "providerid": provider_id
            ]
            
            print("Params = ",params)
            
            
            
            
            let url = "\(Constants.SocketMessage)/usermsglist"

            
            
            let Headers: HTTPHeaders = [
                "Content-Type":"application/x-www-form-urlencoded"
            ]
            
            
            print("url = ",url)

            
            
            Alamofire.request(url, method: .post, parameters: params, headers: Headers)
                .responseJSON
                {
                    
                    response in
                    
                    
                    SwiftSpinner.hide()

                    
                    //                    self.stopanimating()
                    
                    
                    //                    self.indicator.stopAnimating()
                    if(response.result.isSuccess)
                    {
                        if let json = response.result.value
                        {
                            print("CHAT SCREEN JSON: \(json)") // serialized json response
                            let jsonResponse = JSON(json)
                            
                            if(jsonResponse["error"].stringValue == "false" )
                            {
                                let JSON = response.result.value as! NSDictionary
                                self.msgList = JSON.object(forKey: "msglist")as! Array<Any>
                                
                                //                                self.searchBar.isHidden = false
                                if(self.msgList.count > 0)
                                {
                                    self.emptyChatView.isHidden = true
                                    self.tableView.reloadData()
                                }
                                else
                                {
                                    self.emptyChatView.isHidden = false
                                }
                            }
                            else
                            {
                                //                                self.searchBar.isHidden = true
                                self.showAlert(title: "Oops".localized(), msg: jsonResponse["message"].stringValue)
                            }
                        }
                    }
                    else
                    {
                        //                        self.searchBar.isHidden = true
                        print(response.error.debugDescription)
                        self.showAlert(title: "Oops".localized(), msg: response.error!.localizedDescription)
                        
                    }
            }
        }
        else
        {
            self.emptyChatView.isHidden = false
        }
    }
    
   /* func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return msgList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell", for: indexPath) as! MessagesTableViewCell
        
        var feedPosts = self.msgList[indexPath.row]as! NSDictionary
        
        
        let profilePic = feedPosts["profilePic"]as? String ?? ""
        
        let name = feedPosts["name"]as? String ?? ""
        
        cell.userNameLbl.text = name
        
        cell.selectionStyle = .none
        
        
        let status = feedPosts["onlineStatus"]as? String ?? ""
        
        if status == "1"
        {
            cell.onlineStatus.image = #imageLiteral(resourceName: "greenDot")
        }
        else
        {
            cell.onlineStatus.image = #imageLiteral(resourceName: "grayDot")
        }
        
        
        cell.profilePic.sd_setImage(with: URL(string: profilePic), placeholderImage: UIImage(named: "profile-1"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let feedPosts = self.msgList[indexPath.row]as! NSDictionary
        
        
        
        let id = feedPosts["id"] as! Int
        
        let receiverID = String(describing: id)
        
        let name = feedPosts["name"]as? String ?? ""
        
        
        
        if receiverID == ""
        {
            
        }
        else
        {
         
            let StoaryBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = StoaryBoard.instantiateViewController(withIdentifier: "ChatViewController")as! ChatViewController
            vc.receiverId = receiverID
            vc.name = name
            
            vc.modalTransitionStyle = .crossDissolve
            
            self.present(vc, animated: true, completion: nil)
            
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
   

}

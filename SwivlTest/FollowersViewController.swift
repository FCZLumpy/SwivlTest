//
//  Followers.swift
//  SwivlTest
//
//  Created by LumpyElzas on 25.01.17.
//  Copyright © 2017 LumpyElzas. All rights reserved.
//

import UIKit
import Alamofire

class CellOfFollowers: UITableViewCell
{
    @IBOutlet weak var tlLogin: UILabel!
    @IBOutlet weak var tlLink: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
}

class FollowersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    let maxUsers = 100
    var usersArray = [UserModel]()
    var followersUrl = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Followers"
        tableView.estimatedRowHeight = 94
    
        Alamofire.request(followersUrl).responseJSON { response in
            
            if let JSON = response.result.value
            {
                for user in JSON as! Array<Dictionary<String, AnyObject>>
                {
                    let userModel = UserModel(avatarUrl: user["avatar_url"] as! String, login: user["login"] as! String, link: user["url"] as! String, id: user["id"] as! Int, followers: user["followers_url"] as! String)
                    
                    self.usersArray.append(userModel)
                    if(self.usersArray.count == self.maxUsers)
                    {
                        self.tableView.reloadData()
                        return
                    }
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return usersArray.count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOfFollowers", for: indexPath) as! CellOfFollowers
        cell.tlLink.text = usersArray[indexPath.row].link
        cell.tlLogin.text = usersArray[indexPath.row].login
        let url = URL(string: usersArray[indexPath.row].avatarUrl)
        
        if(cell.spinner != nil)
        {
            cell.spinner.startAnimating()
        }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.imageAvatar.image = UIImage(data: data!)
                if(cell.spinner != nil)
                {
                    cell.spinner.stopAnimating()
                    cell.spinner.removeFromSuperview()
                }
            }
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

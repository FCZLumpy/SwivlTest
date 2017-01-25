//
//  ViewController.swift
//  SwivlTest
//
//  Created by LumpyElzas on 24.01.17.
//  Copyright © 2017 LumpyElzas. All rights reserved.
//

import UIKit
import Alamofire

class CellOfViewController: UITableViewCell
{
    @IBOutlet weak var tlLogin: UILabel!
    @IBOutlet weak var tlLink: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
}

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let maxUsers = 100
    var usersArray = [UserModel]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Users"
        tableView.estimatedRowHeight = 126
        
        Alamofire.request("https://api.github.com/users").responseJSON { response in
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOfViewController", for: indexPath) as! CellOfViewController
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
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let followersViewController = storyboard?.instantiateViewController(withIdentifier: "FollowersViewController")
        (followersViewController as! FollowersViewController).followersUrl = usersArray[indexPath.row].followers
        self.navigationController?.pushViewController(followersViewController!, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


}


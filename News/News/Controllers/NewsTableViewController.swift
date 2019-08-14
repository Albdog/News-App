//
//  NewsTableViewController.swift
//  News
//
//  Created by Joaquin Jacinto on 8/13/19.
//  Copyright © 2019 Joaquin Jacinto. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsTableViewController: UITableViewController {
    
    var newsArticles = [[String:AnyObject]]()

    //move to extension
    func loadNewsArticles(completion: @escaping (JSON?) -> Void) {
        let url = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=" + "3be68be40de74b5caba36f3852414f40"
        
        Alamofire.request(url).responseJSON { resposeData in
            guard resposeData.result.isSuccess, let value = resposeData.result.value else {
                print("Error fetching news articles")
                completion(nil)
                return
            }
            
            let swiftyJsonVar = JSON(value)
            
            if let resData = swiftyJsonVar["articles"].arrayObject {
                self.newsArticles = resData as! [[String:AnyObject]]
            }
            
            if self.newsArticles.count > 0 {
                self.tableView.reloadData()
            }
            
            completion(swiftyJsonVar)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadNewsArticles { (JSON) in }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsArticles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as? NewsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of NewsViewCell.")
        }
        
        var article = newsArticles[indexPath.row]
        
        cell.newsTitle.text = article["title"] as? String
        if let urlImage = article["urlToImage"] as? String {
            print(urlImage)
            cell.newsImage.downloaded(from: urlImage)
        }
        cell.newsDescription.text = article["description"] as? String

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

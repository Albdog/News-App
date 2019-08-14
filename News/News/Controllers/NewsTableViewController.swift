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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNewsArticles { (JSON) in }
    }

    @IBAction func reloadPressed(_ sender: Any) {
        loadNewsArticles { (JSON) in }
        print("reload pressed")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArticles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as? NewsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of NewsViewCell.")
        }
        
        var article = newsArticles[indexPath.row]
        
        cell.newsTitle.text = article["title"] as? String
        
        if let urlImage = article["urlToImage"] as? String {
            let url = URL(string: urlImage)
            if let data = try? Data(contentsOf: url!) {
                cell.newsImage.image = UIImage(data: data)
            }
        } else {
            
        }
        
        if let description = article["description"] as? String {
            cell.newsDescription.text = description
        } else {
            cell.newsDescription.text = "No description."
        }

        return cell
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

extension NewsTableViewController {
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
    
}

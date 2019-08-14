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
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        
        tableView.backgroundView = activityIndicatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNewsArticles { (JSON) in }
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
        
        if let title = article["title"] as? String {
            cell.newsTitle.text = title
        } else {
            cell.newsTitle.text = "No title."
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        guard let selectedNewsCell = sender as? NewsTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        guard let indexPath = tableView.indexPath(for: selectedNewsCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        var article = newsArticles[indexPath.row]
        
        if let webURL = article["url"] as? String {
            detailViewController.webURL = webURL
        }
    }

    @IBAction func reloadPressed(_ sender: Any) {
        newsArticles.removeAll()
        tableView.reloadData()
        loadNewsArticles { (JSON) in }
    }
}

extension NewsTableViewController {
    func loadNewsArticles(completion: @escaping (JSON?) -> Void) {
        let url = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=" + "3be68be40de74b5caba36f3852414f40"
        
        activityIndicatorView.startAnimating()
        tableView.separatorStyle = .none
        
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
                self.activityIndicatorView.stopAnimating()
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
            }
            
            completion(swiftyJsonVar)
        }
    }
}

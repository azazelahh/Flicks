//
//  SecondViewController.swift
//  Flicks
//
//  Created by Olya Sorokina on 10/14/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit
import MBProgressHUD

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nowPlayingTableView: UITableView!
    
    var movies: [NSDictionary] = []
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowPlayingTableView.dataSource = self
        nowPlayingTableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        nowPlayingTableView.insertSubview(refreshControl, at: 0)
        
        let apiKey = "741df6ee3b9192246a5ec24ef12c9a69"
        let url = URL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    
                    self.movies = responseDictionary.value(forKeyPath: "results") as! [NSDictionary]
                    self.nowPlayingTableView.reloadData()
                    
                }
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if (error != nil)
            {
                self.errorLabel.text = "⚠︎ Network Error"
                self.errorLabel.isHidden = false
            }
        });
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "olya.MovieCell", for: indexPath as IndexPath) as! MovieTableViewCell
        
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.value(forKey: "title") as! String?
        cell.summaryLabel.text = movie.value(forKey: "overview") as! String?
        
        let imageFile = movie.value(forKey: "poster_path")
        let imageUrl = "https://image.tmdb.org/t/p/w500\(imageFile!)"
        cell.posterImage.setImageWith(URL(string:imageUrl)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! MovieDetailsViewController
        var indexPath = nowPlayingTableView.indexPath(for: sender as! UITableViewCell)
        let movie = movies[(indexPath?.row)!]
        let imageFile = movie.value(forKey: "poster_path")
        let imageUrl = "https://image.tmdb.org/t/p/w500\(imageFile!)"
        vc.url = imageUrl
        
        let title = movie.value(forKey: "title")
        let releaseDate = movie.value(forKey: "release_date")
        let rating = movie.value(forKey: "vote_average")
        let summary = movie.value(forKey: "overview")
        vc.summary = "\(title!)\n\n\(releaseDate!)  " + "❤️" + "  \(rating!) \n\n\(summary!)\n"
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nowPlayingTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        let apiKey = "741df6ee3b9192246a5ec24ef12c9a69"
        let url = URL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    
                    self.movies = responseDictionary.value(forKeyPath: "results") as! [NSDictionary]
                    self.nowPlayingTableView.reloadData()
                    
                }
            }
            
            if (error != nil)
            {
                self.errorLabel.text = "⚠︎ Network Error"
                self.errorLabel.isHidden = false
            }
        });
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


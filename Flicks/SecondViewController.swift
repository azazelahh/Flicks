//
//  SecondViewController.swift
//  Flicks
//
//  Created by Olya Sorokina on 10/14/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit
import MBProgressHUD

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{

    @IBOutlet weak var topRatedTableView: UITableView!
    
    var movies: [NSDictionary] = []
    var originalMovies: [NSDictionary] = []
    
    let searchBar = UISearchBar()
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSearchBar()
        
        topRatedTableView.dataSource = self
        topRatedTableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        topRatedTableView.insertSubview(refreshControl, at: 0)
        
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
                    self.originalMovies = responseDictionary.value(forKeyPath: "results") as! [NSDictionary]
                    self.topRatedTableView.reloadData()
                    
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
        
        var imageUrl = "https://image.tmdb.org/t/p/"
        
        var imageFile = movie.value(forKey: "poster_path") as? String
        if (imageFile == nil)
        {
            imageFile = movie.value(forKey: "backdrop_path") as? String
            imageUrl += "w300" + (imageFile)!
        }
        else{
            imageUrl += "w500" + (imageFile)!
        }
        
        let imageRequest = NSURLRequest(url: NSURL(string: imageUrl)! as URL)
        
        cell.posterImage.setImageWith(
            imageRequest as URLRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.posterImage.alpha = 0.0
                    cell.posterImage.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.posterImage.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.posterImage.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        searchBar.endEditing(true)
        
        let vc = segue.destination as! MovieDetailsViewController
        var indexPath = topRatedTableView.indexPath(for: sender as! UITableViewCell)
        let movie = movies[(indexPath?.row)!]
        
        var imageUrl = "https://image.tmdb.org/t/p/"
        
        var imageFile = movie.value(forKey: "poster_path") as? String
        if (imageFile == nil)
        {
            imageFile = movie.value(forKey: "backdrop_path") as? String
            imageUrl += "w300" + (imageFile)!
        }
        else{
            imageUrl += "w500" + (imageFile)!
        }
        vc.url = imageUrl
        
        let title = movie.value(forKey: "title")
        let releaseDate = movie.value(forKey: "release_date")
        let rating = movie.value(forKey: "vote_average")
        let summary = movie.value(forKey: "overview")
        vc.summary = "\(title!)\n\n\(releaseDate!)  " + "❤️" + "  \(rating!) \n\n\(summary!)\n"
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        topRatedTableView.deselectRow(at: indexPath, animated: true)
    }
    
    ///
    ///Makes a network request to get updated data
    /// Updates the tableView with the new data
    /// Hides the RefreshControl
    ///
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
                    self.topRatedTableView.reloadData()
                    
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
    
    ///
    ///Search Implementation
    ///
    func createSearchBar()
    {
        searchBar.placeholder = "Enter search terms here"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty){
            self.movies = originalMovies
        }
        else{
            self.movies = originalMovies.filter() {
                let title = ($0 as NSDictionary).value(forKey: "title") as! String
                return title.contains(searchText)
            }
        }
        
        self.topRatedTableView.reloadData()
    }
    ///
    ///Search Implementation Ends
    ///

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


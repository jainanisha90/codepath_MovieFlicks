//
//  MoviesViewController.swift
//  MovieFlicks
//
//  Created by Anisha Jain on 3/29/17.
//  Copyright © 2017 Anisha Jain. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies :NSArray?
    var endpoint : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        // Do any additional setup after loading the view.
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as? NSArray
                        self.tableView.reloadData()
                    }
                }
                
                MBProgressHUD.hide(for: self.view, animated: true)
        });
        task.resume()
        
    }
    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // ... Create the URLRequest `myRequest` ...
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        }
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let movie = movies?[indexPath.row] as? NSDictionary {
            
            if let posterPath = movie["poster_path"] as? String {
                let imageUrlString = NSURL(string: baseUrl + posterPath)
                cell?.movieThumbnailView.setImageWith(imageUrlString! as URL)
            }
            
            if let title = movie["title"] as? String {
                cell?.movieTitle.text = title
            }
            if let overview = movie["overview"] as? String {
                cell?.movieOverview.text = overview
                //cell?.movieOverview.sizeToFit()
            }
        }
        
        tableView.rowHeight = 120
        return cell!
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies?[indexPath!.row]
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie as! NSDictionary!
        tableView.deselectRow(at: indexPath!, animated: true)
        
    }
    
    
}

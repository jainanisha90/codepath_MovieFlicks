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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBAction func onTap(_ sender: Any) {
        searchBar.endEditing(true)
    }
    
    var movies :[NSDictionary]?
    var endpoint : String?
    var searchActive : Bool = false
    var filtered: [NSDictionary]?

    // Initialize a UIRefreshControl
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

        self.errorLabel.frame.size.height = 0
        
        refreshControl.addTarget(self, action: #selector(loadMoviesData), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        loadMoviesData()
    }
    
    func loadMoviesData() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main)
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        
                        self.errorLabel.frame.size.height = 0
                        // Reload the tableView now that there is new data
                        self.tableView.reloadData()
                    }
                } else {
                    self.errorLabel.frame.size.height = 22
                }
                
                // Tell the refreshControl to stop spinning
                self.refreshControl.endRefreshing()
                
                // Hide heads up display progress
                MBProgressHUD.hide(for: self.view, animated: true)
        });
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered?.count ?? 0
        }
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell
        cell?.selectionStyle = .blue

        let baseUrl = "https://image.tmdb.org/t/p/w500"
        
        var movieList: [NSDictionary]? = (searchActive ? filtered! : movies!)
        
        if let movie = movieList?[indexPath.row] {
            if let posterPath = movie["poster_path"] as? String {
                let imageUrlString = NSURL(string: baseUrl + posterPath)
                cell?.movieThumbnailView.setImageWith(imageUrlString! as URL)
            }
        
            if let title = movie["title"] as? String {
                cell?.movieTitle.text = title
            }
            if let overview = movie["overview"] as? String {
                cell?.movieOverview.text = overview
            }
        }
        tableView.rowHeight = 120
        return cell!
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        //tapGesture.cancelsTouchesInView = true
        tapGesture.isEnabled = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        //tapGesture.cancelsTouchesInView = false
        tapGesture.isEnabled = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String ){
        if searchText.isEmpty {
            filtered = movies!
        } else {
            filtered = movies!.filter({ (movie) -> Bool in
                let tmp: NSString = movie["title"] as! NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
        }
        searchActive = true
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies?[indexPath!.row]
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        tableView.deselectRow(at: indexPath!, animated: true)
    }
    
}

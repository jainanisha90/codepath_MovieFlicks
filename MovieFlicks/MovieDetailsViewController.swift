//
//  MovieDetailsViewController.swift
//  MovieFlicks
//
//  Created by Anisha Jain on 3/31/17.
//  Copyright © 2017 Anisha Jain. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePosterView: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie : NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        
        movieTitle.text = title
        movieOverview.text = overview
        movieOverview.sizeToFit()
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrlString = NSURL(string: baseUrl + posterPath)
            moviePosterView.setImageWith((imageUrlString!) as URL)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Weijie Chen on 3/30/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{
    
    var movieposts : [NSDictionary] = []
    let refreshControl = UIRefreshControl()
    let baseUrl : String = "http://image.tmdb.org/t/p/"
    let posterSmall : String = "w92"
    let posterLarge : String = "w500"
    @IBOutlet weak var movietableview: UITableView!
    @IBOutlet weak var networkerrorview: UIView!
    
    @IBOutlet weak var networkerrortext: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movietableview.dataSource = self
        movietableview.delegate = self
        movietableview.rowHeight = 100
        // Do any additional setup after loading the view.
        
        initializeMovies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initializeMovies(){
        refreshControl.tintColor = UIColor.white
        refreshControl.attributedTitle = NSAttributedString(string: "Release to refresh")
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: UIControlEvents.valueChanged)
        movietableview.insertSubview(refreshControl, at: 0)
        
        self.networkerrorview.isHidden = false
        self.movietableview.addSubview(networkerrorview)
        self.movietableview.bringSubview(toFront: networkerrorview)
        loadMovies()
    }
    
    func refreshMovies(){
        loadMovies()
    }
    
    func loadMovies(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=2682b3b6bb9c066686bac9b3362c271d")
        
        let request = URLRequest(url: url!)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                    
                        

                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["results"] as! [NSDictionary]
                        self.movieposts.append(contentsOf: responseFieldDictionary)
                        
                        
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.networkerrorview.isHidden = true
                        self.movietableview.reloadData()
                        
                        
                    }else{
                        self.networkerrorview.isHidden = false
                    }
                }
                self.refreshControl.endRefreshing()
                
                //Hide HUD once the network request come back
                MBProgressHUD.hide(for:self.view,animated:true)
                
        });
        
        task.resume()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieposts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MoviesTableViewCell
        
        cell.cell_image.frame = CGRect(x: 0, y: 0, width: Int(movietableview.frame.width * 0.3), height: Int(movietableview.rowHeight * 0.9))
        
        let post = movieposts[indexPath.row]
        if let posterPath = post.value(forKey: "poster_path") as? String{
            
            let posterUrl = URL(string: (self.baseUrl + self.posterSmall + posterPath))
            
            cell.posterPath = posterPath
            
            cell.cell_image.setImageWith(posterUrl!)
            cell.cell_image.frame = CGRect(x: 5, y: 5, width: 80, height: 90)
        }else{
            
        }
        
        if let movietitle = post.value(forKey: "title") as? String{
            cell.cell_title.text = movietitle
        }else{
        
        }
        
        if let movieoverview = post.value(forKey: "overview") as? String{
            cell.cell_overview.text = movieoverview
            //cell.cell_overview.sizeToFit()
        }else{
        
        }
        
        if let movieid = post.value(forKey: "id") as? Int{
            cell.movieId = movieid
        }else{
        }
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! MovieDetailViewController
        
        let posterUrl = URL(string: (self.baseUrl + self.posterLarge + (sender! as! MoviesTableViewCell).posterPath!))
        let posterData = try? Data(contentsOf: posterUrl!)
        destinationViewController.detailImage = UIImage(data: posterData!)
        destinationViewController.movie_id = (sender! as! MoviesTableViewCell).movieId
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

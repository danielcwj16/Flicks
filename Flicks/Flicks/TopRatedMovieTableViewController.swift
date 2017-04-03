//
//  TopRatedMovieTableViewController.swift
//  Flicks
//
//  Created by Weijie Chen on 4/2/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD



class TopRatedMovieTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    var topratedmovies : [NSDictionary] = []
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var networkerrorview: UIView!
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var networkerrortext: UILabel!
    let baseUrl : String = "http://image.tmdb.org/t/p/"
    let posterSmall : String = "w92"
    let posterLarge : String = "w500"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table_view.dataSource = self
        table_view.delegate = self
        table_view.rowHeight = 100
        initializeTopMovies()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func initializeTopMovies(){
        refreshControl.addTarget(self, action: #selector(refreshTopRated), for: UIControlEvents.valueChanged)
        table_view.insertSubview(refreshControl, at: 0)
        self.networkerrorview.isHidden = true
        loadTopRated()
    }
    
    func refreshTopRated(){
        loadTopRated()
    }
    
    func loadTopRated(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=2682b3b6bb9c066686bac9b3362c271d")
        
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
                        self.topratedmovies.append(contentsOf: responseFieldDictionary)
                        //self.refreshControl.endRefreshing()
                        
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.table_view.reloadData()
                        
                        
                    }
                }
                else{
                    self.networkerrorview.isHidden = false
                    self.table_view.addSubview(self.networkerrorview)
                    self.table_view.bringSubview(toFront: self.networkerrorview)

                }
                self.refreshControl.endRefreshing()
                //Hide HUD once the network request come back
                MBProgressHUD.hide(for:self.view,animated:true)
        });
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topratedmovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedCell") as! TopRatedMovieTableViewCell
        
        cell.image_view.frame = CGRect(x: 0, y: 0, width: Int(tableView.frame.width * 0.3), height: Int(tableView.rowHeight * 0.9))
        
        let post = topratedmovies[indexPath.row]
        if let posterPath = post.value(forKey: "poster_path") as? String{
            
            let posterUrl = URL(string: (self.baseUrl + self.posterSmall + posterPath))
            
            cell.posterPath = posterPath
            
            cell.image_view.setImageWith(posterUrl!)
            cell.image_view.frame = CGRect(x: 5, y: 5, width: 80, height: 90)
        }else{
            
        }
        
        if let movietitle = post.value(forKey: "title") as? String{
            cell.movie_title.text = movietitle
        }else{
            
        }
        
        if let movieoverview = post.value(forKey: "overview") as? String{
            cell.movie_overview.text = movieoverview
            //cell.movie_overview.sizeToFit()
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
        
        let posterUrl = URL(string: (self.baseUrl + self.posterLarge + (sender! as! TopRatedMovieTableViewCell).posterPath!))
        let posterData = try? Data(contentsOf: posterUrl!)
        destinationViewController.detailImage = UIImage(data: posterData!)
        destinationViewController.movie_id = (sender! as! TopRatedMovieTableViewCell).movieId
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

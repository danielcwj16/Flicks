//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by Weijie Chen on 3/30/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var detail_imageview: UIImageView!
    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var content_view: UIView!
    
    @IBOutlet weak var movie_title: UILabel!
    @IBOutlet weak var release_date: UILabel!
    @IBOutlet weak var time_duration: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    var detailImage : UIImage!
    var movie_id : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detail_imageview.image = detailImage
        initscrollview()
        loadMovieDetail()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initscrollview(){
        let contentWidth = scroll_view.bounds.width
        let contentHeight = content_view.frame.origin.y + content_view.frame.height
        
        scroll_view.contentSize = CGSize(width: contentWidth, height: contentHeight)
        scroll_view.addSubview(content_view)
    }
    
    func loadMovieDetail(){
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(self.movie_id!)?api_key=2682b3b6bb9c066686bac9b3362c271d")
        
        let request = URLRequest(url: url!)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        if let title = responseDictionary["title"] as? String
                        {
                            self.movie_title.text = title
                        }else{
                        }
                        
                        if let release_date = responseDictionary["release_date"] as? String{
                            self.release_date.text = release_date
                        }else{
                        }
                        if let runtime = responseDictionary["runtime"] as? Int{
                            self.time_duration.text = "\(runtime) min"
                        }else{
                        }
                        
                        if let vote_average = responseDictionary["vote_average"] as? Double{
                            self.score.text = "\(vote_average)"
                        }else{
                        
                        }
                        
                        if let overview = responseDictionary["overview"] as? String{
                            self.overview.text = overview
                            //self.overview.sizeToFit()
                        }else{
                        }
                        
                        
                        
                        
                    }
                }
        });
        
        task.resume()
        
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

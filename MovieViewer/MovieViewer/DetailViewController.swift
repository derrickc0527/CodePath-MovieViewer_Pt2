//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Derrick Chong on 2/10/17.
//  Copyright © 2017 DerrickCorp. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var posterimageview: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var overviewlabel: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var infoview: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollview.contentSize = CGSize(width: scrollview.frame.size.width, height: infoview.frame.origin.y + infoview.frame.size.height)
        
        let title = movie["title"] as! String
        titlelabel.text = title
        
        let overview = movie["overview"] as! String
        overviewlabel.text = overview
        
        overviewlabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String{
            let imageUrl = NSURL(string: baseUrl + posterPath)
            posterimageview.setImageWith(imageUrl as! URL)
        }
        print (movie)

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

//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Derrick Chong on 1/31/17.
//  Copyright © 2017 DerrickCorp. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableview: UITableView!

    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl?;
    //var refreshing = false;
    var endpoint: String = "";
    var searchbar = UISearchBar();
    var filterdata: [NSDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self

        //search function
        searchbar.delegate = self;
        searchbar.sizeToFit();
        searchbar.placeholder = "Search";
        self.navigationItem.titleView = searchbar;

        let refreshControl = UIRefreshControl();
        //refreshControl.addTarget(self, action: Selector(("refreshControlAction:")), for: UIControlEvents.valueChanged)
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)

        // add refresh control to table view
        tableview.insertSubview(refreshControl, at: 0)
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(self.endpoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

        MBProgressHUD.showAdded(to: self.view, animated: true)

        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)

                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.tableview.reloadData()
                }
            }
        };
        MBProgressHUD.hide(for: self.view, animated: true)
        task.resume()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {

        // ... Create the URLRequest `myRequest` ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

        MBProgressHUD.showAdded(to: self.view, animated: true)

        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)

                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.filterdata  = self.movies
                    self.tableview.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        };
        MBProgressHUD.hide(for: self.view, animated: true)
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        if let filterdata = filterdata{
            return filterdata.count
        }else {
            return 0
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableview.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filterdata![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w500"

        if let posterPath = movie["poster_path"] as? String{
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.imagewindow.setImageWith(imageUrl as! URL)
        }

        cell.titleLabel.text = title
        cell.overviewLabel.text = overview

        //cell.textLabel!.text = title
        //print("row \(indexPath.row)")
        return cell
    }

    func tableView(_ tableView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        tableView.deselectItem(at: indexPath, animated: true)
        tableView.reloadItems(at: [indexPath])
    }

    func searchBarTextDidBeginEditing(_ searchbar: UISearchBar){
      self.searchbar.showsCancelButton = true
    }

  func searchBarCancelButtonClicked(_ searchbar: UISearchBar){
    searchbar.showsCancelButton = false
    searchbar.text = ""
    searchbar.resignFirstResponder()
  }

  func searchbar(_ searchbar: UISearchBar, textDidChange searchText: String){

    filterdata = searchText.isEmpty ? movies: movies!.filter({(dataString: NSDictionary) -> Bool in
      let title = dataString["title"] as! String
      return title.range(of: searchText, options: .caseInsensitive) != nil
    })
    tableview.reloadData()
  }


     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableview.indexPath(for: cell)
        let movie = movies![indexPath!.row]

        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie



     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }

}

//
//  Top250ViewController.swift
//  movieSearch
//
//  Created by Switch on 28.09.2021.
//

import UIKit
import SafariServices

class Top250ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    var isTop250: Bool = true
    var movies: [TopMovie] = []
    var x = DataLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isTop250 {
            table.register(TopMovieTableViewCell.nib(), forCellReuseIdentifier: "TopMovieTableViewCell")
            table.dataSource = self
            table.delegate = self
            navigationController?.isNavigationBarHidden = true
            fillTableWithMovies(table: table)
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isTop250 {
            return "Top 250"
        } else {
            return "Your random movie to watch"
        }
    }
    func fillTableWithMovies(table: UITableView) {
        guard let validUrl = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_8srn3ur4") else {
            print("Found nil")
            return
        }
        URLSession.shared.dataTask(with: validUrl, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                return
            }
            var result: TopMovieResult?
            do {
                result = try JSONDecoder().decode(TopMovieResult.self, from: data)
            } catch {
                print("Error on decoding")
            }
            
            guard let validResult = result else {
                return
            }
            self.movies.append(contentsOf: validResult.items)
            DispatchQueue.main.async {
                table.reloadData()
            }
            
        }).resume()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopMovieTableViewCell", for: indexPath) as! TopMovieTableViewCell
        cell.configurate(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].id)/"
        guard let validUrl = URL(string: url) else {
            return
        }
        let vc = SFSafariViewController(url: validUrl)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    

}




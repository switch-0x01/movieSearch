//
//  ViewController.swift
//  movieSearch
//
//  Created by Switch on 27.09.2021.
//

import UIKit
import SafariServices

class MovieSearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var field: UITextField!
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.layer.cornerRadius = 50
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    func searchMovies() {
        field.resignFirstResponder()
        guard let text = field.text, !text.isEmpty else {
            return
        }

        let query = text.replacingOccurrences(of: " ", with: "%20")

        movies.removeAll()
        
        guard let validUrl = URL(string:"https://www.omdbapi.com/?apikey=41b40f88&s=\(query)&type=movie") else {
            print("found nil")
            return
        }
        
        URLSession.shared.dataTask(with: validUrl, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            // convert the data to the Movie struct
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            } catch {
                print("Error on decoding")
            }
            
            guard let validResult = result else {
                return
            }
            // update movie array
            let newMovies = validResult.search
            self.movies.append(contentsOf: newMovies)
            // refresh our table
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
        }).resume()
        
        
    }
    
    
    // table

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configurate(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Show movie details
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
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


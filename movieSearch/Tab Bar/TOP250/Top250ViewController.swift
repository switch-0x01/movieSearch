//
//  Top250ViewController.swift
//  movieSearch
//
//  Created by Switch on 28.09.2021.
//

import UIKit
import SafariServices

class Top250ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var isTop250: Bool = true
    var movies: [TopMovie] = []
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isTop250 {
            table.register(TopMovieTableViewCell.nib(), forCellReuseIdentifier: "TopMovieTableViewCell")
            table.dataSource = self
            table.delegate = self
            navigationController?.isNavigationBarHidden = true
            fillTableWithMovies(table: table)
        }
    }
    
    func fillTableWithMovies(table: UITableView) {
      networkManager.fetchMoviesTOP250 { [weak self] result in
        switch result {
        case .success(let movies):
          self?.movies.append(contentsOf: movies)
          DispatchQueue.main.async {
            table.reloadData()
          }
        case.failure(let error):
          print("Error: \(String(describing: error.localizedDescription))")
        }
      }
    }
}

extension Top250ViewController: UITableViewDataSource {
  
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
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      if isTop250 {
          return "Top 250"
      } else {
          return "Your random movie to watch"
      }
  }
}

extension Top250ViewController: UITableViewDelegate {}




//
//  ViewController.swift
//  movieSearch
//
//  Created by Switch on 27.09.2021.
//

import UIKit
import SafariServices

class MovieSearchViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var field: UITextField!
    var movies: [Movie] = []
    let networkManager = NetworkManager()
    
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

    
    func searchMovies() {
        field.resignFirstResponder()
        guard let text = field.text, !text.isEmpty else {
            return
        }
        let query = text.replacingOccurrences(of: " ", with: "%20")
        movies.removeAll()
      
      networkManager.fetchMoviesForSearch(query: query) { [weak self] result in
        switch result {
        case .success(let movies):
          self?.movies.append(contentsOf: movies)
          DispatchQueue.main.async {
            self?.table.reloadData()
          }
        case .failure(let error):
          print("Error: \(error)")
        }
      }
    }

}

extension MovieSearchViewController: UITableViewDataSource {
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

extension MovieSearchViewController: UITableViewDelegate {}

extension MovieSearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      searchMovies()
      return true
  }
}

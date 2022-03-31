//
//  RandomMovieViewController.swift
//  movieSearch
//
//  Created by Switch on 01.10.2021.
//

import UIKit
import SafariServices

class RandomMovieViewController: Top250ViewController {

    
    @IBOutlet weak var newTable: UITableView!
    @IBOutlet weak var randomMovieBtn: UIButton!
    var randomNumber = Int.random(in: 0..<250)
    override func viewDidLoad() {
        isTop250 = false
        super.viewDidLoad()
        newTable.register(RandomMovieTableViewCell.nib(), forCellReuseIdentifier: "RandomMovieTableViewCell")
        newTable.dataSource = self
        newTable.delegate = self
        navigationController?.isNavigationBarHidden = true
        fillTableWithMovies(table: newTable)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RandomMovieTableViewCell", for: indexPath) as! RandomMovieTableViewCell
        cell.configurate(with: movies[self.randomNumber])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = "https://www.imdb.com/title/\(movies[self.randomNumber].id)/"
        guard let validUrl = URL(string: url) else {
            return
        }
        let vc = SFSafariViewController(url: validUrl)
        present(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    @IBAction func tryAgain(_ sender: Any) {
        self.randomNumber = Int.random(in: 0..<250)
        DispatchQueue.main.async {
            self.newTable.reloadData()
        }
    }
}

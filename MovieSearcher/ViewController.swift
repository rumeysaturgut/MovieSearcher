//
//  ViewController.swift
//  MovieSearcher
//
//  Created by Developer on 25.07.2022.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()

    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
        
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
        
        URLSession.shared.dataTask(with: URL(string: "https://imdb-api.com/en/API/SearchMovie/k_wnpdcwy2/\(query)")!,                           completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            // Convert
            
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            
            catch {
                print("error")
            }
            
            guard let finalResult = result else {
                return
            }
            
            //Update our movies array
            
            let newMovies = finalResult.results
            self.movies.append(contentsOf: newMovies)
            
            //Refresh our table
            
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
            
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
            cell.configure(with: movies[indexPath.row])
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].id)/"
                let vc = SFSafariViewController(url: URL(string: url)!)
                present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 200
        }
}

struct  MovieResult: Codable {
    let results: [Movie]
}

struct  Movie: Codable {
    let title: String
    let description: String
    let id: String
    let image: String
    
    private enum codingKeys: String, CodingKey {
        case title, description, id, image
    }
}






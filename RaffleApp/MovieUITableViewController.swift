//
//  MovieUITableViewController.swift
//  Tutorial5
//
//  Created by Brandon Nimmett on 15/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class MovieUITableViewController: UITableViewController {

    var movies = [Movie]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabasesdfg")
        
        database.insert(movie:Movie(name:"Lord of the Rings", year:2003, director:"Peter Jackson"))
        database.insert(movie:Movie(name:"The Matrix", year:1999, director:"Lana Wachowski, Lilly Wachowski"))
        
        movies = database.selectAllMovies()
    
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieUITableViewCell", for: indexPath)

        let movie = movies[indexPath.row]
        
        if let movieCell = cell as? MovieUITableViewCell
        {
            movieCell.titleLabel.text = movie.name
            movieCell.subTitleLabel.text = String(movie.year)
        }
        
        
        return cell
    }
    

    override func   prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowMovieDetailSegue"
        {
            guard let detailViewController = segue.destination as? DetailViewController else
            {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMovieCell = sender as? MovieUITableViewCell else
            {
                fatalError("Unexpected sender: \( String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMovieCell) else
            {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMovie = movies[indexPath.row]
            detailViewController.movie = selectedMovie
        }
    }

}

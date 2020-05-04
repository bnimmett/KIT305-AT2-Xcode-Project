//
//  ViewController.swift
//  Tutorial5
//
//  Created by Lindsay Wells.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // a handle to the database itself
    // you can switch databases or create new blank ones by changing databaseName
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabasesdfg")

    override func viewDidLoad() {
        super.viewDidLoad()

        database.insert(movie:Movie(name:"Lord of the Rings", year:2003, director:"Peter Jackson"))
        database.insert(movie:Movie(name:"The Matrix", year:1999, director:"Lana Wachowski, Lilly Wachowski"))
        
        print(database.selectAllMovies())
        //print(database.selectMovieBy(id:8) ?? "Movie not found")
    }


}


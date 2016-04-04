//
//  Database.swift
//  Sierra Valley
//
//  Created by Jack Arendt on 4/3/16.
//  Copyright © 2016 John Arendt. All rights reserved.
//

import Foundation

/// The Database class represents the locally stored data on the device
public class Database {
    
    // MARK: public variables
    
    /// Shared instance of database
    static public let database = Database()
    
    /// The current user of the game
    public var user = User()
    
    /// The unlocked cars
    public var cars = [SVCar]()
    
    // MARK: keys
    private let highScoreKey = "highscore"
    private let avalancheKey = "avalanche"
    private let userKey = "user"
    private let gamesPlayedKey = "gamesplayed"
    private let totalAvalanchesKey = "totalavalanches"
    private let carsKey = "cars"
    
    /// The path of the database
    private lazy var path : NSURL? = {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let url = NSURL(fileURLWithPath: paths.first!)
        return url.URLByAppendingPathComponent("database.json")
    }()
    
    /// Creates a new instance of the database
    init() {
        // if the path exists parse the JSON and create db objects
        if let path = path, data = NSData(contentsOfURL: path) {
            if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String : AnyObject] {
                parseJSON(json!)
                print(json)
            } else {
                print("database is corrupted")
            }
        } else { // first time launch, creates db objects and saves the db file
            let db = initializeDatabase()
            parseJSON(db)
            save()
        }
    }
    
    /// Initializes the database
    private func initializeDatabase() -> [String : AnyObject] {
        var db = [String : AnyObject]()
        var user = [String : Int]()
        user[highScoreKey] = 0
        user[avalancheKey] = 0
        user[gamesPlayedKey] = 0
        user[totalAvalanchesKey] = 0
        
        db[userKey] = user
        
        let cars = [SVCar.SierraTurbo.rawValue]
        db[carsKey] = cars
        
        return db
    }
    
    /// Parses the JSON so that it can be used by other classes
    private func parseJSON(json : [String : AnyObject]) {
        if let _user = json[userKey] as? [String : Int] {
            user.highScore = _user[highScoreKey]!
            user.avalanches = _user[avalancheKey]!
            user.gamesPlayed = _user[gamesPlayedKey]!
            user.totalAvalanches = _user[totalAvalanchesKey]!
        }
        
        if let _cars = json[carsKey] as? [String] {
            for car in _cars {
                cars.append(SVCar(rawValue: car)!)
            }
        }
    }
    
    /// Saves all of the current values in the database
    public func save() -> Bool {
        var db = [String : AnyObject]()
        var _user = [String : Int]()
        
        // atomically create user object
        objc_sync_enter(user)
        _user[highScoreKey] = user.highScore
        _user[avalancheKey] = user.avalanches
        _user[gamesPlayedKey] = user.gamesPlayed
        _user[totalAvalanchesKey] = user.totalAvalanches
        objc_sync_exit(user)
        
        db[userKey] = _user
        
        var _cars = [String]()
        for car in cars {
            _cars.append(car.rawValue)
        }
        db[carsKey] = _cars
        
        /// write the JSON object to the filesystem
        if let path = path, data = try? NSJSONSerialization.dataWithJSONObject(db, options: .PrettyPrinted) {
            do {
               try data.writeToURL(path, options: .AtomicWrite)
                return true
            } catch {
                print(error)
                return false
            }
        }
        return false
    }
}
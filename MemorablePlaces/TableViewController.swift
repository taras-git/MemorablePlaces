//
//  ViewController.swift
//  MemorablePlaces
//
//  Created by user on 2/14/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import CoreLocation

var defaultPlacesList: [String : CLLocationCoordinate2D] =
    ["Taj Mahal" : CLLocationCoordinate2D(latitude: 21.1, longitude: 78.0),
    "Lviv": CLLocationCoordinate2D(latitude: 21.1, longitude: 78.0)]

struct Places {
    var placeName : String!
    var placeCoordinate : CLLocationCoordinate2D!
}

class TableViewController: UITableViewController {

    var placesArray = [Places]()
    
    fileprivate func getPlacesArray() -> [Places] {
        for (key, value) in defaultPlacesList {
            print("\(key) -> \(value)")
            placesArray.append(Places(placeName: key, placeCoordinate: value))
        }
        print(defaultPlacesList)
        return placesArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getPlacesArray()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        var key  = Array(placesArray)[indexPath.row]
        cell.textLabel?.text = placesArray[indexPath.row].placeName!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            list.remove(at: indexPath.row)
            placesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toMap", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            if let destination = segue.destination as? MapViewController {
                print("segue toMap")
            }
        }
    }


}


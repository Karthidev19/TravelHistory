//
//  ViewController.swift
//  TravelHistory
//
//  Created by Karthikeyan on 28/06/21.
//

import UIKit
import CoreLocation

class ViewController: UITableViewController {
    
    var location: [Locations]? {
        didSet {
            tableView.reloadData()
        }
    }
    var viewModal: LocationViewModal?
    override func viewDidLoad() {
      super.viewDidLoad()
        bind()
    }
    
    func bind() {
        viewModal?.locations.bind(listener: { locations in
            self.location = locations
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Location", for: indexPath)
        let location = location![indexPath.row]
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = location.description
        cell.detailTextLabel?.text = location.dateString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 110
    }
  }


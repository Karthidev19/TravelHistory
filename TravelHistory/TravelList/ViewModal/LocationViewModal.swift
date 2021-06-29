//
//  LocationViewModal.swift
//  TravelHistory
//
//  Created by Karthikeyan on 29/06/21.
//

import UIKit
import Foundation
import CoreData

class LocationViewModal {
    
    var locations: Observable<[Locations]?> = Observable(nil)
    var error: Observable<String?> = Observable(nil)
    
    
    private let fileManager: FileManager
    private let documentsURL: URL
    
    init() {
      let fileManager = FileManager.default
      documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      self.fileManager = fileManager
      
      let jsonDecoder = JSONDecoder()
      
      let locationFilesURLs = try! fileManager.contentsOfDirectory(at: documentsURL,
                                                                   includingPropertiesForKeys: nil)
        locations.value = locationFilesURLs.compactMap { url -> Locations? in
        guard !url.absoluteString.contains(".DS_Store") else {
          return nil
        }
        guard let data = try? Data(contentsOf: url) else {
          return nil
        }
        return try? jsonDecoder.decode(Locations.self, from: data)
        }.sorted(by: { $0.date < $1.date })
    }
    
    func saveLocationOnDisk(_ location: Locations) {
      let encoder = JSONEncoder()
        let timestamp = location.date.timeIntervalSince1970
      let fileURL = documentsURL.appendingPathComponent("\(timestamp)")
      
      let data = try! encoder.encode(location)
      try! data.write(to: fileURL)
        
//        locations.value?.append(location)
//        
//        NotificationCenter.default.post(name: .newLocationSaved, object: self, userInfo: ["location": location])
      
    }
    
    func saveCLLocationToDisk(_ clLocation: CLLocation) {
      let currentDate = Date()
      AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
        if let place = placemarks?.first {
          let location = Locations(clLocation.coordinate, date: currentDate, descriptionString: "\(place)")
          self.saveLocationOnDisk(location)
        }
      }
    }
    
}

extension Notification.Name {
  static let newLocationSaved = Notification.Name("newLocationSaved")
}

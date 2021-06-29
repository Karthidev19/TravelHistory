//
//  AppDelegate.swift
//  TravelHistory
//
//  Created by Karthikeyan on 28/06/21.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let locationManager = CLLocationManager()
    static let geoCoder = CLGeocoder()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        LocationViewModal().locations.bind { location in
            //update the View
        }
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startMonitoringVisits()
        locationManager.delegate = self
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TravelHistory")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
      // create CLLocation from the coordinates of CLVisit
      let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
      
      // Get location description
      AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
        if let place = placemarks?.first {
          let description = "\(place)"
          self.newVisitReceived(visit, description: description)
        }
      }
    }
    
    func newVisitReceived(_ visit: CLVisit, description: String) {
      let location = Locations(visit: visit, descriptionString: description)
        LocationViewModal().saveLocationOnDisk(location)
    }

}


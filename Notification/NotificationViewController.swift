//
//  NotificationViewController.swift
//  Notification
//
//  Created by Jacob Ahlberg on 2020-08-18.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MapKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet var mapView: MKMapView!
    
    func didReceive(_ notification: UNNotification) {
        guard let data = notification.request.content.userInfo["data"] as? Data else { return }
        guard let metaData = try? JSONDecoder().decode(NotificationMetadata.self, from: data) else { return }
        addPin(coordinate: metaData.coordinate)
    }

    private func addPin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)

        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(region, animated: false)
    }

}

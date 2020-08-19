//
//  NotificationMetadata.swift
//  CustomNotification
//
//  Created by Jacob Ahlberg on 2020-08-18.
//

import Foundation
import CoreLocation

struct NotificationMetadata: Codable {
    let title: String
    let body: String
    let coordinate: CLLocationCoordinate2D
    let type: NotificationType

    init(placemark: CLPlacemark, type: NotificationType = .map) throws {
        guard let location = placemark.location,
              let timeZone = placemark.timeZone else {
            throw NotificationError.failedToInitializeData
        }

        self.body = "Timezone: \(timeZone)"
        self.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.type = type

        if let country = placemark.country, let subLocality = placemark.subLocality {
            self.title = "\(country) - \(subLocality)"
        } else if let country = placemark.country {
            self.title = country
        } else if let ocean = placemark.ocean {
            self.title = ocean
        } else {
            self.title = "Unknown"
        }
    }
}

extension CLLocationCoordinate2D: Codable {
     public func encode(to encoder: Encoder) throws {
         var container = encoder.unkeyedContainer()
         try container.encode(longitude)
         try container.encode(latitude)
     }

     public init(from decoder: Decoder) throws {
         var container = try decoder.unkeyedContainer()
         let longitude = try container.decode(CLLocationDegrees.self)
         let latitude = try container.decode(CLLocationDegrees.self)
         self.init(latitude: latitude, longitude: longitude)
     }
 }

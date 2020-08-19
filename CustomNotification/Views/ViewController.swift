//
//  ViewController.swift
//  CustomNotification
//
//  Created by Jacob Ahlberg on 2020-08-18.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var counterLabel: UILabel!

    var timer: Timer?
    var count = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func sendNotificationPressed(_ sender: Any?) {
        generateNotificationContent { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let notificationData): self.send(notificationData)
            case .failure(let error): self.showAlert(with: error)
            }
        }
    }

    private func generateNotificationContent(callback: @escaping (Result<NotificationMetadata, Error>) -> Void) {
        guard let latitudeText = latitudeTextField.text,
              let longitudeText = longitudeTextField.text else {
            return
        }

        guard let latitude = CLLocationDegrees(latitudeText),
              let longitude = CLLocationDegrees(longitudeText) else {
            return
        }

        let location = CLLocation(latitude: latitude, longitude: longitude)

        let geoCoder = CLGeocoder()

        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                callback(.failure(error))
                return
            }

            guard let placemarks = placemarks else { return }
            guard let placemark = placemarks.first else { return }
            do {
                let data = try NotificationMetadata(placemark: placemark)
                callback(.success(data))
            } catch {
                callback(.failure(error))
            }
        }
    }

    private func send(_ notification: NotificationMetadata) {
        startTimer()
        NotificationManager.current.sendNotification(with: notification) { [weak self] (result) in
            guard let self = self else { return }
            guard case .failure(let error) = result else {
                return
            }

            // Handle error
            self.showAlert(with: error)
        }
    }

    private func showAlert(with error: Error) {
        let alert = UIAlertController(title: "Something went wrong.", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Timer

    private func startTimer() {
        count = 3
        timer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(adjustTimerUI), userInfo: nil, repeats: true)
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc
    private func adjustTimerUI() {
        if count > 0 {
            counterLabel.text = "\(count)"
            count -= 1
        } else {
            invalidateTimer()
            counterLabel.text = "-"
        }
    }
}


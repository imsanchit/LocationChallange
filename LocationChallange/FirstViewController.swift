//
//  FirstViewController.swift
//  LocationChallange
//
//  Created by Sanchit Mittal on 17/10/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController , CLLocationManagerDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var visualEffectview: UIVisualEffectView!
    var locationManager = CLLocationManager()
    var countDownTimer = Timer()
    var searchDestinationTimer = Timer()
    var searchDestinationSeconds = 0
    var seconds = 5
    var initialLocation: CLLocation? = nil {
        didSet {
            setMapViewRegion()
            addAnnotation(coordinate: (initialLocation?.coordinate)!)
        }
    }
    var destinationCoordinate: CLLocationCoordinate2D? = nil
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var countDownView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate =  self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        progressView.isHidden = true
        timerLabel.isHidden = true
        countDownView.isHidden = true
    }
    
    @IBAction func playChallange(_ sender: UIButton) {
        visualEffectview.removeFromSuperview()
        mapView.isHidden = true
        showCountDown()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if initialLocation == nil {
            initialLocation = location
            return
        }

        guard let destinationCoordinate = destinationCoordinate else { return }
        
        let distance:Float = Float(location.distance(from: CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)))
        print(distance)
        print("distance is \(distance)")
        calculateProgress(distance: Float(distance))
        if distance == 0 {
            searchDestinationTimer.invalidate()
            saveRecord()
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    private func calculateProgress(distance: Float) {
        
        let distanceBetweenRandomAndInitialLocation: Float = Float(initialLocation!.distance(from: CLLocation(latitude: destinationCoordinate!.latitude, longitude: destinationCoordinate!.longitude)))
        
        if distance == distanceBetweenRandomAndInitialLocation {
            updateProgress(progress: 0.5)
        }
        else {
            let ratio: Float = (distanceBetweenRandomAndInitialLocation - distance) / distanceBetweenRandomAndInitialLocation
             updateProgress(progress: 0.5 + (ratio / 2))
        }
    }
    private func showCountDown() {
        seconds = 5
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDownLabel), userInfo: nil, repeats: true)
        makeRandomDestination()
    }

    func updateCountDownLabel(){
        if seconds > 0 {
            countDownView.isHidden = false
            countDownLabel.text = seconds.description
            seconds = seconds - 1
        }
        else {
            countDownTimer.invalidate()
            countDownView.isHidden = true
            progressView.isHidden = false
            timerLabel.isHidden = false
            mapView.isHidden = false
            searchDestinationSeconds = 0
            searchDestinationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
        }
    }
    
    func updateTimerLabel() {
        searchDestinationSeconds = searchDestinationSeconds + 1
        timerLabel.text = searchDestinationSeconds.description
    }
    
    private func setMapViewRegion() {
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegionMakeWithDistance((initialLocation?.coordinate)!, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(region, animated: true)
    }
    
    private func addAnnotation(coordinate: CLLocationCoordinate2D) {
        let title = "Lat: " + coordinate.latitude.description + " Long: " + coordinate.longitude.description
        let annotationMapVIew = AnnotationMapVIew(title: title, subtitle: "", coordinate: coordinate)
        mapView.addAnnotation(annotationMapVIew)
    }
    
    private func makeRandomDestination() {
        var distance = 1001
        var randomLatitude = 0.0
        var randomLong = 0.0
        while distance > 1000 {
            let d = drand48()
            randomLatitude = Double((arc4random_uniform(2) + 0)) * d - 1 + (initialLocation?.coordinate.latitude)!
            randomLong = Double((arc4random_uniform(2) + 0)) * d - 1 + (initialLocation?.coordinate.longitude)!
            distance = Int((initialLocation?.distance(from: CLLocation(latitude: randomLatitude, longitude: randomLong)))!)
            
        }
        destinationCoordinate = CLLocationCoordinate2D(latitude: randomLatitude, longitude: randomLong)
        
        print("Initial distance is \(distance)")
        addAnnotation(coordinate: destinationCoordinate!)
        updateProgress(progress: 0.5)
    }
    
    private func saveRecord() {
            let alert = UIAlertController(title: "Great", message: "Congratulations you won !! ", preferredStyle: UIAlertControllerStyle.alert)
            let confirmAction = UIAlertAction(title: "Save Record", style: .default) { [weak self] (_) in
                guard let strongSelf = self else { return }
                if let field = alert.textFields![0] as? UITextField{
                    print(field.text!)
                    let defaults = UserDefaults.standard
                    var winnersRecords: [String:Int] =  (defaults.dictionary(forKey: "winnersRecord") != nil) ? defaults.dictionary(forKey: "winnersRecord") as! [String : Int] : [String: Int]()
                    winnersRecords[field.text!] = strongSelf.searchDestinationSeconds
                    defaults.set(winnersRecords, forKey: "winnersRecord")
                }
            }
            alert.addTextField { (textField) in
                textField.placeholder = "Enter name"
            }

            alert.addAction(confirmAction)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
    private func updateProgress(progress: Float) {
         progressView.progress = progress
        progressView.trackTintColor = UIColor.white
        switch progress {
        case 0.5:
            progressView.progressTintColor = UIColor.orange
        case 0..<0.5:
            progressView.progressTintColor = UIColor.red
        case 0.5...1:
            progressView.progressTintColor = UIColor.green
        default:
            break
        }
    }
}

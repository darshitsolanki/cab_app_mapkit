//
//  ViewController.swift
//  mapkitDemo5_cab
//
//  Created by Third Rock Techkno on 19/03/20.
//  Copyright © 2020 Third Rock Techkno. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    var array = [Int]()
    @IBOutlet weak var mapView: MKMapView!
    var coordinate1 = CLLocationCoordinate2D(latitude: 23.0335702, longitude: 72.5557826)
    var coordinate2 = CLLocationCoordinate2D(latitude: 23.0335702, longitude: 72.5557826)
    
    @IBOutlet weak var textFieldLocation1: UITextField!
    @IBOutlet weak var textFieldLocation2: UITextField!
    var viewRegion: MKCoordinateRegion!
    var geoCoder: CLGeocoder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldLocation1.becomeFirstResponder()
        
        viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 23.0335702, longitude: 72.5557826), latitudinalMeters: 700, longitudinalMeters: 700)
        mapView.centerCoordinate = viewRegion.center
        geoCoder = CLGeocoder()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.region = viewRegion
        randomNumbers()
    }
    
    func randomNumbers() {
        array =  (0..<100).map { _ in .random(in: 1...1000) }
    }
    
    @IBAction func textField1_EndEditing(_ sender: UITextField) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.coordinate1
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func textField2_EndEditing(_ sender: UITextField) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.coordinate2
        mapView.addAnnotation(annotation)
        
    }
    
    @IBAction func textField1_StartEditing(_ sender: UITextField) {
        
        if let annotation = mapView.annotations.first {
            mapView.removeAnnotation(annotation)
            
            viewRegion = MKCoordinateRegion(center: coordinate1, latitudinalMeters: 700, longitudinalMeters: 700)
            mapView.region = viewRegion
            mapView.centerCoordinate = viewRegion.center
            
        }
        
    }
    
    @IBAction func textField2_StartEditing(_ sender: UITextField) {
        
        if let annotation = mapView.annotations.first {
            if mapView.annotations.count > 1 {
                mapView.removeAnnotation(annotation)
            }
        }
        
        viewRegion = MKCoordinateRegion(center: coordinate2, latitudinalMeters: 700, longitudinalMeters: 700)
        mapView.region = viewRegion
        mapView.centerCoordinate = viewRegion.center
        
        
    }
    
    
    @IBAction func getDirection(_ sender: UIButton) {
       textFieldLocation1.endEditing(true)
        textFieldLocation2.endEditing(true)
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = self.coordinate1
        mapView.addAnnotation(annotation1)
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = self.coordinate2
        mapView.addAnnotation(annotation2)
        
        
        
        dismiss(animated: true, completion: nil)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.coordinate1))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.coordinate2))
       
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
                    guard let res = response else{return}
                    for route in res.routes {
                        self.mapView.removeOverlays(self.mapView.overlays)
                        self.mapView.addOverlay(route.polyline)
                    }
        }
        
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    @IBAction func searchLocationButton1(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        let vc = storyboard?.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        vc.forLocationNo = 1
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func searchLocationButton2(_ sender: UIButton) {
    
        dismiss(animated: true, completion: nil)
        
    let vc = storyboard?.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
    vc.forLocationNo = 2
    navigationController?.pushViewController(vc, animated: true)
        
    }
    

}


extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)) { (placemarks, error) in
            if let placemark = placemarks?.last {

                var adressString : String = ""
                if placemark.subThoroughfare != nil {
                    adressString = adressString + placemark.subThoroughfare! + ", "
                }
                
                if placemark.thoroughfare != nil {
                    adressString = adressString + placemark.thoroughfare! + ", "
                }
                
                if placemark.subLocality != nil {
                    adressString = adressString + placemark.subLocality! + ", "
                }

                if self.textFieldLocation1.isEditing{
                    self.coordinate1 = CLLocationCoordinate2D(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
                    self.textFieldLocation1.text = adressString
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = self.coordinate1
                    
                }
                
                if self.textFieldLocation2.isEditing{
                    self.coordinate2 = CLLocationCoordinate2D(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
                    self.textFieldLocation2.text = adressString
                    
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
        return renderer
        
    }
    
}

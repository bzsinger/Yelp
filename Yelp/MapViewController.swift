//
//  MapViewController.swift
//  Yelp
//
//  Created by Benny Singer on 2/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var businesses: [Business]!
    var currentLocation: CLLocation?

    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailViewLabel: UILabel!
    
    var thumbnailImageByAnnotation = [NSValue : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailView.isHidden = true
        
        mapView.delegate = self
        let mapCenter = currentLocation
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        let region = MKCoordinateRegion(center: mapCenter!.coordinate, span: mapSpan)
        mapView.setRegion(region, animated: false)
        
        addPins()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPins() {
        for i in 0..<businesses.count {
            let annotation = MKPointAnnotation()
            let locationCoordinate = businesses[i].coorLocation
            annotation.coordinate = locationCoordinate!
            annotation.title = businesses[i].name!
            
            let resizeRenderImageView = UIImageView(frame: CGRect(x:0, y:0, width:45, height:45))
            resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
            resizeRenderImageView.layer.borderWidth = 3.0
            resizeRenderImageView.contentMode = UIViewContentMode.scaleAspectFill
            
            //needed to get all images for annotations
            let url = businesses[i].imageURL
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            resizeRenderImageView.image = UIImage(data: data!)
            
            UIGraphicsBeginImageContextWithOptions(resizeRenderImageView.frame.size, false, 0.0)
            resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)] = thumbnail
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func getOurThumbnailForAnnotation(annotation : MKAnnotation) -> UIImage?{
        return thumbnailImageByAnnotation[NSValue(nonretainedObject: annotation)]
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            /// show the callout "bubble" when annotation view is selected
            annotationView?.canShowCallout = true
        }
        
        /// Set the "pin" image of the annotation view
        annotationView?.image = getOurThumbnailForAnnotation(annotation: annotation)
        
        /// Add an info button to the callout "bubble" of the annotation view
        let rightCalloutButton = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = rightCalloutButton
        
        /// Add image to the callout "bubble" of the annotation view
        let image = getOurThumbnailForAnnotation(annotation: annotation)
        let leftCalloutImageView = UIImageView(image: image)
        annotationView?.leftCalloutAccessoryView = leftCalloutImageView
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let placeName = view.annotation?.title!!
        let destinationCoors = (view.annotation?.coordinate)!
        
        detailView.isHidden = false
        detailViewLabel.text = placeName
        
        let destPlacemark = MKPlacemark(coordinate: destinationCoors, addressDictionary: nil)
        let destination = MKMapItem(placemark: destPlacemark)
        destination.name = placeName
        
        let destinationLocation = CLLocation(latitude: destinationCoors.latitude, longitude: destinationCoors.longitude)
        let launchOptions: [String : Any]!
        if (mapView.userLocation.location?.distance(from: destinationLocation))! < CLLocationDistance(1610.0) {
            launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking]
        } else {
            launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        }
        
        destination.openInMaps(launchOptions: launchOptions)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

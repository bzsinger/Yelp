//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Benny Singer on 2/19/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailBusinessLabel: UILabel!
    @IBOutlet weak var detailRatingsImageView: UIImageView!
    @IBOutlet weak var detailAddressLabel: UILabel!
    @IBOutlet weak var detailCategoriesLabel: UILabel!
    @IBOutlet weak var detailDistanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailRatingsButton: UIButton!
    
    var business: Business!
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailBusinessLabel.text = business.name!
        
        let smallImageURL = business.imageURL!.absoluteString
        let endIndex = smallImageURL.index(smallImageURL.endIndex, offsetBy: -7)
        let range = smallImageURL.startIndex..<endIndex
        let fullSizeURL = "\(smallImageURL.substring(with: range))/o.jpg"
        
        
        detailImageView.setImageWith(URL(string: fullSizeURL)!)
        detailAddressLabel.text = business.address!
        detailDistanceLabel.text = business.distance!
        detailRatingsButton.setTitle("\(business.reviewCount!) Reviews", for: .normal)
        detailRatingsImageView.setImageWith(business.ratingImageURL!)
        detailCategoriesLabel.text = business.categories!
        
        mapView.delegate = self
        let mapCenter = business.coorLocation
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        let region = MKCoordinateRegion(center: mapCenter!, span: mapSpan)
        mapView.setRegion(region, animated: false)
        
        let annotation = BusinessAnnotation()
        annotation.business = business
        let locationCoordinate = business.coorLocation
        annotation.coordinate = locationCoordinate!
        annotation.title = business.name!
        mapView.addAnnotation(annotation)
        mapView.layer.cornerRadius = 8.0
        mapView.selectAnnotation(mapView.annotations[0], animated: true)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getDirectionsButtonClicked(_ sender: Any) {
        let placeName = business.name
        let destinationCoors = business.coorLocation!
        
        let destPlacemark = MKPlacemark(coordinate: destinationCoors, addressDictionary: nil)
        let destination = MKMapItem(placemark: destPlacemark)
        destination.name = placeName
        
        let destinationLocation = CLLocation(latitude: destinationCoors.latitude, longitude: destinationCoors.longitude)
        let launchOptions: [String : Any]!
        if (currentLocation?.distance(from: destinationLocation))! < CLLocationDistance(1610.0) {
            launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking]
        } else {
            launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        }
        
        destination.openInMaps(launchOptions: launchOptions)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func detailRatingsButtonClicked(_ sender: Any) {
        UIApplication.shared.openURL(business.mobileURL!)
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

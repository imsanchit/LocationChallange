//
//  AnnotationMapVIew.swift
//  LocationChallange
//
//  Created by Sanchit Mittal on 17/10/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import Foundation
import MapKit
class AnnotationMapVIew: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }
}

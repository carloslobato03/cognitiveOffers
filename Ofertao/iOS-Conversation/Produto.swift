//
//  Loja.swift
//  Ofertao
//
//  Created by Rafael Moris on 25/07/17.
//  Copyright © 2017 Marco Aurélio Bigélli Cardoso. All rights reserved.
//

import Foundation
import MapKit

class Produto:NSObject, MKAnnotation {
    var title: String?
    let locationName: String
    let discipline: String
    var coordinate: CLLocationCoordinate2D
    var image:UIImage?
    let price: String?
    
    var subtitle: String? {
        return locationName
    }
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, price:String) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.price = price
        
        super.init()
    }
}

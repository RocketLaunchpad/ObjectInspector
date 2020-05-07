//
//  SampleData.swift
//  ObjectInspectorExample
//
//  Copyright (c) 2020 Rocket Insights, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import Contacts
import CoreLocation
import Foundation

class Place {

    let image: LabeledImage

    let name: String

    let coordinate: CLLocationCoordinate2D

    let address: [AnyHashable: String]

    init(image: LabeledImage, name: String, coordinate: CLLocationCoordinate2D, street: String, city: String, state: String, zip: String) {
        self.image = image
        self.name = name
        self.coordinate = coordinate

        address = [
            CNPostalAddressStreetKey: street,
            CNPostalAddressCityKey: city,
            CNPostalAddressStateKey: state,
            CNPostalAddressPostalCodeKey: zip
        ]
    }
}

let sampleData = [
    Place(image: LabeledImage(name: "Rocket Logo", image: UIImage(named: "rocket_logo")!),
          name: "Rocket Insights Newburyport",
          coordinate: CLLocationCoordinate2D(latitude: 42.811052, longitude: -70.870500),
          street: "20 Inn St.",
          city: "Newburyport",
          state: "MA",
          zip: "01950"),
    Place(image: LabeledImage(name: "Rocket Logo", image: UIImage(named: "rocket_logo")!),
          name: "Rocket Insights Boston",
          coordinate: CLLocationCoordinate2D(latitude: 42.353844, longitude: -71.058582),
          street: "87 Summer St.",
          city: "Boston",
          state: "MA",
          zip: "02110"),
    Place(image: LabeledImage(name: "Rocket Logo", image: UIImage(named: "rocket_logo")!),
          name: "Rocket Insights NYC",
          coordinate: CLLocationCoordinate2D(latitude: 40.700900, longitude: -73.987479),
          street: "81 Prospect St.",
          city: "Brooklyn",
          state: "NY",
          zip: "11201"),
    Place(image: LabeledImage(name: "Rocket Logo", image: UIImage(named: "rocket_logo")!),
          name: "Rocket Insights California",
          coordinate: CLLocationCoordinate2D(latitude: 37.337211, longitude: -121.889276),
          street: "75 E Santa Clara St.",
          city: "San Jose",
          state: "CA",
          zip: "95113"),
]

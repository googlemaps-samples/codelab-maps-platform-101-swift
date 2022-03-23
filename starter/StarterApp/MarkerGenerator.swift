// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import GoogleMaps
import UIKit

struct MarkerGenerator {
  var markerArray: [GMSMarker] = [GMSMarker]()

  init(near location:CLLocationCoordinate2D, count:Int) {
    for _ in 1...count {
      let extent:Double = 0.1
      let lat:Double = location.latitude + extent * Double.random(in: -1.0...1.0)
      let lng:Double = location.longitude + extent * Double.random(in: -1.0...1.0)
      let randomLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
      let marker:GMSMarker = GMSMarker(position: randomLocation)
      marker.icon = UIImage(named: "custom_pin.png")
      self.markerArray.append(marker)
    }
  }

}


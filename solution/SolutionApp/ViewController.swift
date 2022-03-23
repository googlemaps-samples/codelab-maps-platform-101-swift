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

import UIKit
import GoogleMaps
import GoogleMapsUtils

class ViewController: UIViewController, GMSMapViewDelegate {

  private var mapView: GMSMapView!
  private var clusterManager: GMUClusterManager!
  private var circle: GMSCircle? = nil

  override func loadView() {

    // Load the map at set latitude/longitude and zoom level
    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 11)
    let mapID = GMSMapID(identifier: "YOUR_MAP_ID")

    mapView = GMSMapView(frame: .zero, mapID: mapID, camera: camera)
    self.view = mapView
    mapView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Add a single marker with a custom icon
    let mapCenter = CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude)
    let marker = GMSMarker(position: mapCenter)

    marker.icon = UIImage(named: "custom_pin.png")
    marker.map = mapView

    // Generate many markers
    let markerArray = MarkerGenerator(near: mapCenter, count: 100).markerArray
    // Comment the following code out if using the marker clusterer
    // to manage markers instead.
    //    for marker in markerArray {
    //      marker.map = mapView
    //    }

    // Set up the cluster manager with a supplied icon generator and renderer.
    let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
    let iconGenerator = GMUDefaultClusterIconGenerator()
    let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
    clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)

    clusterManager.setMapDelegate(self)
    clusterManager.add(markerArray)
    clusterManager.cluster()
  }

  // MARK: GMSMapViewDelegate

  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

    // Clear previous circles
    circle?.map = nil

    // Animate to the marker
    mapView.animate(toLocation: marker.position)

    // If the tap was on a marker cluster, zoom in on the cluster
    if let _ = marker.userData as? GMUCluster {
      mapView.animate(toZoom: mapView.camera.zoom + 1)
      return true
    }

    // Draw a new circle around the tapped marker
    circle = GMSCircle(position: marker.position, radius: 800)
    circle?.fillColor = UIColor(red: 0.67, green: 0.67, blue: 0.67, alpha: 0.5)
    circle?.map = mapView
    return false
  }

}


import SwiftUI
import MapKit

struct UberMapRepresentable: UIViewRepresentable {
    let mapView = MKMapView()
    //let locationManager = LocationManager.shared
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @Binding var mapState: MapViewState
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        Log("Debug: Map state is \(mapState)")
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = locationViewModel.selectedLocation?.coordinate {
                Log("Debug: selected destination coordinate in the map view = \(coordinate)")
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
            break
        case.polylineAdded:
            break
        }
        
//        if let coordinate = locationViewModel.selectedLocationCoordinate {
//            Log("Debug: selected destination coordinate in the map view = \(coordinate)")
//            context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
//            context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
//        }
//        if mapState == .noInput {
//            context.coordinator.clearMapViewAndRecenterOnUserLocation()
//        }
    }
    
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}



extension UberMapRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        //MARK: - properties
        let parent: UberMapRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var isRegionSetByUser = false
        var currentRegion: MKCoordinateRegion?
        
        // MARK: - Lifecycle
        init(parent: UberMapRepresentable) {
            self.parent = parent
            super.init()
        }
        
        // MARK: - MapViewDelegate
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            // Detect when the user manually moves or zooms the map
            isRegionSetByUser = true
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            // Only set the region if the user has not manually adjusted the map
            if !isRegionSetByUser {
                let region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: userLocation.coordinate.latitude,
                        longitude: userLocation.coordinate.longitude
                    ),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                
                self.currentRegion = region
                
                parent.mapView.setRegion(region, animated: true)
            }
        }
        
        //to draw the route overlay on the map once we get the resultant route
        func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        
        // MARK: - Helpers
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations) //to remove the previous selected distination when uer select new one
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno) //adding the selected destination point in the map
            parent.mapView.selectAnnotation(anno, animated: true)
            
            //automatically zoom out or zoom in to fit both current and destination location in the view
           // parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
            
            
        }
        
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D){
            guard let userLocationCoordinate =  self.userLocationCoordinate else{return}
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate){ route in
                //adding the route overlay on mapview
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                //map will fit itself when the RideRequestpopup view will be active
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect ,
                                                               edgePadding: .init(top:64 ,left: 32 , bottom: 500 , right: 32 ))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        
        
        func clearMapViewAndRecenterOnUserLocation(){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion{
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
    }
}













//import SwiftUI
//import MapKit
//
//struct UberMapRepresentable: UIViewRepresentable{
//    let mapView = MKMapView()
//    let locationManager = LocationManager()
//    @EnvironmentObject var locationViewModel : LocationSearchViewModel
//    
//    func makeUIView(context: Context) -> some UIView {
//        mapView.delegate = context.coordinator
//        mapView.isRotateEnabled = false
//        mapView.showsUserLocation =  true
//        mapView.userTrackingMode = .follow
//        
//        return mapView
//    }
//    
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        //updating part
//        if let coordinate = locationViewModel.selectedLocationCoordinate {
//            Log("Debug: selected destination coordinate in the map view = \(coordinate)")
//            context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
//            
//        }
//    }
//    
//    func makeCoordinator() -> MapCoordinator {
//        return MapCoordinator(parent: self)
//    }
//    
//}
//
//
//extension UberMapRepresentable{
//    
//    class MapCoordinator: NSObject , MKMapViewDelegate {
//        let parent: UberMapRepresentable
//        
//        //MARK: - Lifecycle
//        init(parent: UberMapRepresentable) {
//            self.parent = parent
//            super.init()
//        }
//        
//        
//        //MARK: - MapViewDelegate
//        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//            let region =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude ,
//                                                    longitude: userLocation.coordinate.longitude) ,
//                                             span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) 
//            )
//            
//            parent.mapView.setRegion(region, animated: true)
//        }
//        
//        
//        // MARK: - Helpers
//        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D){
//            let anno = MKPointAnnotation()
//            anno.coordinate = coordinate
//            self.parent.mapView.addAnnotation(anno)
//            self.parent.mapView.selectAnnotation(anno , animated: true)
//        }
//        
//    }
//    
//    
//}

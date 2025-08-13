import Foundation
import MapKit

class LocationSearchViewModel: NSObject , ObservableObject , Observable{
    // MARK: - Properties
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocation : UberLocation?  //it will store the destination location
    @Published var pickUpTime: String?
    @Published var dropOffTime: String?
    
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    var queryFragment: String = "" {
        didSet{
            //Log("Debug: Query Fragment is \(queryFragment)")
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D? //to configure the price b/w source n dest.
    
    
    //MARK: - Lifecycle
    override init(){
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    //MARK: - Helpers
    func selectLocation(_ localSearch: MKLocalSearchCompletion){
        //here we will take location string i.e., location.title and location.subtitle and we will generate coordinate
        locationSearch(forLocationSearchCompletion: localSearch){ response , error in
            if let error = error {
                Log("Debug: Location search failed with error \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first else {return}
            let coordinate = item.placemark.coordinate
            self.selectedLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
            Log("Debug: Location Coordinates in locationSearchViewModel = \(coordinate)")
        }
    }
    
    //callback function
    func locationSearch(forLocationSearchCompletion localSearch: MKLocalSearchCompletion ,
                        completion: @escaping MKLocalSearch.CompletionHandler){
        let searchRequest =  MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: RideType)->Double{
        guard let coordinate = selectedLocation?.coordinate else {return 0.0}
        guard let userLocation = self.userLocation else {return 0.0}
        
        //compute distance b/w source and dest.
        let source = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let tripDistanceInMeter = source.distance(from: destination)
        return type.computePrice(for: tripDistanceInMeter)
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D , to destination: CLLocationCoordinate2D, completion: @escaping(MKRoute)-> Void){
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        let directions = MKDirections(request: request)
        
        //this direction req. is an api
        directions.calculate{ response , error in
            if let error = error {
                Log("Debug: Failed to get direction , error= \(error.localizedDescription)")
                return
            }
            
            //we will get the array of routes . here we are selecting first route because it is the shortest one
            guard let route = response?.routes.first else {return}
            self.configurePickupAndDropOffTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configurePickupAndDropOffTimes(with expectedTravelTime: Double){
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickUpTime = formatter.string(from: Date()) //current time at source end
        dropOffTime = formatter.string(from: Date() + expectedTravelTime )//time to react at destination 
    }
    
}


//MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}

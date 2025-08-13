import Foundation

enum RideType: Int, CaseIterable, Identifiable {
    case bike
    case auto
    case uberX
    case uberXL
    case black
    
    var id: Int {return rawValue}
    
    var description: String {
        switch self{
        case.uberX: return "UberX"
        case.black: return "UberBlack"
        case.uberXL: return "UberXL"
        case.bike: return "Bike"
        case.auto: return "Auto"
        }
    }
    
    
    var imageName: String{
        switch self{
        case.uberX: return "white-car2"
        case.black: return "car-black"
        case.uberXL: return "car-white"
        case.bike: return "bike"
        case.auto: return "auto"
        }
    }
    
    
    var baseFare: Double {
        switch self{
        case.uberX: return 25
        case.black: return 40
        case.uberXL: return 30
        case.bike: return 15
        case.auto: return 20
        }
    }
    
    
    func computePrice(for distanceInMeters: Double)->Double{
        let distanceInMiles=distanceInMeters/1000
        
        switch self{
        case.uberX: return distanceInMiles*12 + baseFare
        case.black: return distanceInMiles*16 + baseFare
        case.uberXL: return distanceInMiles*14 + baseFare
        case.bike: return distanceInMiles*6 + baseFare
        case.auto: return distanceInMiles*9 + baseFare
        }
    }
    
}



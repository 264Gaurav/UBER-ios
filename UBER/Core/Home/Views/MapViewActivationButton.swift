import SwiftUI

struct MapViewActivationButton: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        Button{
            withAnimation(.spring()){
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity , alignment: .leading)
    }
    
    
    func actionForState(_ state : MapViewState){
        switch state {
        case .noInput:
            Log("Debug: no input ")
        
        case .searchingForLocation:
            mapState = .noInput
            
        case .locationSelected , .polylineAdded :
            Log("Debug: clear map view ")
            mapState = .noInput
            viewModel.selectedLocation = nil //before choosing another location make sure to erase the previous stored destination location
        }
    }
    
    func imageNameForState(_ state : MapViewState)->String{
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation , .locationSelected , .polylineAdded:
            return "arrow.left"
        }
    }
    
}



#Preview {
    MapViewActivationButton(mapState: .constant(.noInput))
}

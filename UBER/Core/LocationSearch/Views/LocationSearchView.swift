import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel : LocationSearchViewModel
    
    
    var body: some View {
        VStack{
            //header view
            HStack{
                VStack{
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6 , height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1 , height: 24)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6 , height: 6)
                }
                
                VStack{
                    TextField("Current Location" , text: $startLocationText)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    
                    TextField("Where to?" , text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
                
            }
            .padding(.horizontal)
            .padding(.top , 64)
            
            Divider()
                .padding(.vertical)
            
            
            //List view
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.results, id: \.self) { result in
                        LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                            .padding(.horizontal)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    viewModel.selectLocation(result)
                                    mapState = .locationSelected
                                }
                            }
                    }
                }
            }
        }
        .background(Color.appTheme.backgroundColor)
       // .background(Color.white)
        
    }
}



#Preview {
    LocationSearchView(mapState: .constant(.searchingForLocation))
}

import SwiftUI

struct RideRequestView: View {
    @State private var selectedRideType: RideType = .bike
    @EnvironmentObject var viewModel : LocationSearchViewModel
    
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48 , height: 6)
                .padding(.top,8)
            //trip info view
            HStack{
                //indicator view
                VStack{
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8 , height: 8)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1 , height: 32)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 8 , height: 8)
                }
                
                VStack(alignment: .leading , spacing: 24){
                    HStack{
                        Text("Current Location")
                            .font(.system(size: 16 , weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("\(String(describing: viewModel.pickUpTime ?? "" ))")
                            .font(.system(size: 14 , weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom,10)
                    
                    HStack{
                        if let location = viewModel.selectedLocation {
                            Text("\(String(describing: viewModel.selectedLocation?.title) )")
                                .font(.system(size: 16 , weight: .semibold))
                        }
                        
                        Spacer()
                        
                        Text("\(String(describing: viewModel.dropOffTime ?? "" ))")
                            .font(.system(size: 14 , weight: .semibold))
                    }
                }
                .padding(.leading)
            }.padding()
            
            Divider()
            
            //ride type selection view
            Text("SUGGESTED RIDES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity , alignment: .leading)
            
            
            ScrollView(.horizontal){
                HStack(spacing:12){
                    ForEach(RideType.allCases){ type in
                        VStack(alignment: .leading){
                            Image(type.imageName)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(6)
                                .padding(.all,2)
                            
                            VStack(alignment: .leading){
                                Text(type.description)
                                    .font(.system(size: 14 , weight: .semibold))
                                
                                Text("\(viewModel.computeRidePrice(forType: type).toCurrency())")
                                    .font(.system(size: 14 , weight: .semibold))
                            }
                            .padding(8)
                            
                        }
                        .frame(width: type == selectedRideType ? 120 : 112 , height: type == selectedRideType ? 150 : 140)
                        .foregroundColor(type == selectedRideType ? .white : Color.appTheme.primaryTextColor)
                        .background(type == selectedRideType ? .blue : Color.appTheme.secondaryBackgroundColor )
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()){
                                selectedRideType = type
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical,8)

            //payment option view
            HStack(spacing: 12){
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(4)
                    .padding(.leading)
                
                Text("****** 1234")
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
            }
            .frame(height: 50)
            .background(Color(.systemGroupedBackground))
            .cornerRadius(10)
            .padding()
            
            
            //request ride button
            Button{
                
            }label: {
                Text("CONFIRM RIDE")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32 , height: 50)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
        }
        .padding(.bottom,24)
        .cornerRadius(16)
        .background(Color.appTheme.backgroundColor)
        
        
    }
}


#Preview {
    RideRequestView()
}

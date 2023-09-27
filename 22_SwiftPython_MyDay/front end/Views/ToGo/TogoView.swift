import SwiftUI
import MapKit

struct TogoView: View {
    @State var coordiante = MKCoordinateRegion(center: .init(latitude: 24.827078, longitude: 102.853233), latitudinalMeters: 500, longitudinalMeters: 500)
    
    var body: some View {
        VStack{
            Map(coordinateRegion: $coordiante)
            List{
                DisclosureGroup {
                    ForEach(0..<5) { i in
                        NavigationLink(destination: Text("test")) {
                            VStack {
                                Label("Test", systemImage: "7.circle")
                                Text("Building")
                            }
                            
                        }
                    }
                } label: {
                    Text("Test")
                }
            }
        }
        
    }
}

struct TogoView_Previews: PreviewProvider {
    static var previews: some View {
        TogoView()
    }
}

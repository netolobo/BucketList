//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Neto Lobo on 30/11/23.
//

import Foundation


@Observable
class EditViewModel {
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    var location: Location
    var onSave: (Location) -> Void
    
    var name: String
    var description: String
    
    var loadingState = LoadingState.loading
    var pages = [Page]()
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        self.name = location.name
        self.description = location.description
    }
    
    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        do {
            let(data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
        
    }
    
    func saveNewPlace() {
        var newLocation = location
        newLocation.id = UUID()
        newLocation.name = name
        newLocation.description = description
        
        onSave(newLocation)
    }
}


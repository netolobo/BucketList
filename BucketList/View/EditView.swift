//
//  EditView.swift
//  BucketList
//
//  Created by Neto Lobo on 28/11/23.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel : EditViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    viewModel.saveNewPlace()
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
}

#Preview {
    EditView(viewModel: EditViewModel(location: Location.example, onSave: { _ in }))
}

//
//  ContentView.swift
//  BucketList
//
//  Created by Neto Lobo on 26/11/23.
//

import SwiftUI

struct ContentView: View {
    
    struct User: Identifiable, Comparable {
        let id = UUID()
        let firstName: String
        let lastName: String
        
        static func < (lhs: User, rhs: User) -> Bool {
            lhs.lastName < rhs.lastName
        }
    }
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .onTapGesture {
                    let str = "Text Message"
                    let url = getDocumentsDirectory().appending(path:"message.txt")
                    
                    do {
                        try str.write(to: url, atomically: true, encoding: .utf8)
                        
                        let input = try String(contentsOf: url)
                        print(input)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        }
        .padding()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    

}

#Preview {
    ContentView()
}

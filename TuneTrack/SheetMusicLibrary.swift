//
//  SheetMusicLibrary.swift
//  TuneTrack
//
//  Created by Shi, Simba (Coll) on 03/10/2024.
//

import SwiftUI

struct SheetMusic: Identifiable {
    var id = UUID()
    var title: String
    var composer: String
    var category: String
}

struct SheetMusicLibraryView: View {
    @State private var sheetMusicList: [SheetMusic] = [
        SheetMusic(title: "Ballade No. 4 in F minor, Op. 52", composer: "Frédéric Chopin", category: "Romantic"),
        SheetMusic(title: "Mephisto Waltz No. 1, S. 514", composer: "Franz Liszt", category: "Romantic"),
        SheetMusic(title: "Misty", composer: "Ella Fitzgerald", category: "Jazz"),
        SheetMusic(title: "The Girl From Ipanema", composer: "Stan Getz", category: "Jazz"),
        SheetMusic(title: "Blue Moon", composer: "Billie Holiday", category: "Jazz"),
        SheetMusic(title: "Goldberg Variations", composer: "J. S. Bach", category: "Baroque"),
        SheetMusic(title: "Sonata No. 24 (Hammerklavier)", composer: "Ludwig van Beethoven", category: "Classical"),
        SheetMusic(title: "Abegg Variations, Op.1", composer: "Robert Schumann", category: "Romantic")
    ]

    @State private var searchQuery = ""
    @State private var selectedCategory = "All"

    let categories = ["All", "Classical", "Romantic", "Jazz", "Baroque"]

    var filteredMusic: [SheetMusic] {
        var results = sheetMusicList

        if selectedCategory != "All" {
            results = results.filter { $0.category == selectedCategory }
        }

        if !searchQuery.isEmpty {
            results = results.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) || $0.composer.localizedCaseInsensitiveContains(searchQuery) ||
                $0.category.localizedCaseInsensitiveContains(searchQuery)}
        }

        return results
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search by title or composer", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List(filteredMusic) { piece in
                    VStack(alignment: .leading) {
                        Text(piece.title)
                            .font(.headline)
                        Text("Composer: \(piece.composer)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
                
                if filteredMusic.isEmpty {
                    Text("No results found.")
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Sheet Music Library")
        }
    }
}

struct SheetMusicLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        SheetMusicLibraryView()
    }
}

//
//  SheetMusicLibrary.swift
//  TuneTrack
//
//  Created by Shi, Simba (Coll) on 03/10/2024.
//

import SwiftUI
import PDFKit

struct SheetMusic: Identifiable {
    var id = UUID()
    var title: String
    var composer: String
    var category: String
    var sheetMusicFile: String  // Reference to the sheet music PDF file
}

struct SheetMusicLibraryView: View {
    @State private var sheetMusicList: [SheetMusic] = [
        SheetMusic(title: "Ballade No. 4 in F minor, Op. 52", composer: "Frédéric Chopin", category: "Romantic", sheetMusicFile: "ballade_no_4"),
        SheetMusic(title: "Mephisto Waltz No. 1, S. 514", composer: "Franz Liszt", category: "Romantic", sheetMusicFile: "mephisto_waltz"),
        SheetMusic(title: "Misty", composer: "Ella Fitzgerald", category: "Jazz", sheetMusicFile: "misty"),
        SheetMusic(title: "The Girl From Ipanema", composer: "Stan Getz", category: "Jazz", sheetMusicFile: "ipanema"),
        SheetMusic(title: "Blue Moon", composer: "Billie Holiday", category: "Jazz", sheetMusicFile: "blue_moon"),
        SheetMusic(title: "Goldberg Variations", composer: "J. S. Bach", category: "Baroque", sheetMusicFile: "goldberg_variations"),
        SheetMusic(title: "Sonata No. 24 (Hammerklavier)", composer: "Ludwig van Beethoven", category: "Classical", sheetMusicFile: "hammerklavier"),
        SheetMusic(title: "Abegg Variations, Op.1", composer: "Robert Schumann", category: "Romantic", sheetMusicFile: "abegg_variations")
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
            results = results.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) || $0.composer.localizedCaseInsensitiveContains(searchQuery) }
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
                    NavigationLink(destination: SheetMusicDetailView(sheetMusic: piece)) {
                        VStack(alignment: .leading) {
                            Text(piece.title)
                                .font(.headline)
                            Text("Composer: \(piece.composer)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
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

// Detail view to display specific sheet music as a PDF
struct SheetMusicDetailView: View {
    var sheetMusic: SheetMusic

    var body: some View {
        VStack {
            Text(sheetMusic.title)
                .font(.title)
                .padding(.bottom, 10)
            Text("Composer: \(sheetMusic.composer)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            PDFKitRepresentedView(pdfFileName: sheetMusic.sheetMusicFile)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Sheet Music")
    }
}

// UIViewRepresentable to display PDF in SwiftUI
struct PDFKitRepresentedView: UIViewRepresentable {
    var pdfFileName: String

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true

        if let url = Bundle.main.url(forResource: pdfFileName, withExtension: "pdf") {
            pdfView.document = PDFDocument(url: url)
        } else {
            print("PDF file \(pdfFileName).pdf not found")
        }

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct SheetMusicLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        SheetMusicLibraryView()
    }
}

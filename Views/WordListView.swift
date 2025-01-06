import SwiftUI

struct WordListView: View {
    @State private var currentWord: WordOfTheDay?
    @State private var previousWords: [WordOfTheDay] = []
    
    var body: some View {
        NavigationView {
            List {
                if let word = currentWord {
                    Section(header: Text("Today's Word")) {
                        WordCardView(word: word)
                    }
                }
                
                Section(header: Text("Previous Words")) {
                    ForEach(previousWords, id: \.date) { word in
                        WordCardView(word: word)
                    }
                }
            }
            .navigationTitle("French Word of the Day")
            .onAppear {
                loadData()
            }
        }
    }
    
    private func loadData() {
        WordDataManager.shared.loadWords()
        currentWord = WordDataManager.shared.getWordForDate(Date())
        previousWords = WordDataManager.shared.getPreviousWords()
    }
}

struct WordCardView: View {
    let word: WordOfTheDay
    @State private var showDefinition = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(word.french)
                .font(.title2)
                .bold()
            
            Text(word.english)
                .font(.headline)
                .foregroundColor(.secondary)
            
            if showDefinition {
                Text(word.definition)
                    .font(.body)
                    .padding(.top, 4)
            }
            
            Button(action: {
                showDefinition.toggle()
            }) {
                Text(showDefinition ? "Hide Definition" : "Show Definition")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
    }
} 
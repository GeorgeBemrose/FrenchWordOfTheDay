import Foundation

class WordDataManager {
    static let shared = WordDataManager()
    
    private var words: [WordOfTheDay] = []
    
    func loadWords() {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let wordsData = try decoder.decode(WordsResponse.self, from: data)
            self.words = wordsData.words
        } catch {
            print("Error decoding words: \(error)")
        }
    }
    
    func getWordForDate(_ date: Date) -> WordOfTheDay? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        return words.first { $0.date == dateString }
    }
    
    func getPreviousWords() -> [WordOfTheDay] {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        
        return words.filter { $0.date < todayString }
    }
}

struct WordsResponse: Codable {
    let words: [WordOfTheDay]
} 
struct WordOfTheDay: Codable {
    let french: String
    let english: String
    let definition: String
    let options: [String] // Will contain the correct answer + 2 wrong options
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case french, english, definition, options, date
    }
} 
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WordEntry {
        WordEntry(date: Date(), word: WordOfTheDay(
            french: "bonjour",
            english: "hello",
            definition: "A greeting",
            options: ["hello", "goodbye", "thanks"],
            date: "2024-03-20"
        ))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WordEntry) -> ()) {
        let entry = WordEntry(date: Date(), word: WordDataManager.shared.getWordForDate(Date()) ?? placeholder(in: context).word)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WordEntry>) -> ()) {
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        
        let word = WordDataManager.shared.getWordForDate(currentDate) ?? placeholder(in: context).word
        let entry = WordEntry(date: currentDate, word: word)
        
        let timeline = Timeline(entries: [entry], policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct WordEntry: TimelineEntry {
    let date: Date
    let word: WordOfTheDay
}

struct FrenchWordWidgetEntryView : View {
    var entry: Provider.Entry
    @State private var selectedOption: String?
    
    var body: some View {
        VStack(spacing: 10) {
            Text(entry.word.french)
                .font(.system(size: 24, weight: .bold))
                .minimumScaleFactor(0.5)
                .padding(.top, 8)
            
            if let selected = selectedOption {
                if selected == entry.word.english {
                    Text(entry.word.definition)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                } else {
                    Text("Try again!")
                        .foregroundColor(.red)
                }
            } else {
                ForEach(entry.word.options, id: \.self) { option in
                    Button(action: {
                        selectedOption = option
                    }) {
                        Text(option)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
    }
}

@main
struct FrenchWordWidget: Widget {
    let kind: String = "FrenchWordWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FrenchWordWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("French Word of the Day")
        .description("Learn a new French word every day!")
        .supportedFamilies([.systemMedium])
    }
} 
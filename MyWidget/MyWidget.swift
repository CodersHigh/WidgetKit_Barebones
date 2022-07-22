//
//  MyWidget.swift
//  MyWidget
//
//  Created by 이로운 on 2022/07/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    let userDefaults = UserDefaults(suiteName: "group.WidgetKit_practice")
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), text: "", textColor: Color.black, backgroundColor: .white, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), text: "", textColor: Color.black, backgroundColor: Color.white, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let text = userDefaults?.value(forKey: "text") as? String ?? "I'm your widget!"
        let textColor = userDefaults?.getColor(forKey: "textColor") ?? Color.black
        let backgroundColor = userDefaults?.getColor(forKey: "backgroundColor") ?? Color.white

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, text: text, textColor: textColor, backgroundColor: backgroundColor, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    let textColor: Color
    let backgroundColor: Color
    let configuration: ConfigurationIntent
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.text)
            .font(Font.system(size: 24, weight: .semibold, design: .default))
            .foregroundColor(entry.textColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

@main
struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(entry.backgroundColor)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

extension UserDefaults {
    func getColor(forKey key: String) -> Color? {
        guard let components = self.object(forKey: key) as? [CGFloat] else { return nil }
        let color = Color(.sRGB, red: components[0], green: components[1], blue: components[2], opacity: components[3])
        return color
    }
}

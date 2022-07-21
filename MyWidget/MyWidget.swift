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
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "", textColor: Color.black, backgroundColor: .white, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), text: "", textColor: Color.black, backgroundColor: Color.white, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.WidgetKit_Barebones")
        let text = userDefaults?.value(forKey: "text") as? String ?? "I'm your widget!"
        guard let textColorComponents = userDefaults?.object(forKey: "textColor") as? [CGFloat] else { return }
        let textColor = Color(.sRGB, red: textColorComponents[0], green: textColorComponents[1], blue: textColorComponents[2], opacity: textColorComponents[3])
        guard let backgroundColorComponents = userDefaults?.object(forKey: "backgroundColor") as? [CGFloat] else { return }
        let backgroundColor = Color(.sRGB, red: backgroundColorComponents[0], green: backgroundColorComponents[1], blue: backgroundColorComponents[2], opacity: backgroundColorComponents[3])

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

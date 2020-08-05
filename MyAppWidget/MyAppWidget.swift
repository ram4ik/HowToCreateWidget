//
//  MyAppWidget.swift
//  MyAppWidget
//
//  Created by ramil on 05.08.2020.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct MyAppWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        //Text(entry.date, style: .time)
        
        ZStack {
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Spacer()
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                    
                    Text("Featured\nPeople")
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                        .multilineTextAlignment(.trailing)
                    Spacer()
                }
            }
        }.background(Color(.systemTeal))
    }
}

@main
struct MyAppWidget: Widget {
    let kind: String = "MyAppWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MyAppWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MyAppWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyAppWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

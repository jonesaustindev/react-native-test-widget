//
//  MyWidget.swift
//  MyWidget
//
//  Created by Austin Jones on 10/2/20.
//

import WidgetKit
import SwiftUI
import Intents

struct DataPoint: Decodable {
  var foo: String
  var baz: String
  var date: String
}

struct Period: Decodable {
  let start: String
  let end: String
}


struct MyObject: Decodable {
  var dataPoints: DataPoint
  var periods: [Period]
}

struct User: Decodable {
  let name: String
  let location: String
}

struct Provider: IntentTimelineProvider {
  
  func placeholder(in context: Context) -> SimpleEntry {
    let fooDefault = UserDefaults(suiteName: "group.org.reactjs.native.example.RNWidgetTest")?.string(forKey: "MyAppKey") ?? "Default timeline"
    return SimpleEntry(date: Date(), dataPoint: DataPoint(foo: fooDefault, baz: "baz placeholder", date: "date placeholder"), start: "start placeholder", end: "end placeholder")
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let fooDefault = UserDefaults(suiteName: "group.org.reactjs.native.example.RNWidgetTest")?.string(forKey: "MyAppKey") ?? "Default timeline"
    let entry = SimpleEntry(
      date: Date(),
      dataPoint: DataPoint(foo: fooDefault, baz: "baz snapshot", date: "date snapshot"),
      start: "start snapshot",
      end: "end snapshot"
    )
    
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//    let fooDefault = UserDefaults(suiteName: "group.org.reactjs.native.example.RNWidgetTest")?.string(forKey: "MyAppKey") ?? "{\"name\": \"John\", \"location\": \"Somewhere\",}"
    let fooDefault = UserDefaults(suiteName: "group.org.reactjs.native.example.RNWidgetTest")?.string(forKey: "MyAppKey") ?? "Default timeline"
    
    var entries: [SimpleEntry] = []
    
//    do {
//      if let json = try JSONSerialization.jsonObject(with: fooDefault, options:JSONSerialization.ReadingOptions) as? [String: Any] {
//        if let name = json["name"] as? String {
//          userName = name
//        }
//        if let location = json["location"] as? String {
//          userLocation = location
//        }
//      }
//    } catch let error as NSError {
//      print("Failed to load: \(error.localizedDescription)")
//    }
//    if let data = fooDefault.data(using: String.Encoding.utf8) {
//      do {
//        if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//          // Use this dictionary
//          print(dictionary)
//
//          var userName: String
//          var userLocation: String
//
//          if let name = dictionary["name"] as? String {
//            userName = name
//          }
//          if let location = dictionary["location"] as? String {
//            userLocation = location
//          }
//
//          entries.append(SimpleEntry(date: Date(), dataPoint: DataPoint(foo: userName, baz: userLocation, date: "date timeline"), start: "start timeline", end: "end timeline"))
//        }
//      } catch _ {
//        // Do nothing
//      }
//    }
    
    let entry = SimpleEntry(date: Date(), dataPoint: DataPoint(foo: fooDefault, baz: "baz timeline", date: "date timeline"), start: "start timeline", end: "end timeline")
    
    // Create a timeline entry for "now."
    let date = Date()
//    let entry = SimpleEntry(date: Date(), dataPoint: DataPoint(foo: userName, baz: "baz snapshot", date: "date snapshot"), start: "start timeline", end: "end timeline")
    
    // Create a date that's 15 minutes in the future.
    let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: date)!
    
    // Create the timeline with the entry and a reload policy with the date
    // for the next update.
    let timeline = Timeline(
      entries:[entry],
      policy: .atEnd
//      entries: entries,
//      policy: .after(nextUpdateDate)
    )
    
    // Call the completion to pass the timeline to WidgetKit.
    completion(timeline)
  }
}

struct UserEntry: TimelineEntry {
  let date: Date
  let user: User
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let dataPoint: DataPoint
  let start: String
  let end: String
}

struct MyWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    Text(entry.dataPoint.foo)
  }
}

@main
struct MyWidget: Widget {
  let kind: String = "MyWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      MyWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct MyWidget_Previews: PreviewProvider {
  static var previews: some View {
    MyWidgetEntryView(entry: SimpleEntry(date: Date(), dataPoint: DataPoint(foo: "foo preview", baz: "baz preview", date: "date preview"), start: "start preview", end: "end preview"))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}

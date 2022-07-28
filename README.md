# WidgetKit_Barebones
<br/>

### 프로젝트 소개
- WidgetKit의 기본적인 기능 구현을 익히는 데에 도움을 주는 Bare-bones 프로젝트입니다.   
- WidgetKit을 통해 **SwiftUI 기반의 커스텀 위젯 생성 앱**을 구현합니다. 
- WidgetKit을 처음 활용해 보는 경우, 이 프로젝트의 코드를 살펴보면 도움이 됩니다.


https://user-images.githubusercontent.com/74223246/180370690-1da62faa-2704-4ec5-ae7b-8902c4890903.MP4


<br/>

### WidgetKit이란?  
<img width="400" alt="WidgetKitImage" src="https://user-images.githubusercontent.com/74223246/180370899-cfd424a4-ac32-46f5-b5d1-52afa958b802.png">

위젯은 **앱의 중요 정보를 홈 화면 또는 알림 센터에서 한 눈에 확인**할 수 있게 해줍니다.    
그리고 **WidgetKit**을 활용해 여러분의 앱을 위한 위젯을 손쉽게 구현 가능하죠. WidgetKit이 더 궁금하다면 [Apple 공식 문서](https://developer.apple.com/kr/widgets/)를 참고해 보세요.         
WidgetKit을 활용하려면 우선 **WidgetExtension**과 **앱의 데이터를 위젯에게 전송할 장치**를 마련해야 합니다. 그 과정은 [여기](https://www.notion.so/WidgetKit-eae8b9a6ab564f63807e4d81442aeb3e)에서 살펴보세요.       

<br/>
<br/>

### 핵심 코드
이 프로젝트에서 위젯 및 위젯으로의 데이터 전송을 구현한 핵심 코드를 참고하세요.

```Swift
// 앱 - UserDefaults의 값을 세팅하고, 위젯을 업데이트시킵니다. 
struct ContentView: View {

    // UserDefaults에 저장된 값 불러와서 초기 값으로 세팅
    static let userDefaults = UserDefaults(suiteName: "group.WidgetKit_practice")
    @State private var text: String = userDefaults?.string(forKey: "text") ?? "I'm your widget!"
    @State var textColor: Color = userDefaults?.getColor(forKey: "textColor") ?? Color.black
    @State var backgroundColor: Color = userDefaults?.getColor(forKey: "backgroundColor") ?? Color.white

    // 앱에서 적용 버튼을 눌렀을 때, UserDefaults 값 세팅하고 위젯 리로드하기
    Button("적용") {
        let userDefaults = UserDefaults(suiteName: "group.WidgetKit_practice")
        userDefaults?.setValue(text, forKey: "text")
        userDefaults?.set(textColor.cgColor?.components, forKey: "textColor")
        userDefaults?.set(backgroundColor.cgColor?.components, forKey: "backgroundColor")
        WidgetCenter.shared.reloadAllTimelines()
    }
}
```
```Swift
// 위젯 - 앱에서 세팅한 UserDefaults의 값을 불러와 표시합니다. 

// UserDefaults의 값을 불러와 SimpleEntry로 저장
struct Provider: IntentTimelineProvider { 
    let userDefaults = UserDefaults(suiteName: "group.WidgetKit_practice")

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let text = userDefaults?.value(forKey: "text") as? String ?? "I'm your widget!"
        let textColor = userDefaults?.getColor(forKey: "textColor") ?? Color.black
        let backgroundColor = userDefaults?.getColor(forKey: "backgroundColor") ?? Color.white

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

// 저장된 값을 표시
struct MyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.text)
            .font(Font.system(size: 24, weight: .semibold, design: .default))
            .foregroundColor(entry.textColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
```

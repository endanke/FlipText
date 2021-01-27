import SwiftUI

public struct FlipText: View {

    @Binding public var text: String
    public var font: Font
    public var transition: AnyTransition
    public var background: AnyView?

    private var textArray: [String] {
        text.map({ String($0) })
    }

    public init(
        text: Binding<String>,
        font: Font = .body,
        transition: AnyTransition = .rotate,
        background: AnyView? = nil
    ) {
        self._text = text
        self.font = font
        self.transition = transition
        self.background = background
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(textArray.indices, id: \.self) { index in
                Text(textArray[index])
                    .background(background)
                    .transition(transition)
                    .id(textArray[index])
            }
        }.font(font)
        .fixedSize()
    }

}

extension AnyTransition {

    public static let rotateScale: AnyTransition = AnyTransition.asymmetric(
        insertion: AnyTransition.modifier(
            active: RotateScaleEffect(progress: 0, insertion: true),
            identity: RotateScaleEffect(progress: 1, insertion: true)
        ),
        removal: AnyTransition.modifier(
            active: RotateScaleEffect(progress: 0, insertion: false),
            identity: RotateScaleEffect(progress: 1, insertion: false)
        )
    )
    
    public static let rotate: AnyTransition = AnyTransition.asymmetric(
        insertion: AnyTransition.modifier(
            active: RotateEffect(progress: 0, insertion: true),
            identity: RotateEffect(progress: 1, insertion: true)
        ),
        removal: AnyTransition.modifier(
            active: RotateEffect(progress: 0, insertion: false),
            identity: RotateEffect(progress: 1, insertion: false)
        )
    )

}

private struct FlipTextDemo: View {

    @State var text = "Hello"

    var body: some View {
        VStack {
            FlipText(
                text: $text,
                font: Font.custom("SFMono-Bold", size: 64.0),
                background: AnyView(Color.black)
            ).animation(.easeIn(duration: 1.0))
            .padding()
            Button("Flip") {
                withAnimation {
                    if text == "World" {
                        text = "Swift"
                    } else if text == "Swift" {
                        text = "Hello"
                    } else {
                        text = "World"
                    }
                }
            }.padding()
        }.background(Color.black)
    }

}

struct LicensesView_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            FlipTextDemo()
        }
    }

}

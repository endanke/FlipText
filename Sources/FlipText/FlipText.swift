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

// Source:
// https://stackoverflow.com/a/62767038/1960938
struct RotateEffect: GeometryEffect {

    var progress: Double
    var insertion: Bool

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let angle = CGFloat(Angle(degrees: (insertion ? 180.0 : -180) * (1.0 - progress)).radians)

        var transform3d = CATransform3DIdentity
        transform3d.m34 = -1/max(size.width, size.height)
        transform3d = CATransform3DRotate(transform3d, angle, 1, 0, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

        let affineTransform1 = ProjectionTransform(
            CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0)
        )

        let scaleLevel: CGFloat = (insertion && progress <= 0.5) ? 0.0 : CGFloat(progress * 2)
        let affineTransform2 = ProjectionTransform(
            CGAffineTransform(scaleX: scaleLevel, y: scaleLevel)
        )

        if progress <= 0.5 {
            return ProjectionTransform(transform3d).concatenating(affineTransform2).concatenating(affineTransform1)
        } else {
            return ProjectionTransform(transform3d).concatenating(affineTransform1)
        }
    }

}

private struct FlipTextDemo: View {

    @State var text = "Hello"

    var body: some View {
        VStack {
            FlipText(
                text: $text,
                font: Font.custom("SFMono-Bold", size: 64.0),
                background: AnyView(Color.gray)
            ).animation(.easeIn(duration: 1.0))
            .padding()
            Button("Test") {
                withAnimation {
                    text = text == "Hello" ? "World" : "Hello"
                }
            }.padding()
        }
    }

}

struct LicensesView_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            FlipTextDemo()
        }
    }

}

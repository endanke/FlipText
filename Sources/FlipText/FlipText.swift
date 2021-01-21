import SwiftUI

struct AnimatedText: View {

    @Binding var text: String

    private var textArray: [String] {
        text.map({ String($0) })
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0)
                .fill(Color.white)
            HStack(spacing: 0) {
                ForEach(textArray.indices, id: \.self) { index in
                    Text(textArray[index]).transition(.rotate).id(textArray[index])
                }
            }.font(Font.custom("SFMono-Bold", size: 16.0))
            .foregroundColor(.black)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }.fixedSize()
    }

}

extension AnyTransition {

    static let rotate: AnyTransition = AnyTransition.modifier(
        active: RotateEffect(progress: 0),
        identity: RotateEffect(progress: 1)
    )

}

// Source:
// https://stackoverflow.com/a/62767038/1960938
struct RotateEffect: GeometryEffect {

    var progress: Double

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let angle = CGFloat(Angle(degrees: 180.0 * (1.0 - progress)).radians)

        var transform3d = CATransform3DIdentity
        transform3d.m34 = -1/max(size.width, size.height)
        transform3d = CATransform3DRotate(transform3d, angle, 1, 0, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

        let affineTransform1 = ProjectionTransform(
            CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0)
        )
        let affineTransform2 = ProjectionTransform(
            CGAffineTransform(scaleX: CGFloat(progress * 2), y: CGFloat(progress * 2))
        )

        if progress <= 0.5 {
            return ProjectionTransform(transform3d).concatenating(affineTransform2).concatenating(affineTransform1)
        } else {
            return ProjectionTransform(transform3d).concatenating(affineTransform1)
        }
    }

}

private struct AnimatedTextDemo: View {

    @State var text = "Hello"

    var body: some View {
        VStack {
            AnimatedText(text: $text)
            Button("Test") {
                withAnimation {
                    text = text == "Hello" ? "World" : "Hello"
                }
            }
        }
    }

}

struct LicensesView_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            AnimatedTextDemo()
        }
    }

}

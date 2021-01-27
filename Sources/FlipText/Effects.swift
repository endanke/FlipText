import SwiftUI

struct RotateScaleEffect: AnimatableModifier {
    
    var progress: Double
    var insertion: Bool

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    func body(content: Content) -> some View {
        content
            .opacity((insertion && progress <= 0.8) ? 0.0 : (progress * 2))
            .rotation3DEffect(.init(degrees: progress * 180), axis: (1, 0, 0))
            .scaleEffect(CGFloat(1.0 - progress) * 0.5 + 1.0)
    }

}

// Based on:
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

        let affineTransform2 = ProjectionTransform(
            CGAffineTransform(scaleX: CGFloat(progress * 2), y: CGFloat(progress * 2))
        )

        if insertion && progress <= 0.5 {
            // Note: This hides the view with a non-zero transformation
            return ProjectionTransform(CGAffineTransform(scaleX: .leastNonzeroMagnitude, y: .leastNonzeroMagnitude))
        } else if progress <= 0.5 {
            return ProjectionTransform(transform3d).concatenating(affineTransform2).concatenating(affineTransform1)
        } else {
            return ProjectionTransform(transform3d).concatenating(affineTransform1)
        }
    }

}

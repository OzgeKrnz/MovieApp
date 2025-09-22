import UIKit

final class FloatingPlainTabBar: UITabBar {

    private let capsule = UIView()

    // MARK: - Layout constants
    private let preferredBarHeight: CGFloat = 70
    private let corner: CGFloat = 20
    private let hInset: CGFloat = 8
    private let vInset: CGFloat = 4
    private let preferredCapsuleHeight: CGFloat = 60
    private let capsuleBottomGap: CGFloat = 6
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        isOpaque = false
        isTranslucent = true
        backgroundImage = UIImage()
        shadowImage = UIImage()
        backgroundColor = .clear
        clipsToBounds = false
        layer.masksToBounds = false

        capsule.backgroundColor = UIColor(red: 30/255, green: 50/255, blue: 65/255, alpha: 1)
        capsule.layer.cornerCurve = .continuous

        capsule.layer.shadowColor = UIColor.black.cgColor
        capsule.layer.shadowOpacity = 0.12
        capsule.layer.shadowRadius = 12
        capsule.layer.shadowOffset = CGSize(width: 0, height: 6)

        insertSubview(capsule, at: 0)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var s = super.sizeThatFits(size)
        let minH = preferredBarHeight + safeAreaInsets.bottom
        if s.height < minH { s.height = minH }
        return s
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let visibleH = bounds.height - safeAreaInsets.bottom
        let capH = max(36, min(preferredCapsuleHeight, visibleH - vInset*2))
        let capW = bounds.width - hInset*2
        let capX = hInset
        let capY = max(0, visibleH - capH - capsuleBottomGap) + 12

        capsule.frame = CGRect(x: capX, y: capY, width: capW, height: capH)
        capsule.layer.cornerRadius = min(corner, capH/2)

        capsule.layer.shadowPath = UIBezierPath(
            roundedRect: capsule.bounds,
            cornerRadius: capsule.layer.cornerRadius
        ).cgPath
    }
}

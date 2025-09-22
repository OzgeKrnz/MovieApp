import UIKit

final class FloatingPlainTabBar: UITabBar {

    // MARK: - Subviews & layers
    private let capsule = UIView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    private let overlay = CALayer()        // hafif tint
    private let highlight = CAGradientLayer() // üst parlama
    private let border = CALayer()         // cam kenarı (stroke)

    // MARK: - Layout constants
    private let preferredBarHeight: CGFloat = 70
    private let corner: CGFloat = 30
    private let hInset: CGFloat = 8
    private let vInset: CGFloat = 4
    private let preferredCapsuleHeight: CGFloat = 60

    // Kapsülü aşağı kaydır (ikonlar göreceli olarak yukarıda görünür)
    private let capsuleBottomGap: CGFloat = 6

    // MARK: - Init
    override init(frame: CGRect) { super.init(frame: frame); setup() }
    required init?(coder: NSCoder) { super.init(coder: coder); setup() }

    // MARK: - Setup
    private func setup() {
        // Tab bar’ı tamamen şeffaf yap
        isOpaque = false
        isTranslucent = true
        backgroundImage = UIImage()
        shadowImage = UIImage()
        backgroundColor = .clear
        clipsToBounds = false
        layer.masksToBounds = false

        // Capsule container
        capsule.backgroundColor = .clear
        capsule.layer.cornerCurve = .continuous
        capsule.clipsToBounds = true

        // Blur
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        capsule.addSubview(blurView)

        // Overlay (çok hafif bir tint, camın gövdesi)
        overlay.masksToBounds = true
        capsule.layer.addSublayer(overlay)

        // Highlight (üstten aşağı doğru parlama)
        highlight.startPoint = CGPoint(x: 0.5, y: 0.0)
        highlight.endPoint = CGPoint(x: 0.5, y: 1.0)
        capsule.layer.addSublayer(highlight)

        // Border (ince beyazımsı kenar)
        border.borderWidth = 1
        capsule.layer.addSublayer(border)

        // Dış gölge (camı zeminden kaldırır)
        capsule.layer.shadowRadius = 14
        capsule.layer.shadowOffset = CGSize(width: 0, height: 8)
        capsule.layer.shadowOpacity = 0.16

        insertSubview(capsule, at: 0)
    }

    // MARK: - Sizing
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var s = super.sizeThatFits(size)
        let minH = preferredBarHeight + safeAreaInsets.bottom
        if s.height < minH { s.height = minH }
        return s
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        // Kapsül boyut/konum
        let visibleH = bounds.height - safeAreaInsets.bottom
        let capH = max(36, min(preferredCapsuleHeight, visibleH - vInset*2))
        let capW = bounds.width - hInset*2
        let capX = hInset
        let capY = max(0, visibleH - capH - capsuleBottomGap) + 12

        capsule.frame = CGRect(x: capX, y: capY, width: capW, height: capH)
        capsule.layer.cornerRadius = min(corner, capH/2)

        // Blur & katman çerçeveleri
        blurView.frame = capsule.bounds

        // Tema: light/dark’a göre hafif farklı tint & highlight
        if traitCollection.userInterfaceStyle == .light {
            overlay.backgroundColor = UIColor.white.withAlphaComponent(0.10).cgColor
            highlight.colors = [
                UIColor.white.withAlphaComponent(0.45).cgColor,
                UIColor.white.withAlphaComponent(0.08).cgColor,
                UIColor.clear.cgColor
            ]
            capsule.layer.shadowColor = UIColor.black.cgColor
            border.borderColor = UIColor.white.withAlphaComponent(0.28).cgColor
        } else {
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.10).cgColor
            highlight.colors = [
                UIColor.white.withAlphaComponent(0.30).cgColor,
                UIColor.white.withAlphaComponent(0.06).cgColor,
                UIColor.clear.cgColor
            ]
            capsule.layer.shadowColor = UIColor.black.cgColor
            border.borderColor = UIColor.white.withAlphaComponent(0.22).cgColor
        }

        // Highlight sadece üstte 40–45% yoğunlukta dursun
        let hHeight = capsule.bounds.height * 0.45
        highlight.frame = CGRect(x: 0, y: 0, width: capsule.bounds.width, height: hHeight)

        // Border tüm çerçeve (corner ile eşleşsin)
        border.frame = capsule.bounds
        border.cornerRadius = capsule.layer.cornerRadius

        // Performans için gölge path’i
        capsule.layer.shadowPath = UIBezierPath(
            roundedRect: capsule.bounds,
            cornerRadius: capsule.layer.cornerRadius
        ).cgPath
    }

    // iOS tema/appearance değişince canlı güncelle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setNeedsLayout()
    }
}

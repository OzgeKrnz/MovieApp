//
//  CustomToolbar.swift
//  movieApp
//
//  Created by özge kurnaz on 24.07.2025.
//

import UIKit

final class CustomToolbar: UIToolbar {
    
    var onHomeTapped: (()->Void)?
    var onFavoritesTapped: (()->Void)?
    var onProfileTapped: (()->Void)?
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupToolbar()
        applyLiquidGlass()
    }
    
    //MARK: - Material Layers
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    private let tintGradient = CAGradientLayer()
    private let specularHighlight = CAGradientLayer()
    private let borderGradient = CAGradientLayer()
    private let borderMask = CAShapeLayer()
    private let innerShadow = CAShapeLayer()
    
    
    private var corner: CGFloat { 24 }

    

    
    private var iconTint: UIColor {
        if traitCollection.userInterfaceStyle == .dark {
            return .white
        } else {
            return UIColor.black.withAlphaComponent(0.9)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
    
    private func setupToolbar(){
        let homeItem = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(homeTapped))
        
        let favoritesItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoritesTapped))
        
        let profileItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(profileTapped))
        
        let space = UIBarButtonItem.flexibleSpace()
        
        // toolbar item sırası
        self.items = [
            homeItem,
            space,
            favoritesItem,
            space,
            profileItem
        ]
        
        tintColor = iconTint
        setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        setShadowImage(UIImage(), forToolbarPosition: .any)
        isTranslucent = true
        layer.cornerRadius = corner
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.18
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 20
    }
    
    private func applyLiquidGlass() {
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurView, at: 0)

        // 2) TINT GRADIENT (üst hafif aydınlık → alt biraz koyu)
        tintGradient.colors = [
            UIColor.white.withAlphaComponent(0.20).cgColor,
            UIColor.black.withAlphaComponent(0.18).cgColor
        ]
        tintGradient.locations = [0.0, 1.0]
        tintGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        tintGradient.endPoint   = CGPoint(x: 0.5, y: 1.0)
        tintGradient.cornerRadius = corner
        layer.insertSublayer(tintGradient, above: blurView.layer)

        // 3) SPECULAR HIGHLIGHT (üst kenarda ince parıltı)
        specularHighlight.colors = [
            UIColor.white.withAlphaComponent(0.45).cgColor,
            UIColor.white.withAlphaComponent(0.12).cgColor,
            UIColor.clear.cgColor
        ]
        specularHighlight.locations = [0.0, 0.25, 1.0]
        specularHighlight.startPoint = CGPoint(x: 0.5, y: 0.0)
        specularHighlight.endPoint   = CGPoint(x: 0.5, y: 1.0)
        specularHighlight.cornerRadius = corner
        layer.addSublayer(specularHighlight)

        // 4) GRADIENT STROKE (ince ışıklı kenar)
        borderGradient.colors = [
            UIColor.white.withAlphaComponent(0.55).cgColor,
            UIColor.white.withAlphaComponent(0.15).cgColor,
            UIColor.black.withAlphaComponent(0.25).cgColor
        ]
        borderGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        borderGradient.endPoint   = CGPoint(x: 1.0, y: 1.0)
        borderGradient.mask = borderMask
        layer.addSublayer(borderGradient)

        // 5) SOFT INNER SHADOW (derinlik)
        innerShadow.fillRule = .evenOdd
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOpacity = 0.25
        innerShadow.shadowRadius = 12
        innerShadow.shadowOffset = CGSize(width: 0, height: 4)
        layer.addSublayer(innerShadow)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        let rect = bounds.insetBy(dx: 0.5, dy: 0.5)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: corner)

        // tint + highlight
        tintGradient.frame = bounds
        specularHighlight.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height*0.65)

        // gradient stroke mask
        borderGradient.frame = bounds
        let stroke = CAShapeLayer()
        stroke.path = path.cgPath
        stroke.fillColor = UIColor.clear.cgColor
        stroke.strokeColor = UIColor.white.cgColor
        stroke.lineWidth = 1.0
        borderMask.sublayers?.forEach { $0.removeFromSuperlayer() }
        borderMask.frame = bounds
        borderMask.addSublayer(stroke)

        // inner shadow (even-odd tekniği)
        let outer = UIBezierPath(roundedRect: rect.insetBy(dx: -40, dy: -40), cornerRadius: corner+40)
        let inner = UIBezierPath(roundedRect: rect, cornerRadius: corner)
        outer.append(inner)
        outer.usesEvenOddFillRule = true
        innerShadow.path = outer.cgPath
        innerShadow.frame = bounds

        // dış gölge yolu (performans)
        layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: corner).cgPath
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tintColor = .label
    }
    
    
    //MARK: - Actions
    
    @objc func homeTapped(){
        onHomeTapped?()
    }
    
    @objc func favoritesTapped(){
        onFavoritesTapped?()
    }
    
    @objc func profileTapped(){
        onProfileTapped?()
    }
    
    
    private func animateFeedback() {
        if let control = (subviews.first { $0 is UIControl }) { // sadece hafif bir pulse yeter
            UIView.animate(withDuration: 0.1, animations: {
                control.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
            }, completion: { _ in
                UIView.animate(withDuration: 0.1) { control.transform = .identity }
            })
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
}

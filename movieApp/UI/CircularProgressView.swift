//
//  CircularProgressView.swift
//  movieApp
//
//  Created by özge kurnaz on 7.07.2025.
//

import UIKit

class CircularProgressView: UIView {

    
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let percentageLabel = UILabel()
    
    
    var percentage: Int = 0{
        didSet{
            percentageLabel.text = "\(percentage)%"
            setProgress(to: CGFloat(percentage) / 100)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupLayers() {
        // Tüm önceki layer'ları ve label'ı temizle
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        percentageLabel.removeFromSuperview()
        
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2.5

        let circularPath = UIBezierPath(arcCenter: centerPoint,
                                        radius: radius,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 1.5 * CGFloat.pi,
                                        clockwise: true)

        // Gri arka halka
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.darkGray.cgColor
        trackLayer.lineWidth = 6
        trackLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)

        // Yeşil doluluk halkası
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.systemGreen.cgColor
        progressLayer.lineWidth = 6
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = CGFloat(percentage) / 100
        layer.addSublayer(progressLayer)

        // Orta yazı
        percentageLabel.frame = bounds
        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        percentageLabel.textColor = .white
        percentageLabel.text = "\(percentage)%"
        addSubview(percentageLabel)
    }


    private func setProgress(to progress: CGFloat) {
        progressLayer.strokeEnd = max(0.01, min(progress, 1.0))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        percentageLabel.removeFromSuperview()
        setupLayers()
    }

}

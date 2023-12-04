//
//  DotsView.swift
//  
//
//  Created by Álvaro Olave on 21/11/23.
//

import Foundation
import UIKit

/// The view that includes the animation itself, without containers. Creates its own width and height constraints, just need to align it in your view
public final class DotsView: UIView {
    
    private var radius: Double {
        configuration.dotRadius
    }
    private var numberOfDots: Int {
        configuration.dotsNumber
    }
    private var dotSeparation: Double {
        configuration.dotSeparation
    }
    
    private lazy var dots: [CAShapeLayer] = {
        (0..<numberOfDots).map { _ in dotLayer() }
    }()
    
    private lazy var gradientLayers: [CAGradientLayer] = {
        dots.map { gradientLayer(mask: $0) }
    }()
    
    private func dotLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = 0.0
        return layer
    }
    
    private func gradientLayer(mask: CAShapeLayer) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = configuration.colors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.25)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.mask = mask
        return gradientLayer
    }
    
    private var animationStarted: Bool {
        guard let first = dots.first else { return false }
        return first.animation(forKey: "dotsAnimation") != nil
    }
    
    private let configuration: DotsConfiguration
    
    public init(configuration: DotsConfiguration = DotsConfiguration.´default´) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        self.configuration = DotsConfiguration(dotsNumber: 0,
                                               dotRadius: 0.0,
                                               dotSeparation: 0.0,
                                               colors: [],
                                               animation: .opacity())
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayers
            .enumerated()
            .forEach {
                let border = $0.element.borderWidth
                $0.element.frame = CGRectMake(Double($0.offset) * (dotSeparation + radius),
                                              0.0,
                                              radius,
                                              radius)
                dots[$0.offset].path = UIBezierPath(ovalIn: CGRectMake(border,
                                                                       border,
                                                                       radius - (border * 2.0),
                                                                       radius - (border * 2.0))).cgPath
            }
        
        if !animationStarted {
            switch configuration.animation {
            case .opacity(let min, _):
                startOpaqueAnimation(min)
            case .opacityWave(let min, _):
                startOpaqueWaveAnimation(min)
            case .scale(let scale, _):
                startInflateAnimation(scale)
            case .scaleWave(let scale, _):
                startInflateWaveAnimation(scale)
            case .bounce(let height, _):
                startBounceWaveAnimation(height)
            case .bounceHorizontal(let width, _):
                startHorizontalBounceWaveAnimation(width)
            }
        }
    }
}

private extension DotsView {
    func setupView() {
        gradientLayers.forEach {
            layer.addSublayer($0)
        }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: radius),
            widthAnchor.constraint(equalToConstant: Double(numberOfDots) * (dotSeparation + radius - 1))
        ])
    }
    
    func startOpaqueAnimation(_ minOpacity: Double) {
        let individualDuration = 0.4
        let startDelay = 0.2
        let timeBetweenInOut = 0.6
        let delayBetweenRepetitions = 0.6
        let delayBetweenDots = 0.2
        let totalAnimationTime = startDelay + (Double(2 * dots.count) * delayBetweenDots) + delayBetweenRepetitions
        
        let multiplier = configuration.animation.speedMultiplier()
        
        dots.enumerated().forEach { (offset, dot) in
            let fadeOut = fadeOutAnimation(duration: individualDuration * multiplier.duration,
                                           beginTime: (startDelay + (delayBetweenDots * Double(offset))) * multiplier.begin,
                                           toValue: minOpacity)
            let fadeIn = fadeInAnimation(duration: individualDuration * multiplier.duration,
                                         beginTime: (timeBetweenInOut + (delayBetweenDots * Double((dots.count * 2) - offset))) * multiplier.begin,
                                         fromValue: minOpacity)
            dot.add(animationGroup([fadeOut, fadeIn],
                                   duration: totalAnimationTime * multiplier.total),
                    forKey: "dotsAnimation")
        }
    }
    
    func startOpaqueWaveAnimation(_ minOpacity: Double) {
        let individualDuration = 0.5
        let startDelayOut = 0.4
        let startDelayIn = 1.3
        let delayBetweenDots = 0.2
        let delayBetweenRepetitions = 0.5
        let totalAnimationTime = startDelayIn + (delayBetweenDots * Double(dots.count)) + delayBetweenRepetitions
        
        let multiplier = configuration.animation.speedMultiplier()
        
        dots.enumerated().forEach { (offset, dot) in
            let fadeOut = fadeOutAnimation(duration: individualDuration * multiplier.duration,
                                           beginTime: (startDelayOut + (delayBetweenDots * Double(offset))) * multiplier.begin,
                                           toValue: minOpacity)
            let fadeIn = fadeInAnimation(duration: individualDuration * multiplier.duration,
                                         beginTime: (startDelayIn + (delayBetweenDots * Double(offset))) * multiplier.begin,
                                         fromValue: minOpacity)
            dot.add(animationGroup([fadeOut, fadeIn],
                                   duration: totalAnimationTime * multiplier.total),
                    forKey: "dotsAnimation")
        }
    }
    
    func startInflateAnimation(_ scale: CGFloat) {
        let individualDuration = 0.3
        let startDelay = 0.2
        let delayBetweenRepetitions = 0.3
        let delayBetweenDots = 0.2
        let totalAnimationTime = startDelay + (Double(dots.count) * delayBetweenDots) + delayBetweenRepetitions
        
        let multiplier = configuration.animation.speedMultiplier()
        
        gradientLayers.enumerated().forEach { (offset, dot) in
            let inflate = inflateAnimation(duration: individualDuration * multiplier.duration,
                                           beginTime: (startDelay + (delayBetweenDots * Double(offset))) * multiplier.begin,
                                           autoreverses: false,
                                           scale: scale)
            dot.add(animationGroup([inflate],
                                   duration: totalAnimationTime * multiplier.total,
                                   autoreverses: true),
                    forKey: "dotsAnimation")
        }
    }
    
    func startInflateWaveAnimation(_ scale: CGFloat) {
        let individualDuration = 0.3
        let startDelay = 0.2
        let delayBetweenRepetitions = 0.4
        let delayBetweenDots = 0.2
        let totalAnimationTime = startDelay + (Double(dots.count) * delayBetweenDots) + delayBetweenRepetitions
        
        let multiplier = configuration.animation.speedMultiplier()
        
        gradientLayers.enumerated().forEach { (offset, dot) in
            let inflate = inflateAnimation(duration: individualDuration * multiplier.duration,
                                           beginTime: (startDelay + (delayBetweenDots * Double(offset))) * multiplier.begin,
                                           autoreverses: true,
                                           scale: scale)
            dot.add(animationGroup([inflate],
                                   duration: totalAnimationTime * multiplier.total),
                    forKey: "dotsAnimation")
        }
    }
    
    func startBounceWaveAnimation(_ height: CGFloat) {
        let individualDuration = 0.3
        let startDelay = 0.2
        let delayBetweenRepetitions = 0.4
        let delayBetweenDots = 0.2
        let totalAnimationTime = startDelay + (Double(dots.count) * delayBetweenDots) + delayBetweenRepetitions
        
        let multiplier = configuration.animation.speedMultiplier()
        
        gradientLayers.enumerated().forEach { (offset, dot) in
            let bounce = bounceAnimation(duration: individualDuration * multiplier.duration,
                                         beginTime: (startDelay + (delayBetweenDots * Double(offset))) * multiplier.begin,
                                         autoreverses: true,
                                         height: height,
                                         width: 0.0)
            dot.add(animationGroup([bounce],
                                   duration: totalAnimationTime * multiplier.total),
                    forKey: "dotsAnimation")
        }
    }
    
    func startHorizontalBounceWaveAnimation(_ width: CGFloat) {
        let individualDuration = 0.3
        let startDelay = 0.2
        let delayBetweenRepetitions = 0.4
        let delayBetweenDots = 0.2
        let totalAnimationTime = startDelay + (Double(dots.count) * delayBetweenDots) + delayBetweenRepetitions
        
        let multiplier = configuration.animation.speedMultiplier()
        
        gradientLayers.enumerated().forEach { (offset, dot) in
            let bounce = bounceAnimation(duration: individualDuration * multiplier.duration,
                                         beginTime: (startDelay + (delayBetweenDots * Double(offset))) * multiplier.begin,
                                         autoreverses: true,
                                         height: 0.0,
                                         width: width)
            dot.add(animationGroup([bounce],
                                   duration: totalAnimationTime * multiplier.total),
                    forKey: "dotsAnimation")
        }
    }
    
    func animationGroup(_ animations: [CABasicAnimation],
                        duration: CFTimeInterval,
                        autoreverses: Bool = false) -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.animations = animations
        animationGroup.repeatCount = .infinity
        animationGroup.autoreverses = autoreverses
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        return animationGroup
    }
    
    func fadeInAnimation(duration: CFTimeInterval,
                         beginTime: CFTimeInterval,
                         fromValue: Double) -> CABasicAnimation {
        return animation(keyPath: "opacity",
                         fromValue: fromValue,
                         toValue: 1.0,
                         duration: duration,
                         beginTime: beginTime)
    }
    
    func fadeOutAnimation(duration: CFTimeInterval,
                          beginTime: CFTimeInterval,
                          toValue: Double) -> CABasicAnimation {
        return animation(keyPath: "opacity",
                         fromValue: 1.0,
                         toValue: toValue,
                         duration: duration,
                         beginTime: beginTime)
    }
    
    func inflateAnimation(duration: CFTimeInterval,
                          beginTime: CFTimeInterval,
                          autoreverses: Bool,
                          scale: CGFloat) -> CABasicAnimation {
        return animation(keyPath: "transform.scale",
                         fromValue: CATransform3DIdentity,
                         toValue: CATransform3DMakeScale(scale, scale, 1.0),
                         duration: duration,
                         beginTime: beginTime,
                         autoreverses: autoreverses)
    }
    
    func bounceAnimation(duration: CFTimeInterval,
                         beginTime: CFTimeInterval,
                         autoreverses: Bool,
                         height: CGFloat,
                         width: CGFloat) -> CABasicAnimation {
        return animation(keyPath: "transform",
                         fromValue: CATransform3DIdentity,
                         toValue: CATransform3DTranslate(CATransform3DIdentity, width, height, 0.0),
                         duration: duration,
                         beginTime: beginTime,
                         autoreverses: autoreverses)
    }
    
    func animation(keyPath: String,
                   fromValue: Any?,
                   toValue: Any?,
                   duration: CFTimeInterval,
                   beginTime: CFTimeInterval,
                   autoreverses: Bool = false) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.duration = duration
        animation.beginTime = beginTime
        animation.autoreverses = autoreverses
        return animation
    }
}

//
//  DotsConfiguration.swift
//  
//
//  Created by Álvaro Olave on 21/11/23.
//

import Foundation
import UIKit

public struct DotsConfiguration {
    let dotsNumber: Int
    let dotRadius: Double
    let dotSeparation: Double
    let colors: [CGColor]
    let animation: DotAnimation
    
    public static var ´default´: DotsConfiguration {
        DotsConfiguration()
    }
    
    public init(dotsNumber: Int = 4,
                dotRadius: Double = 10.0,
                dotSeparation: Double = 8.0,
                colors: [UIColor] = [UIColor(red: 0.863, green: 0.0, blue: 0.157, alpha: 1.0)],
                animation: DotAnimation = .opacity()) {
        self.dotsNumber = dotsNumber
        self.dotRadius = dotRadius
        self.dotSeparation = dotSeparation
        self.animation = animation
        if colors.count == 1 {
            self.colors = (colors + colors).map { $0.cgColor }
        } else {
            self.colors = colors.map { $0.cgColor }
        }
    }
}

public enum DotAnimation {
    /// Animates the dots opacity between the values 1.0 and the the 'limit' param.
        /// - Parameter limit: Clearest opacity applied in the animation. Between 0.0 and 1.0
        /// - Parameter velocity: Modifies the animation velocity.
    case opacity(limit: Double = 0.1, velocity: AnimationVelocity = .regular)
    /// Animates the dots opacity between the values 1.0 and the the 'limit' param.
        /// - Parameter limit: Clearest opacity applied in the animation. Between 0.0 and 1.0
        /// - Parameter velocity: Modifies the animation velocity.
    case opacityWave(limit: Double = 0.1, velocity: AnimationVelocity = .regular)
    /// Animates the dots size applying a multiplier factor.
        /// - Parameter multiplier: Value used to apply the transform. Values above 1.0 increase the size and below 1.0 decrease it.
        /// - Parameter velocity: Modifies the animation velocity.
    case scale(multiplier: CGFloat = 1.2, velocity: AnimationVelocity = .regular)
    /// Animates the dots size applying a multiplier factor.
        /// - Parameter multiplier: Value used to apply the transform. Values above 1.0 increase the size and below 1.0 decrease it.
        /// - Parameter velocity: Modifies the animation velocity.
    case scaleWave(multiplier: CGFloat = 1.2, velocity: AnimationVelocity = .regular)
    /// Animates the dots creating a bounce effect.
        /// - Parameter desp: 'Jump' height. Negative numbers creates an upward movement and positive, downward.
        /// - Parameter velocity: Modifies the animation velocity.
    case bounce(desp: CGFloat = -10.0, velocity: AnimationVelocity = .regular)
    /// Animates the dots creating a pendulum effect.
        /// - Parameter desp: Horizontal displacement.
        /// - Parameter velocity: Modifies the animation velocity.
    case bounceHorizontal(desp: CGFloat = -10.0, velocity: AnimationVelocity = .regular)
    
    func speedMultiplier() -> SpeedMultipliers {
        switch self {
        case .opacity(_, let velocity),
                .scaleWave(_, let velocity),
                .bounce(_, let velocity),
                .bounceHorizontal(_, let velocity):
            switch velocity {
            case .slow:
                return SpeedMultipliers(duration: 0.7, begin: 1.2, total: 1.2)
            case .regular:
                return SpeedMultipliers(duration: 1.0, begin: 1.0, total: 1.0)
            case .fast:
                return SpeedMultipliers(duration: 1.2, begin: 0.7, total: 1.0)
            }
        case .opacityWave(_, let velocity),
                .scale(_, let velocity):
            switch velocity {
            case .slow:
                return SpeedMultipliers(duration: 0.7, begin: 1.2, total: 1.0)
            case .regular:
                return SpeedMultipliers(duration: 1.0, begin: 1.0, total: 1.0)
            case .fast:
                return SpeedMultipliers(duration: 1.2, begin: 0.7, total: 0.7)
            }
        }
    }
}

public enum AnimationVelocity {
    case slow
    case regular
    case fast
}

public struct SpeedMultipliers {
    let duration: Double
    let begin: Double
    let total: Double
}

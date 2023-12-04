//
//  LoadingDotsView.swift
//  
//
//  Created by Álvaro Olave on 4/12/23.
//

import UIKit

public class LoadingDotsView: UIView {
    public var dots: DotsView
    
    public init(configuration: DotsConfiguration = DotsConfiguration.´default´) {
        self.dots = DotsView(configuration: configuration)
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        self.dots = DotsView()
        super.init(coder: aDecoder)
    }
}

private extension LoadingDotsView {
    func setupView() {
        addSubview(dots)
        dots.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dots.centerXAnchor.constraint(equalTo: centerXAnchor),
            dots.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

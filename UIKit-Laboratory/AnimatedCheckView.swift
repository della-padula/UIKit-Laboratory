//
//  AnimatedCheckView.swift
//  UIKit-Laboratory
//
//  Created by denny on 2/11/25.
//

import UIKit
import SnapKit

protocol AnimatedCheckViewDelegate: AnyObject {
    func didCompleteAnimation(_ view: AnimatedCheckView)
}

class AnimatedCheckView: UIView {
    
    private let titleLabel = UILabel()
    private let checkLayer = CAShapeLayer()
    private let button = UIButton()
    
    weak var delegate: AnimatedCheckViewDelegate?

    init(text: String) {
        super.init(frame: .zero)
        setupView(text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(text: String) {
        backgroundColor = .systemGray5
        layer.cornerRadius = 10
        clipsToBounds = true

        titleLabel.text = text
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)

        addSubview(titleLabel)
        addSubview(button)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }

    @objc private func handleButtonTap() {
        button.isHidden = true
        drawCheckMark()
    }

    private func drawCheckMark() {
        let checkPath = UIBezierPath()
        let startPoint = CGPoint(x: 10, y: 20)
        let midPoint = CGPoint(x: 20, y: 30)
        let endPoint = CGPoint(x: 40, y: 10)

        checkPath.move(to: startPoint)
        checkPath.addLine(to: midPoint)
        checkPath.addLine(to: endPoint)

        checkLayer.path = checkPath.cgPath
        checkLayer.strokeColor = UIColor.systemGreen.cgColor
        checkLayer.lineWidth = 4
        checkLayer.fillColor = nil
        checkLayer.lineCap = .round
        checkLayer.strokeEnd = 0

        layer.addSublayer(checkLayer)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self

        checkLayer.add(animation, forKey: "checkAnimation")
    }

    private func slideOut() {
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseIn) {
            self.transform = CGAffineTransform(translationX: 100, y: 0)
            self.alpha = 0
        } completion: { _ in
            self.delegate?.didCompleteAnimation(self)
        }
    }
}

extension AnimatedCheckView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            slideOut()
        }
    }
}

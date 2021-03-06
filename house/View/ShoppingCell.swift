//
//  ShoppingCell.swift
//  house
//
//  Created by James Saeed on 10/06/2018.
//  Copyright © 2018 James Saeed. All rights reserved.
//

import UIKit
import SwipeCellKit

class ShoppingCell: SwipeTableViewCell {
    
    private var isPressed: Bool = false
    private var tapGestureRecognizer: UITapGestureRecognizer? = nil
    private var longPressGestureRecognizer: UILongPressGestureRecognizer? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func configure(with shoppingItem: Shopping) {
        titleLabel.text = shoppingItem.content
        
        DataService.instance.getUserNickname(for: shoppingItem.author) { (nickname) in
            self.subtitleLabel.text = "added by \(nickname)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureGestureRecognizer()
    }
}

// MARK: - Gesture Animations

extension ShoppingCell {
    
    private func configureGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGestureRecognizer!)
        
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gestureRecognizer:)))
        longPressGestureRecognizer?.minimumPressDuration = 0.1
        addGestureRecognizer(longPressGestureRecognizer!)
    }
    
    @objc internal func handleTapGesture() {
        UIImpactFeedbackGenerator().impactOccurred()
        UIView.animate(withDuration: 0.75,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform(translationX: 40, y: 0)
        })
        UIView.animate(withDuration: 0.75,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform.identity
        })
    }
    
    @objc internal func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            handleLongPressBegan()
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            handleLongPressEnded()
        }
    }
    
    private func handleLongPressBegan() {
        guard !isPressed else {
            return
        }
        
        UIImpactFeedbackGenerator().impactOccurred()
        isPressed = true
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
    
    private func handleLongPressEnded() {
        guard isPressed else {
            return
        }
        
        UIImpactFeedbackGenerator().impactOccurred()
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform.identity
        }) { (finished) in
            self.isPressed = false
        }
    }
}

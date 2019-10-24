//
//  MarqueeLabel.swift
//  MarqueeLabel
//
//  Created by Rex Peng on 2019/10/23.
//  Copyright © 2019 Rex Peng. All rights reserved.
//

import UIKit

@IBDesignable class MarqueeLabel: UIView {

    private var _msg: String? = "MarqueeLabel"
    private var msgColor: UIColor = .black
    private var myFontName: String?
    private var fontSize: CGFloat = 6

    @IBInspectable var scrollSpeed: Int = 5
    @IBInspectable open var text : String? {
        set {
            self._msg = newValue
        }
        get {
            return self._msg
        }
    }
    @IBInspectable var textColor: UIColor {
        set {
            self.msgColor = newValue
        }
        get {
            return self.msgColor
        }
    }
    @IBInspectable var fontFamilyIndex : CGPoint = .zero {
        didSet {
            myFontName = getFontName(index: fontFamilyIndex)
        }
    }
//    @IBInspectable var FontName : String? {
//        get {
//            return getFontName(index: fontFamilyIndex)
//
//        }
//    }
    
    private func getFontName(index: CGPoint) -> String? {
        if Int(index.x) >= 0 && Int(index.x) < UIFont.familyNames.count {
            let fontNames = UIFont.fontNames(forFamilyName: UIFont.familyNames[Int(index.x)])
            if Int(index.y) >= 0 && Int(index.y) < fontNames.count {
                return  fontNames[Int(index.y)]
            }
            return fontNames.first ?? UIFont.systemFont(ofSize: fontSize).fontName

        }
        return UIFont.systemFont(ofSize: fontSize).fontName
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    
    private func fitToHeight(height: CGFloat) -> (font: UIFont, msgWidth: CGFloat, msgHeight: CGFloat) {
        guard let msg = _msg else {
            return (font: UIFont.systemFont(ofSize: fontSize), msgWidth: 0, msgHeight: 0)
        }
        var fSize = fontSize
        var font: UIFont = UIFont(name: myFontName!, size: fSize)!
        var msgHeight: CGFloat = 0
        let msgLabel = UILabel()
        while (msgHeight < height) {
            font = UIFont(name: myFontName!, size: fSize)!
            msgLabel.font = font
            msgLabel.text = msg
            msgLabel.sizeToFit()
            msgHeight = msgLabel.frame.height-font.descender
            fSize += 1
        }
        font = UIFont(name: myFontName!, size: fSize-2)!
        msgLabel.font = font
        msgLabel.text = msg
        msgLabel.sizeToFit()
        msgHeight = msgLabel.frame.height-font.descender
        let msgWidth = msgLabel.frame.width
        return(font: font, msgWidth: msgWidth, msgHeight: msgHeight)
    }
    
    override func draw(_ rect: CGRect) {
        guard let msg = _msg else { return }
        layer.sublayers = nil
        
        let msgProperty = fitToHeight(height: rect.height)
        
        let width = rect.width
        let txtLayer = CATextLayer()
        txtLayer.contentsScale = UIScreen.main.scale
        txtLayer.font = CGFont(msgProperty.font.fontName as CFString)
        txtLayer.fontSize = msgProperty.font.pointSize
        txtLayer.foregroundColor = msgColor.cgColor
        txtLayer.frame = CGRect(x: 0, y: (rect.height-msgProperty.msgHeight)*0.5, width: msgProperty.msgWidth, height: msgProperty.msgHeight)
        txtLayer.string = msg
        layer.addSublayer(txtLayer)
        
        #if !TARGET_INTERFACE_BUILDER
        let animate = CABasicAnimation(keyPath: "position.x")
        animate.timingFunction = CAMediaTimingFunction(name: .linear)
        animate.repeatCount = Float.infinity
        animate.duration = Double(msgProperty.msgWidth / CGFloat(self.scrollSpeed)  * 0.1)
        animate.isRemovedOnCompletion = true
        animate.fromValue = width+msgProperty.msgWidth*0.5 
        animate.toValue = -msgProperty.msgWidth*0.5
        txtLayer.add(animate, forKey: "trnasformX")
        #endif
    }

    private func setupView() {
        clipsToBounds = true
        
    }
}



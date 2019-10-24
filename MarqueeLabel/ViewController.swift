//
//  ViewController.swift
//  MarqueeLabel
//
//  Created by Rex Peng on 2019/10/23.
//  Copyright © 2019 Rex Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var mLabel: UILabel!
    
    var msgWidth: CGFloat = 0
    var orgWidth: CGFloat = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLabel()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mLabel.frame = CGRect(x: orgWidth, y: mLabel.frame.origin.y, width: mLabel.frame.width, height: mLabel.frame.height)

    }
    
    deinit {
        stopTimer()
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }

    func setupLabel() {
        guard mLabel.text != nil else { return }
        orgWidth = UIScreen.main.bounds.width
        mLabel.sizeToFit()
        msgWidth = mLabel.frame.width
        setupTimer()
    }

    func setupTimer() {
        guard mLabel.text != nil else { return }
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(scrollLabel), userInfo: nil, repeats: true)
    }

    @objc func scrollLabel() {
        guard mLabel.text != nil else { return }

        UIView.animate(withDuration: 0.1, animations: {
            self.mLabel.frame.origin.x -= self.msgWidth / CGFloat(self.mLabel.text!.count) * 0.1 * CGFloat(5)
        }) { (_) in
            if self.mLabel.frame.origin.x <= -self.msgWidth {
                self.mLabel.frame.origin.x = self.orgWidth
            }

        }
    }


}


//
//  StackController.swift
//  Stack
//
//  Created by Abhishek on 25/07/2020.
//  Copyright © 2020 Abhishek. All rights reserved.
//

import UIKit

open class StackController: UIViewController {
    
    //MARK: - Properties
    private let closeStack: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.imageView?.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(dismissStackVC), for: .touchUpInside)
        return button
    }()
    
    private let helpButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        button.imageView?.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(helpAction), for: .touchUpInside)
        return button
    }()
    
    let ctaHandleHeight:CGFloat = 100
    
    fileprivate var ctaText:[String]!
    fileprivate var childVC:[UIViewController]!
    var ctaVC: CTA!
    var currentIndex: Int = 0
    
    //MARK: - Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupStackUI()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        initializeStackWithControllers()
    }
    
    //MARK: - UI Setup
    fileprivate func setupStackUI() {
        self.view.backgroundColor = #colorLiteral(red: 0.04823390394, green: 0.08267720789, blue: 0.1083282605, alpha: 1)
        self.view.addSubview(closeStack)
        self.view.addSubview(helpButton)
        closeStack.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, paddingTop: 50, paddingLeft: 30)
        helpButton.anchor(top: self.view.topAnchor, right: self.view.rightAnchor, paddingTop: 50, paddingRight: 30)
    }
    
    //MARK: - Initialisation of ViewController and Call to action Text
    init(viewControllers:[UIViewController], text: [String]) {
        self.childVC = viewControllers
        self.ctaText = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///Present the Chid view controller
    func initializeStackWithControllers() {
        if currentIndex >= childVC.count {
            return
        }else if currentIndex >= 0 {
            nextVC(forIndex: currentIndex)
            setupcta(forIndex: self.currentIndex)
        }
    }
    
    //MARK: - Setup CTA and ViewController
    
    ///Call to action setup
    func setupcta(forIndex: Int) {
        ctaVC = CTA(ctaLabelText: self.ctaText[forIndex])
        self.addChild(ctaVC)
        self.view.addSubview(ctaVC.view)
        
        ctaVC.view.frame = CGRect(x: 0,
                                  y: self.view.frame.size.height,
                                  width: self.view.frame.width,
                                  height: ctaHandleHeight)
        
        let frameAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.ctaVC.view.frame = CGRect(x: 0, y: self.view.frame.size.height - self.ctaHandleHeight, width: self.view.frame.width, height: self.ctaHandleHeight)
        }
        
        frameAnimator.startAnimation()
        
        ctaVC.view.layer.cornerRadius = 20
        ctaVC.view.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(StackController.handleCTATap(recogniser:)))
        ctaVC.view.addGestureRecognizer(tapGesture)
        print(self.children.count)
        print(self.children)
    }
    
    ///Setup child viewcontroller
    func nextVC(forIndex: Int) {
        let vc = childVC[forIndex]
        
        self.addChild(vc)
        self.view.addSubview(vc.view)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(StackController.handleVCTap(recogniser:)))
        vc.view.addGestureRecognizer(tapGesture)
        
        vc.view.frame = CGRect(x: 0,
                               y: self.view.frame.size.height,
                               width: self.view.frame.width,
                               height: self.view.frame.size.height)
        
        let frameAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            vc.view.frame = CGRect(x: 0,
                                   y: (self.ctaHandleHeight * CGFloat(self.currentIndex + 1)),
                                   width: self.view.frame.width,
                                   height: self.view.frame.size.height - self.ctaHandleHeight)
            vc.view.layer.cornerRadius = 20
            vc.view.clipsToBounds = true
        }
        
        frameAnimator.startAnimation()
        
    }
    
    ///Action call to next View controller on tap gesture
    func navigateToNextVC(){
        currentIndex += 1
        if currentIndex >= childVC.count { currentIndex -= 1; return }
        let frameAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.ctaVC.view.frame.origin.y = self.view.frame.size.height
            self.ctaVC.removeFromParent()
        }
        frameAnimator.startAnimation()
        
        initializeStackWithControllers()
    }
    
    func popTopStack(index: Int) {
        if currentIndex == index {return}
        
        for i in (index + 1)..<self.children.count - 1 {
            let vc = self.children[i]
            let frameAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
                vc.view.frame = CGRect(x: 0,
                                       y: self.view.frame.size.height,
                                       width: self.view.frame.width,
                                       height: 0)
                
                self.ctaVC.view.frame = CGRect(x: 0,
                                               y: self.view.frame.size.height,
                                               width: self.view.frame.width,
                                               height: 0)
                self.ctaVC.removeFromParent()
            }
            
            frameAnimator.startAnimation()
        }
        currentIndex = index
        setupcta(forIndex: index)
    }
    
    //MARK: - Guesture Recognizer Action
    @objc
    func handleCTATap(recogniser:UITapGestureRecognizer) {
        switch recogniser.state {
        case .ended:
            navigateToNextVC()
        default:
            break
        }
    }
    
    @objc
    func handleVCTap(recogniser:UITapGestureRecognizer) {
        switch recogniser.state {
        case .ended:
            for (i,vc) in self.childVC.enumerated() {
                if vc.view == recogniser.view {
                    popTopStack(index: i)
                }
            }
        default:
            break
        }
    }
    
    //MARK: - Button Action
    @objc
    func dismissStackVC() {
        for vc in self.children {
            vc.removeFromParent()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func helpAction() {
        print("Help !!!")
    }
}

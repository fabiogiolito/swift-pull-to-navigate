//
//  ViewController.swift
//  NavbarExperiments
//
//  Created by Fabio Giolito on 05/12/2018.
//  Copyright © 2018 Fabio Giolito. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    enum NavbarAction: Int {
        case add = 0
        case compose
        case organize
        
        static func name(id: Int) -> String {
            switch NavbarAction(rawValue: id)! {
            case .add:
                return "Add"
            case .compose:
                return "Compose"
            case .organize:
                return "Organize"
            }
        }
    }

    var highlightedAction: UIBarButtonItem? {
        didSet {
            if scrollView.isDragging && highlightedAction != nil && highlightedAction != oldValue {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                
                oldValue?.tintColor = .blue
                highlightedAction?.tintColor = .red
            } else if highlightedAction == nil {
                oldValue?.tintColor = .blue
            }
        }
    }
    
    lazy var initialContentOffset: CGFloat = 0
    
    
    // ======

    let titleView: UILabel = {
        let label = UILabel()
        label.text = "Pull for action"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        return sv
    }()
    
    let dummy: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let pullValue: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        return label
    }()
    
    let button1: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: nil)
        item.tag = 0
        return item
    }()
    
    let button2: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose, target: nil, action: nil)
        item.tag = 1
        return item
    }()
    
    let button3: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.organize, target: nil, action: nil)
        item.tag = 2
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
        navigationItem.rightBarButtonItems = [button1, button2, button3]
//        navigationController?.navigationBar.prefersLargeTitles = true

        view.backgroundColor = .white
        
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
//        scrollView.addSubview(dummy)
//        dummy.translatesAutoresizingMaskIntoConstraints = false
//        dummy.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        dummy.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        dummy.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        dummy.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(pullValue)
        pullValue.translatesAutoresizingMaskIntoConstraints = false
        pullValue.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pullValue.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        initialContentOffset = scrollView.contentOffset.y * -1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDistance = (initialContentOffset + scrollView.contentOffset.y) * -1
        let minDistance: CGFloat = 50
        let maxDistance: CGFloat = 150
        
        if scrollDistance > minDistance && scrollDistance < (maxDistance + minDistance) {
            let buttonCount = navigationItem.rightBarButtonItems?.count
            let threashold = (maxDistance + minDistance) / CGFloat(buttonCount ?? 0)
            let selectedIndex = Int((scrollDistance / threashold).rounded()) - 1
            let selectedItem = navigationItem.rightBarButtonItems?[selectedIndex]
            
            highlightedAction = selectedItem
            
        } else {
            highlightedAction = nil
        }
        
        let progress = 1 + (scrollDistance / 100)
        if progress > 1 && progress < 2 {
            pullValue.transform = CGAffineTransform(scaleX: progress, y: progress)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if highlightedAction != nil {
            pullValue.text = NavbarAction.name(id: highlightedAction?.tag ?? 0)
            
            highlightedAction = nil
        } else {
            pullValue.text = "-"
        }
        
    }


}


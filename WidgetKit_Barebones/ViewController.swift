//
//  ViewController.swift
//  WidgetKit_Barebones
//
//  Created by 이로운 on 2022/07/20.
//

import WidgetKit
import UIKit

class ViewController: UIViewController {
     
    private let field: UITextField = {
        let field = UITextField()
        field.placeholder = "위젯에 어떤 텍스트를 띄울까요?"
        field.backgroundColor = .white
        field.borderStyle = .roundedRect
        return field
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("적용", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(field)
        view.addSubview(button)
        field.becomeFirstResponder()
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        field.frame = CGRect(x: 40, y: view.safeAreaInsets.top+40, width: view.frame.size.width-80, height: 45)
        button.frame = CGRect(x: 40, y: view.safeAreaInsets.top+100, width: view.frame.size.width-80, height: 45)
    }
    
    @objc private func didTapButton() {
        field.resignFirstResponder()
        
        let userDefaults = UserDefaults(suiteName: "group.WidgetKit_Barebones")
        
        guard let text = field.text, !text.isEmpty else { return }
        
        userDefaults?.setValue(text, forKey: "text")
        WidgetCenter.shared.reloadTimelines(ofKind: "MyWidget")
    }

}


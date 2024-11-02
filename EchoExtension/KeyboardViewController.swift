//
//  KeyboardViewController.swift
//  EchoExtension
//
//  Created by Bobby Wang on 11/2/24.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    private var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置视图背景
        view.backgroundColor = .systemBackground
        
        // 创建测试按钮
        testButton = UIButton(type: .system)
        testButton.setTitle("测试输入", for: .normal)
        testButton.addTarget(self, action: #selector(handleTestInput), for: .touchUpInside)
        
        // 设置按钮约束
        testButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testButton)
        
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testButton.widthAnchor.constraint(equalToConstant: 100),
            testButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func handleTestInput() {
        // 插入测试文本
        textDocumentProxy.insertText("Hello from Echo!")
    }
}

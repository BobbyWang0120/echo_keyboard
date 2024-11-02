import UIKit

class KeyboardViewController: UIInputViewController {
    
    private var shiftEnabled = false
    
    // 键盘布局数据
    private let keyboardLayout = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["shift", "z", "x", "c", "v", "b", "n", "m", "delete"],
        ["123", "globe", "space", "return"]
    ]
    
    private var keyboardView: UIView!
    private var shiftButton: KeyboardButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardView()
    }
    
    private func setupKeyboardView() {
        // 创建键盘容器视图
        keyboardView = UIView()
        keyboardView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardView)
        
        // 设置键盘容器约束
        NSLayoutConstraint.activate([
            keyboardView.leftAnchor.constraint(equalTo: view.leftAnchor),
            keyboardView.rightAnchor.constraint(equalTo: view.rightAnchor),
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 创建每一行按键
        var previousRowView: UIView?
        
        for (rowIndex, row) in keyboardLayout.enumerated() {
            let rowView = createRowView(with: row, isLastRow: rowIndex == keyboardLayout.count - 1)
            rowView.translatesAutoresizingMaskIntoConstraints = false
            keyboardView.addSubview(rowView)
            
            // 设置行视图约束
            if let previousRow = previousRowView {
                rowView.topAnchor.constraint(equalTo: previousRow.bottomAnchor, constant: 6).isActive = true
            } else {
                rowView.topAnchor.constraint(equalTo: keyboardView.topAnchor, constant: 6).isActive = true
            }
            
            NSLayoutConstraint.activate([
                rowView.leftAnchor.constraint(equalTo: keyboardView.leftAnchor, constant: 3),
                rowView.rightAnchor.constraint(equalTo: keyboardView.rightAnchor, constant: -3),
            ])
            
            if rowIndex == keyboardLayout.count - 1 {
                rowView.bottomAnchor.constraint(equalTo: keyboardView.bottomAnchor, constant: -6).isActive = true
            }
            
            previousRowView = rowView
        }
    }
    
    private func createRowView(with keys: [String], isLastRow: Bool) -> UIView {
        let rowView = UIView()
        var previousButton: UIButton?
        
        for (index, key) in keys.enumerated() {
            let button: KeyboardButton
            
            switch key {
            case "shift":
                button = createShiftButton()
                shiftButton = button
            case "delete":
                button = createDeleteButton()
            case "123":
                button = createNumberSymbolButton()
            case "space":
                button = createSpaceButton()
            case "return":
                button = createReturnButton()
            case "globe":
                button = createGlobeButton()
            default:
                button = createCharacterButton(with: key)
            }
            
            button.translatesAutoresizingMaskIntoConstraints = false
            rowView.addSubview(button)
            
            // 设置按钮约束
            if let previous = previousButton {
                button.leftAnchor.constraint(equalTo: previous.rightAnchor, constant: 6).isActive = true
            } else {
                button.leftAnchor.constraint(equalTo: rowView.leftAnchor).isActive = true
            }
            
            if index == keys.count - 1 {
                button.rightAnchor.constraint(equalTo: rowView.rightAnchor).isActive = true
            }
            
            button.topAnchor.constraint(equalTo: rowView.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: rowView.bottomAnchor).isActive = true
            
            if key == "space" {
                button.widthAnchor.constraint(equalTo: rowView.widthAnchor, multiplier: 0.5).isActive = true
            } else {
                button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: key == "delete" || key == "shift" || key == "123" || key == "return" ? 1.5 : 1.0).isActive = true
            }
            
            previousButton = button
        }
        
        return rowView
    }
    
    // MARK: - Button Creation Methods
    
    private func createCharacterButton(with key: String) -> KeyboardButton {
        let button = KeyboardButton(keyType: .character)
        button.setTitle(key, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
        return button
    }
    
    private func createShiftButton() -> KeyboardButton {
        let button = KeyboardButton(keyType: .shift)
        button.setImage(UIImage(systemName: "shift"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(shiftPressed), for: .touchUpInside)
        return button
    }
    
    private func createDeleteButton() -> KeyboardButton {
        let button = KeyboardButton(keyType: .backspace)
        button.setImage(UIImage(systemName: "delete.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        return button
    }
    
    private func createSpaceButton() -> KeyboardButton {
        let button = KeyboardButton(keyType: .spaceBar)
        button.setTitle("space", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(spacePressed), for: .touchUpInside)
        return button
    }
    
    private func createReturnButton() -> KeyboardButton {
        let button = KeyboardButton(keyType: .returnKey)
        button.setTitle("return", for: .normal)
        button.addTarget(self, action: #selector(returnPressed), for: .touchUpInside)
        return button
    }
    
    private func createGlobeButton() -> KeyboardButton {
        let button = KeyboardButton(keyType: .nextKeyboard)
        button.setImage(UIImage(systemName: "globe"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        return button
    }
    
    private func createNumberSymbolButton() -> KeyboardButton {
        let button = KeyboardButton(keyType: .numberSymbol)
        button.setTitle("123", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }
    
    // MARK: - Button Actions
    
    @objc private func keyPressed(_ sender: KeyboardButton) {
        guard let key = sender.title(for: .normal) else { return }
        let text = shiftEnabled ? key.uppercased() : key
        textDocumentProxy.insertText(text)
        
        if shiftEnabled {
            shiftEnabled = false
            updateShiftState()
        }
    }
    
    @objc private func shiftPressed() {
        shiftEnabled = !shiftEnabled
        updateShiftState()
    }
    
    @objc private func deletePressed() {
        textDocumentProxy.deleteBackward()
    }
    
    @objc private func spacePressed() {
        textDocumentProxy.insertText(" ")
    }
    
    @objc private func returnPressed() {
        textDocumentProxy.insertText("\n")
    }
    
    private func updateShiftState() {
        let symbolName = shiftEnabled ? "shift.fill" : "shift"
        shiftButton.setImage(UIImage(systemName: symbolName), for: .normal)
        
        // 更新所有字符键的大小写
        keyboardView.subviews.forEach { rowView in
            rowView.subviews.forEach { button in
                if let keyButton = button as? KeyboardButton,
                   let title = keyButton.title(for: .normal),
                   title.count == 1 && title.first?.isLetter == true {
                    keyButton.setTitle(shiftEnabled ? title.uppercased() : title.lowercased(), for: .normal)
                }
            }
        }
    }
}

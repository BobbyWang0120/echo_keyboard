import UIKit

class KeyboardButton: UIButton {
    
    // 按键类型枚举
    enum KeyType {
        case character
        case specialKey
        case spaceBar
        case returnKey
        case backspace
        case shift
        case numberSymbol
        case nextKeyboard
    }
    
    private let keyType: KeyType
    
    init(keyType: KeyType) {
        self.keyType = keyType
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 0.5
        
        switch keyType {
        case .character:
            titleLabel?.font = .systemFont(ofSize: 22)
        case .specialKey:
            titleLabel?.font = .systemFont(ofSize: 16)
        case .spaceBar:
            titleLabel?.font = .systemFont(ofSize: 16)
        case .returnKey:
            backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 1.0)
            setTitleColor(.white, for: .normal)
            titleLabel?.font = .systemFont(ofSize: 16)
        default:
            titleLabel?.font = .systemFont(ofSize: 16)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backgroundColor = UIColor(white: 0.9, alpha: 1.0)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        if case .returnKey = keyType {
            backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 1.0)
        }
    }
}

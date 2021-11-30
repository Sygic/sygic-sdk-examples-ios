import UIKit

class MapButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = 8
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6)
        backgroundColor = .secondarySystemGroupedBackground
        titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    }
}

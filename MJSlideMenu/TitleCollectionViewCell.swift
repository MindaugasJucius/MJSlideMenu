import UIKit

class TitleCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var segmentLabel: UILabel!
    
    var selectedTextColor: UIColor = .black
    var defaultTextColor: UIColor = .black
    
    var labelTitle: String? {
        get {
            return segmentLabel.text
        }
        set {
            segmentLabel.text = newValue
        }
    }
    
    var labelFont: UIFont {
        get {
            return segmentLabel.font
        }
        set {
            segmentLabel.font = newValue
        }
    }
    
    var labelTextColor: UIColor {
        get {
            return segmentLabel.textColor
        }
        set {
            segmentLabel.textColor = newValue
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateCell(stateSelected: isSelected)
        }
    }
    
    private func updateCell(stateSelected selected: Bool) {
        if selected {
            labelTextColor = selectedTextColor
        } else {
            labelTextColor = defaultTextColor
        }
    }
    
}

import UIKit
import MJSlideMenu

class ViewController: UIViewController {

    private var slideMenu: MJSlideMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideMenu = MJSlideMenu.create(withParentVC: self)
        slideMenu?.segments = createSegments()
        slideMenu?.indexViewColor = .red
        slideMenu?.menuHeight = 30
        slideMenu?.indexViewHeight = 5
    }

    func createSegments() -> [Segment] {
        let tuples: [(String, UIColor)] = [("first", .blue), ("second", .yellow), ("third", .lightGray)]
        return tuples.map { tuple in
            let view = UIView()
            view.backgroundColor = tuple.1
            return Segment(title: String(describing: tuple.0), contentView: view)
        }
    }
    
}

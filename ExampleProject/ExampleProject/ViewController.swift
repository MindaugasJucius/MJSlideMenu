import UIKit
import MJSlideMenu

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let slideMenu = MJSlideMenu.create(withParentView: view)
    }

}


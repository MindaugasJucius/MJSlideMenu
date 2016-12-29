import UIKit

fileprivate let BundleIdentifier = "min.apps.MJSlideMenu"

fileprivate let DefaultMenuHeight: CGFloat = 35
fileprivate let IndexViewHeight: CGFloat = 2

public struct Segment {
    
    public init(title: String, contentView: UIView) {
        self.title = title
        self.contentView = contentView
    }
    
    public let title: String
    public let contentView: UIView
}

fileprivate enum CollectionViewTags: Int {
    case menu = 1
    case content = 2
}

fileprivate let MenuCellReuseID = "TitleReuseIdentifier"
fileprivate let ContentCellReuseID = "ContentReuseIdentifier"

public class MJSlideMenu: UIView {

    @IBOutlet private weak var menuHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var menuCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var contentCollectionView: UICollectionView!
    
    private var indexView: UIView?
    fileprivate var shouldUpdateIndexPercentage = true
    
    public var indexViewColor: UIColor = .white
    public var menuTextColorSelected: UIColor = .black
    public var menuTextColor: UIColor = .black
    public var menuTextFont: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    
    public var segments: [Segment] = [] {
        didSet {
            updateMenuCollectionView(forItemCount: segments.count)
            menuCollectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    public static func create(withParentVC viewController: UIViewController) -> MJSlideMenu? {
        guard let slideMenu = loadSlideMenu() else {
            return nil
        }
        viewController.view.addSubview(slideMenu)
        slideMenu.addConstraints(toParentVC: viewController)
        return slideMenu
    }
    
    public static func create(withParentView view: UIView) -> MJSlideMenu? {
        guard let slideMenu = loadSlideMenu() else {
            return nil
        }
        view.addSubview(slideMenu)
        slideMenu.addConstraints(toParent: view)
        return slideMenu
    }
    
    private static func loadSlideMenu() -> MJSlideMenu? {
        let bundle = Bundle.init(identifier: BundleIdentifier)
        return bundle?.loadNibNamed(String(describing: MJSlideMenu.self), owner: nil, options: nil)?.first as? MJSlideMenu
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        configureMenuCollectionView()
        configureContentCollectionView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        (contentCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: self.contentCollectionView.frame.height
        )
    }

    // MARK: - Layout
    
    private func addConstraints(toParent view: UIView) {
        menuHeightConstraint.constant = DefaultMenuHeight
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func addConstraints(toParentVC viewController: UIViewController) {
        menuHeightConstraint.constant = DefaultMenuHeight
        topAnchor.constraint(equalTo: viewController.topLayoutGuide.bottomAnchor).isActive = true
        bottomAnchor.constraint(equalTo: viewController.bottomLayoutGuide.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: viewController.view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: viewController.view.rightAnchor).isActive = true
        
    }
    
    private func updateMenuCollectionView(forItemCount count: Int) {
        guard let flowLayout = menuCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let itemWidth = UIScreen.main.bounds.width / CGFloat(count)
        flowLayout.itemSize = CGSize(width: itemWidth,
                                     height: DefaultMenuHeight)
        
        let newIndexView = createIndexView(withWidth: itemWidth)
        self.indexView?.removeFromSuperview()
        self.indexView = newIndexView
        menuCollectionView.addSubview(newIndexView)
    }
    
    // MARK: - Menu index view
    
    private func createIndexView(withWidth width: CGFloat) -> UIView {
        let viewFrame = CGRect(x: 0, y: DefaultMenuHeight - IndexViewHeight, width: width, height: IndexViewHeight)
        let layerFrame = CGRect(x: 0, y: 0, width: width, height: IndexViewHeight)
        let indexLayer = CALayer()
        indexLayer.frame = layerFrame
        indexLayer.backgroundColor = indexViewColor.cgColor
        let indexView = UIView(frame: viewFrame)
        indexView.layer.addSublayer(indexLayer)
        return indexView
    }
    
    fileprivate func scrollIndexView(toIndexPath indexPath: IndexPath) {
        guard let indexAttributes = menuCollectionView.layoutAttributesForItem(at: indexPath) else {
            return
        }
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: { [unowned self] in
                self.indexView?.frame.origin.x = indexAttributes.frame.origin.x
            },
            completion: { [unowned self] completed in
                self.shouldUpdateIndexPercentage = completed
            }
        )
    }
    
    fileprivate func updateMenu(offsetPercentage percentage: CGFloat) {
        guard let indexView = indexView, shouldUpdateIndexPercentage else {
            return
        }
        let maxHorizontalIndexOffset = UIScreen.main.bounds.width - indexView.frame.width
        indexView.frame.origin.x = maxHorizontalIndexOffset * percentage
    }
    
    // MARK: - CollectionView Configurations
    
    private func layout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.zero
        return flowLayout
    }
    
    private func configureContentCollectionView() {
        contentCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellReuseID)
        contentCollectionView.dataSource = self
        contentCollectionView.collectionViewLayout = layout()
        contentCollectionView.allowsSelection = false
        contentCollectionView.isPagingEnabled = true
        contentCollectionView.delegate = self
        contentCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureMenuCollectionView() {
        menuCollectionView.backgroundColor = .lightText
        
        let cellNib = UINib(nibName: String(describing: TitleCollectionViewCell.self), bundle: Bundle.init(identifier: BundleIdentifier))
        menuCollectionView.register(cellNib, forCellWithReuseIdentifier: MenuCellReuseID)
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        menuCollectionView.isScrollEnabled = false
        menuCollectionView.collectionViewLayout = layout()
    }
    
    // MARK: - Cell Configurations
    
    fileprivate func configureMenuCell(forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: MenuCellReuseID, for: indexPath)
        guard let titleCell = cell as? TitleCollectionViewCell else {
            return cell
        }
        titleCell.labelTitle = segments[indexPath.row].title
        titleCell.labelFont = menuTextFont
        titleCell.defaultTextColor = menuTextColor
        titleCell.selectedTextColor = menuTextColorSelected
        titleCell.labelTextColor = menuTextColor
        if indexPath.row == 0 {
            titleCell.isSelected = true
            menuCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
        }
        return titleCell
    }
    
    fileprivate func configureContentCell(forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: ContentCellReuseID, for: indexPath)
        let segment = segments[indexPath.row]
        segment.contentView.frame = cell.bounds
        cell.contentView.insertSubview(segment.contentView, at: 0)
        return cell
    }
    
    fileprivate func updateMenuItemState(toSelected selected: Bool, atIndexPath indexPath: IndexPath) {
        guard let cell = menuCollectionView.cellForItem(at: indexPath) else {
            return
        }
        cell.isSelected = selected
        if selected {
            menuCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
        } else {
            menuCollectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    
}

extension MJSlideMenu: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segments.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case CollectionViewTags.menu.rawValue:
            return configureMenuCell(forIndexPath: indexPath)
        case CollectionViewTags.content.rawValue:
            return configureContentCell(forIndexPath: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
}

extension MJSlideMenu: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.tag)
        let maxHorizontalOffset = scrollView.contentSize.width - scrollView.frame.width
        guard maxHorizontalOffset > 0 else {
            return
        }
        let currentHorizontalOffset = scrollView.contentOffset.x
        let horizontalOffsetPercentage = currentHorizontalOffset / maxHorizontalOffset
        updateMenu(offsetPercentage: horizontalOffsetPercentage)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let indexPath = contentCollectionView.indexPathForItem(at: targetContentOffset.pointee) else {
            return
        }
        updateMenuItemState(toSelected: true, atIndexPath: indexPath)
    }
    
}

extension MJSlideMenu: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        shouldUpdateIndexPercentage = false
        contentCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        scrollIndexView(toIndexPath: indexPath)
    }
    
}

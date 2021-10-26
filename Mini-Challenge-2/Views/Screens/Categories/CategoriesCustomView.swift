//
//  CategoriesCustomView.swift
//  Mini-Challenge-2
//
//  Created by Johnny Camacho on 25/10/21.
//

import UIKit

@IBDesignable
class CategoriesCustomView: UIView {
    
    @IBInspectable var title: String = "Strength" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var titleShadow: UIColor = UIColor.clear {
        didSet {
            titleLabel.shadowColor = titleShadow
        }
    }
    
    @IBInspectable var background: UIImage? {
        didSet {
            backgroundImageView.image = background
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    let nibName = "CategoriesCustomView"
    var contentView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

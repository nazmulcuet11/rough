//
//  STSingleLineTextInputView.swift
//  XibViewDemo
//
//  Created by Nazmul Islam on 23/12/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

protocol NibLoadableView {
    func loadViewFromNib(named: String) -> UIView?
}

extension NibLoadableView {
    func loadViewFromNib(named nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self) as! AnyClass)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
}

@IBDesignable
class STSingleLineTextInputView: UIView, NibLoadableView {
    private(set) var contentView: UIView?
//    private let nibName = "STSingleLineTextInputView"

    @IBOutlet weak var imageView: UIImageView!
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBInspectable var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    @IBOutlet weak var textField: UITextField!
    var text: String? {
        return textField.text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupXib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupXib()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupXib()
        contentView?.prepareForInterfaceBuilder()
    }

    private func setupXib() {
        guard contentView == nil else {
            return
        }
        guard let view = loadViewFromNib(named: "\(Self.self)") else {
            fatalError("Can't load nib")
        }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
}

//
//  SwitcherView.swift
//  Pods
//
//  Created by ArshMini on 5/18/21.
//

import UIKit

public protocol SwitcherDelegate: AnyObject {
    func switcherStateChanged(to: Bool)
}

open class SwitcherView: UIView {




    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    convenience public init() {
        self.init(frame: CGRect.zero)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }






    //MARK: - Views
    lazy var boxView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.cornerRadius = boxViewSize.height/2
        return view
    }()

    lazy var containerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = boxViewSize.height/2
        view.backgroundColor = state ? offBackColor : onBackColor
        return view
    }()

    lazy var onIconView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = switcherIconSize.height/2
        view.backgroundColor = onBackColor
        return view
    }()

    lazy var offIconView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = switcherIconSize.height/2
        view.backgroundColor = offBackColor
        return view
    }()





    //MARK: - Private Properties
    private let boxViewPadding: CGFloat = 8.0
    private let switcherIconPadding: CGFloat = 6.0
    private var switcherIconSize: CGSize {
        return CGSize(width: boxViewSize.height - (2*switcherIconPadding), height: boxViewSize.height - (2*switcherIconPadding))
    }
    private var boxViewWidthConstraint: NSLayoutConstraint!
    private var boxViewHeightConstraint: NSLayoutConstraint!
    private var onIconWidthConstraint: NSLayoutConstraint!
    private var onIconHeightConstraint: NSLayoutConstraint!
    private var offIconWidthConstraint: NSLayoutConstraint!
    private var offIconHeightConstraint: NSLayoutConstraint!



    //MARK: - Public Properties
    public weak var delegate: SwitcherDelegate?
    public var boxViewSize: CGSize = .init(width: 61, height: 31)
    @IBInspectable public var onBackColor: UIColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1) {
        didSet {
            onIconView.backgroundColor = onBackColor
        }
    }

    @IBInspectable public var offBackColor: UIColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1) {
        didSet {
            offIconView.backgroundColor = offBackColor
        }
    }

    @IBInspectable public var shadowColor: UIColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1) {
        didSet {
            setShadow(color: shadowColor)
        }
    }

    @IBInspectable public var state: Bool = false {
        didSet {
            state ? animateToOnState(duration: animationDuration) : animateToOffState(duration: animationDuration)
        }
    }

    @IBInspectable public var animationDuration: TimeInterval = 0.6




  //MARK: - Setup
    private func setup() {
        addSubview(boxView)
        boxView.addSubview(containerView)
        containerView.addSubview(onIconView)
        containerView.addSubview(offIconView)


        //Add Constraints
        boxViewWidthConstraint = boxView.widthAnchor.constraint(equalToConstant: self.boxViewSize.width)
        boxViewHeightConstraint = boxView.heightAnchor.constraint(equalToConstant: self.boxViewSize.height)
        onIconWidthConstraint = onIconView.widthAnchor.constraint(equalToConstant: switcherIconSize.width)
        onIconHeightConstraint = onIconView.heightAnchor.constraint(equalToConstant: switcherIconSize.height)
        offIconWidthConstraint = offIconView.widthAnchor.constraint(equalToConstant: switcherIconSize.width)
        offIconHeightConstraint = offIconView.heightAnchor.constraint(equalToConstant: switcherIconSize.height)
        NSLayoutConstraint.activate([
            boxView.topAnchor.constraint(equalTo: self.topAnchor, constant: boxViewPadding),
            boxView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -boxViewPadding),
            boxView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: boxViewPadding),
            boxView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -boxViewPadding),
            boxViewWidthConstraint,
            boxViewHeightConstraint,
            containerView.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: 0),
            onIconView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: switcherIconPadding),
            onIconView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: switcherIconPadding),
            onIconView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -switcherIconPadding),
            onIconWidthConstraint,
            onIconHeightConstraint,
            offIconView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: switcherIconPadding),
            offIconView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -switcherIconPadding),
            offIconView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -switcherIconPadding),
            offIconWidthConstraint,
            offIconHeightConstraint,
        ])

        //Shadow
        setShadow(color: shadowColor)


        //Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPressed))
        self.addGestureRecognizer(tapGesture)
        
        //Configure Views
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}
            self.configureViews()
        }

    }

    private func setShadow(color: UIColor) {
        self.boxView.layer.shadowColor = color.cgColor
        self.boxView.layer.shadowRadius = 5
        self.boxView.layer.shadowOpacity = 0.1
        self.superview?.layoutIfNeeded()
        DispatchQueue.main.async {[unowned self] in
            self.boxView.layer.shadowPath = UIBezierPath(ovalIn: self.boxView.bounds.insetBy(dx: -4, dy: -4)).cgPath
        }
    }

    private func configureViews() {
        boxView.layer.cornerRadius = boxViewSize.height/2
        containerView.layer.cornerRadius = boxViewSize.height/2
        boxViewWidthConstraint.constant = boxViewSize.width
        boxViewHeightConstraint.constant = boxViewSize.height
        onIconWidthConstraint.constant = switcherIconSize.width
        onIconHeightConstraint.constant = switcherIconSize.width
        offIconWidthConstraint.constant = switcherIconSize.width
        offIconHeightConstraint.constant =  switcherIconSize.width
        offIconView.layer.cornerRadius = switcherIconSize.height/2
        onIconView.layer.cornerRadius = switcherIconSize.height/2
        self.superview?.layoutIfNeeded()
    }






    //MARK: - Animation
    private func animateToOnState(duration: TimeInterval) {

        //offIconView Animation
        containerView.bringSubviewToFront(onIconView)
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: [.curveEaseOut]) {
            self.offIconView.transform = CGAffineTransform(scaleX: 7, y: 7)
        } completion: {[unowned self] _ in
            self.containerView.backgroundColor = self.offBackColor
            self.offIconView.transform = .identity
        }

        //Container View Animation
        animatewContainerView(duration: duration * 0.6)


    }

    private func animateToOffState(duration: TimeInterval){

        //onIconView Animation
        containerView.bringSubviewToFront(offIconView)
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: [.curveEaseOut]) {
            self.onIconView.transform = CGAffineTransform(scaleX: 6, y: 6)
        } completion: {[unowned self] _ in
            self.containerView.backgroundColor = self.onBackColor
            self.onIconView.transform = .identity
        }

        //Container View Animatio
        animatewContainerView(duration: duration * 0.6)

    }

    private func animatewContainerView(duration: TimeInterval) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1) {[unowned self] in
                self.containerView.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
            }

            UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15) {[unowned self] in
                self.containerView.transform = .identity
            }
        })
    }




    //MARK: - Tap Gesture
    @objc func tapPressed() {
        state = !state
        delegate?.switcherStateChanged(to: state)
    }


}

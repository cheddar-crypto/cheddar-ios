//
//  SendPaymentViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/22/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class SendPaymentViewController: CheddarViewController<PaymentViewModel> {
    
    private var swipeCoordinator: SwipeToSendCoordinator!
    
    let swipeView = UIView() // TODO
    
    private let contentContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var amountChip = {
        return CheddarChip(action: { [weak self] in
            // TODO: Handle click if we support bitcoin address txs
        })
    }()
    
    private let toLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Theme.inverseBackgroundColor
        label.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        label.text = String.to.lowercased()
        return label
    }()
    
    private lazy var receiverChip = {
        return CheddarChip(action: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
    }()
    
    init(sharedViewModel: PaymentViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = sharedViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarTransparent()
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        // TODO
        
    }
    
    private func setup() {
        
        // Navbar
        title = .pay
        setLeftNavigationButton(.back)
        setNavBarTransparent()
        
        // Other views
        addSwipeToSendView()
        addContentContainer()
        addAmountChip()
        addToLabel()
        addReceiverChip()
        
        // Setup the swipe coordinator
        view.layoutIfNeeded()
        if let navController = navigationController {
            let views = [navController.navigationBar, contentContainer, swipeView]
            swipeCoordinator = SwipeToSendCoordinator(views: views, gestureView: swipeView)
        }
        
    }
    
    private func addContentContainer() {
        view.addSubview(contentContainer)
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentContainer.bottomAnchor.constraint(equalTo: swipeView.topAnchor).isActive = true
    }
    
    private func addAmountChip() {
        if let navBar = navigationController?.navigationBar {
            contentContainer.addSubview(amountChip)
            amountChip.translatesAutoresizingMaskIntoConstraints = false
            amountChip.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.chip)).isActive = true
            amountChip.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: CGFloat(Dimens.mediumMargin) + navBar.frame.maxY).isActive = true
            amountChip.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
            amountChip.title = viewModel.getAmountTitle()
        }
    }
    
    private func addToLabel() {
        contentContainer.addSubview(toLabel)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.leadingAnchor.constraint(equalTo: amountChip.trailingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: amountChip.centerYAnchor).isActive = true
    }
    
    private func addReceiverChip() {
        contentContainer.addSubview(receiverChip)
        receiverChip.translatesAutoresizingMaskIntoConstraints = false
        receiverChip.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(Dimens.chip)).isActive = true
        receiverChip.topAnchor.constraint(equalTo: amountChip.bottomAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        receiverChip.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        receiverChip.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        receiverChip.title = viewModel.getReceiver()
    }
    
    private func addSwipeToSendView() {
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            swipeView.backgroundColor = Theme.primaryColor
            view.addSubview(swipeView)
            swipeView.translatesAutoresizingMaskIntoConstraints = false
            swipeView.heightAnchor.constraint(equalToConstant: window.frame.height).isActive = true
            swipeView.widthAnchor.constraint(equalToConstant: window.frame.width).isActive = true
            let bottomPadding = window.safeAreaInsets.bottom
            let peek = CGFloat(Dimens.swipeBar) + bottomPadding
            swipeView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -peek).isActive = true
        }
    }

}

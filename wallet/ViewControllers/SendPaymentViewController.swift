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
    private var positions = [UIView : CGFloat]()
    
    private let swipeView = PaymentFinalizeView()
    private let textViewPlaceholder = UILabel()
    private let textView = UITextView()
    
    private let forLabel = UILabel()
    private lazy var topDivider = makeDivider()
    private lazy var bottomDivider = makeDivider()
    
    private let swipeToSendArrow: UIImageView = {
        let view = UIImageView()
        view.image = .up
        view.contentMode = .center
        return view
    }()
    
    private let swipeToSendLabel: UILabel = {
        let view = UILabel()
        view.text = String.swipeToSend.uppercased()
        view.textColor = .gray900
        view.font = Fonts.sofiaPro(weight: .bold, Dimens.titleText)
        view.numberOfLines = 0
        return view
    }()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        swipeCoordinator?.reset(duration: 0)
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        viewModel.note.observe = { [weak self] note in
            guard let self = self else { return }
            
            self.forLabel.isHidden = note == nil
            self.textView.isHidden = note == nil
            self.textView.text = note
            
            // TODO: Move to another observer if we support onchain txs
            self.textViewPlaceholder.isHidden = true
            self.textView.isEditable = false
            self.textView.isSelectable = false
        }
        
        viewModel.isLoading.observe = { [weak self] isLoading in
            guard let self = self else { return }
            
            if (isLoading) {
                self.swipeView.showLoading()
            }
        }
        
        // TODO: We should probably show a snackbar or something
        viewModel.error.observe = { [weak self] error in
            print(error)
            self?.swipeCoordinator.reset(duration: 0.1)
        }
        
        viewModel.paymentSent.observe = { [weak self] payment in
            guard let self = self else { return }
            
            self.swipeView.showContent { [weak self] in
                guard let self = self else { return }
                
                if let navController = self.navigationController as? CheddarNavigationController {
                    navController.statusBarStyle = .default
                    navController.popToRootViewController(animated: true)
                }
            }
        }
        
    }
    
    private func makeDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = Theme.shadowColor
        return view
    }
    
    private func setup() {
        
        // Navbar
        title = .pay
        setLeftNavigationButton(.back)
        setNavBarTransparent()
        
        // Other views
        addSwipeToSendView()
        addTranslatableSendingViews()
        addContentContainer()
        addDivider()
        addAmountChip()
        addToLabel()
        addReceiverChip()
        addNoteSection()
        
        // Setup the swipe coordinator
        if let navController = navigationController as? CheddarNavigationController {
            
            view.layoutIfNeeded()

            let navBar = navController.navigationBar
            navBar.frame.origin.y = UIApplication.shared.getStatusBarHeight()
            
            [navBar, contentContainer, swipeToSendArrow, swipeToSendLabel].forEach { view in
                positions[view] = view.frame.origin.y
            }
            
            swipeCoordinator = SwipeToSendCoordinator(
                gestureView: swipeView,
                onOffsetChange: { [weak self] (travelDistance, offset) in
                    guard let self = self else { return }
                    
                    navController.statusBarStyle = .default
                    navController.interactivePopGestureRecognizer?.isEnabled = offset == 0
                    
                    // Translations and parallax effects
                    let translation = -travelDistance * offset
                    for (view, position) in self.positions {
                        if (view == self.swipeToSendArrow) {
                            let adjustedTranslation = translation / 2
                            view.frame.origin.y = adjustedTranslation + position
                            view.alpha = 1 - (offset * 2)
                        } else if (view == self.swipeToSendLabel) {
                            let adjustedTranslation = translation / 4
                            view.frame.origin.y = adjustedTranslation + position
                            view.alpha = 1 - (offset * 2)
                        } else {
                            view.frame.origin.y = translation + position
                        }
                    }
                    
                },
                onSend: { [weak self] in
                    guard let self = self else { return }
                    
                    navController.statusBarStyle = .darkContent
                    self.viewModel.sendPayment()
                })
            
        }
        
    }
    
    private func addContentContainer() {
        if let navBar = navigationController?.navigationBar {
            view.addSubview(contentContainer)
            contentContainer.translatesAutoresizingMaskIntoConstraints = false
            contentContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: navBar.frame.height + UIApplication.shared.getStatusBarHeight()).isActive = true
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            contentContainer.bottomAnchor.constraint(equalTo: swipeView.topAnchor).isActive = true
        }
    }
    
    private func addDivider() {
        contentContainer.addSubview(topDivider)
        topDivider.translatesAutoresizingMaskIntoConstraints = false
        topDivider.topAnchor.constraint(equalTo: contentContainer.topAnchor).isActive = true
        topDivider.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor).isActive = true
        topDivider.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor).isActive = true
        topDivider.heightAnchor.constraint(equalToConstant: Dimens.shadow).isActive = true
    }
    
    private func addAmountChip() {
        contentContainer.addSubview(amountChip)
        amountChip.translatesAutoresizingMaskIntoConstraints = false
        amountChip.heightAnchor.constraint(equalToConstant: Dimens.chip).isActive = true
        amountChip.topAnchor.constraint(equalTo: topDivider.bottomAnchor, constant: Dimens.mediumMargin).isActive = true
        amountChip.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: Dimens.mediumMargin).isActive = true
        amountChip.title = viewModel.getAmountTitle()
    }
    
    private func addToLabel() {
        contentContainer.addSubview(toLabel)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.leadingAnchor.constraint(equalTo: amountChip.trailingAnchor, constant: Dimens.mediumMargin).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: amountChip.centerYAnchor).isActive = true
    }
    
    private func addReceiverChip() {
        contentContainer.addSubview(receiverChip)
        receiverChip.translatesAutoresizingMaskIntoConstraints = false
        receiverChip.heightAnchor.constraint(greaterThanOrEqualToConstant: Dimens.chip).isActive = true
        receiverChip.topAnchor.constraint(equalTo: amountChip.bottomAnchor, constant: Dimens.mediumMargin).isActive = true
        receiverChip.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: Dimens.mediumMargin).isActive = true
        receiverChip.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -Dimens.mediumMargin).isActive = true
        receiverChip.title = viewModel.getReceiver()
    }
    
    private func addSwipeToSendView() {
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            swipeView.backgroundColor = Theme.primaryColor
            view.addSubview(swipeView)
            swipeView.translatesAutoresizingMaskIntoConstraints = false
            swipeView.heightAnchor.constraint(equalToConstant: window.frame.height).isActive = true
            swipeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            swipeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            let bottomPadding = window.safeAreaInsets.bottom
            let peek = Dimens.swipeBar + bottomPadding
            swipeView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -peek).isActive = true
        }
    }
    
    private func addTranslatableSendingViews() {
        
        // Arrow
        view.addSubview(swipeToSendArrow)
        swipeToSendArrow.translatesAutoresizingMaskIntoConstraints = false
        swipeToSendArrow.topAnchor.constraint(equalTo: swipeView.topAnchor, constant: Dimens.mmdnMargin).isActive = true
        swipeToSendArrow.centerXAnchor.constraint(equalTo: swipeView.centerXAnchor).isActive = true
        
        // Label
        view.addSubview(swipeToSendLabel)
        swipeToSendLabel.translatesAutoresizingMaskIntoConstraints = false
        swipeToSendLabel.topAnchor.constraint(equalTo: swipeToSendArrow.bottomAnchor, constant: Dimens.mediumMargin).isActive = true
        swipeToSendLabel.centerXAnchor.constraint(equalTo: swipeView.centerXAnchor).isActive = true
        
    }
    
    private func addNoteSection() {
        
        contentContainer.addSubview(bottomDivider)
        bottomDivider.translatesAutoresizingMaskIntoConstraints = false
        bottomDivider.topAnchor.constraint(equalTo: receiverChip.bottomAnchor, constant: Dimens.mediumMargin).isActive = true
        bottomDivider.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor).isActive = true
        bottomDivider.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor).isActive = true
        bottomDivider.heightAnchor.constraint(equalToConstant: Dimens.shadow).isActive = true
        
        // For label
        let forLabel = UILabel()
        forLabel.text = String.forLabel.lowercased()
        forLabel.textColor = Theme.inverseBackgroundColor
        forLabel.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        contentContainer.addSubview(forLabel)
        forLabel.translatesAutoresizingMaskIntoConstraints = false
        forLabel.topAnchor.constraint(equalTo: bottomDivider.bottomAnchor, constant: Dimens.mediumMargin).isActive = true
        forLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimens.mediumMargin).isActive = true
        
        // TextView
        contentContainer.addSubview(textView)
        textView.backgroundColor = .red
        textView.tintColor = Theme.primaryColor
        textView.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        textView.isScrollEnabled = true
        textView.backgroundColor = Theme.backgroundColor
        let padding = Dimens.mediumMargin
        textView.textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: bottomDivider.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimens.tall - padding).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: swipeView.topAnchor).isActive = true
        
        // TextView Placeholder
        textViewPlaceholder.text = String.requestNotePlaceholder.lowercased()
        textViewPlaceholder.textColor = Theme.inverseBackgroundColor.withAlphaComponent(0.25)
        textViewPlaceholder.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        contentContainer.addSubview(textViewPlaceholder)
        textViewPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        textViewPlaceholder.topAnchor.constraint(equalTo: textView.topAnchor, constant: padding).isActive = true
        textViewPlaceholder.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: padding + 4).isActive = true
        
    }

}

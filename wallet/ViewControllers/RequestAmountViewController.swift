//
//  RequestAmountViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class RequestAmountViewController: CheddarViewController<RequestViewModel> {
    
    private lazy var nextButton = {
        return CheddarButton(action: { [weak self] in
            if let self = self {
                self.navController?.pushRequestNote(sharedViewModel: self.viewModel)
            }
        })
    }()
    
    private lazy var numberPad = {
        return CheddarNumberPad(
            onItemClicked: { [weak self] item in
                self?.numberPadCoordinator.addCharacter(char: item)
            },
            onBackspaceClicked: { [weak self] in
                self?.numberPadCoordinator.removeCharacter()
            })
    }()
    
    private lazy var numberPadCoordinator = {
        return CheddarNumberPad.Coordinator(
            fiatView: fiatInputView,
            cryptoView: cryptoInputView,
            onValueChange: { [weak self] value in
                self?.viewModel.amount.value = value
            })
    }()
    
    private lazy var amountContainer = {
        return UIView()
    }()
    
    private lazy var fiatInputView = {
        return CurrencyInputView(
            prefixChar: "$", // TODO
            action: { [weak self] in
                UIView.animate(withDuration: Theme.defaultAnimationDuration, delay: 0.0, options: [.allowUserInteraction], animations: {
                    self?.expandCryptoView()
                    self?.amountHeightConstraint?.constant = CurrencyInputView.maxHeight
                    self?.fiatHeightConstraint?.constant = CurrencyInputView.minHeight
                    self?.amountContainer.layoutIfNeeded()
                })
            })
    }()
    
    private lazy var cryptoInputView = {
        return CurrencyInputView(
            prefixChar: "₿", // TODO
            action: { [weak self] in
                UIView.animate(withDuration: Theme.defaultAnimationDuration, delay: 0.0, options: [.allowUserInteraction], animations: {
                    self?.expandFiatView()
                    self?.amountHeightConstraint?.constant = CurrencyInputView.minHeight
                    self?.fiatHeightConstraint?.constant = CurrencyInputView.maxHeight
                    self?.amountContainer.layoutIfNeeded()
                })
            })
    }()
    
    private var amountHeightConstraint: NSLayoutConstraint? = nil
    private var fiatHeightConstraint: NSLayoutConstraint? = nil
    
    private func expandCryptoView() {
        expandInputView(inputView: fiatInputView)
    }
    
    private func expandFiatView() {
        expandInputView(inputView: cryptoInputView)
    }
    
    private func expandInputView(inputView: CurrencyInputView) {
        let inputViews = [fiatInputView, cryptoInputView]
        inputViews.forEach { view in
            view.setStyle(
                style: inputView == view ? CurrencyInputView.Style.Expanded : CurrencyInputView.Style.Collapsed,
                animated: true)
        }
        self.numberPadCoordinator.selectedInputView = inputView
    }
    
    init(sharedViewModel: RequestViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = sharedViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.load()
    }
    
    private func setup() {
        
        // Navbar
        title = .request
        setLeftNavigationButton(.back, action: {
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        // Input areas
        addNextButton()
        addNumberPad()
        addAmountStack()
        addAmountLabel()
        addFiatLabel()
    }
    
    override func viewModelDidLoad() {
        
        viewModel.price.observe = { [weak self] price in
            self?.numberPadCoordinator.currentPrice = price.forLocale()
        }
        
        viewModel.amount.observe = { amount in
            print(amount)
        }
        
    }
    
    private func addNextButton() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.button)).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        nextButton.title = .next
    }
    
    private func addNumberPad() {
        view.addSubview(numberPad)
        numberPad.translatesAutoresizingMaskIntoConstraints = false
        numberPad.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        numberPad.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        numberPad.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func addAmountStack() {
        
        // Add container
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        containerView.bottomAnchor.constraint(equalTo: numberPad.topAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        
        // Add stackview
        containerView.addSubview(amountContainer)
        amountContainer.translatesAutoresizingMaskIntoConstraints = false
        amountContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        amountContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        amountContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    private func addAmountLabel() {
        amountContainer.addSubview(fiatInputView)
        fiatInputView.translatesAutoresizingMaskIntoConstraints = false
        fiatInputView.topAnchor.constraint(equalTo: amountContainer.topAnchor).isActive = true
        fiatInputView.leadingAnchor.constraint(equalTo: amountContainer.leadingAnchor).isActive = true
        fiatInputView.trailingAnchor.constraint(equalTo: amountContainer.trailingAnchor).isActive = true
        amountHeightConstraint = fiatInputView.heightAnchor.constraint(equalToConstant: CurrencyInputView.maxHeight)
        amountHeightConstraint?.isActive = true
        fiatInputView.title = "0"
        fiatInputView.setStyle(style: CurrencyInputView.Style.Expanded, animated: false)
    }
    
    private func addFiatLabel() {
        amountContainer.addSubview(cryptoInputView)
        cryptoInputView.translatesAutoresizingMaskIntoConstraints = false
        cryptoInputView.topAnchor.constraint(equalTo: fiatInputView.bottomAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        cryptoInputView.leadingAnchor.constraint(equalTo: amountContainer.leadingAnchor).isActive = true
        cryptoInputView.trailingAnchor.constraint(equalTo: amountContainer.trailingAnchor).isActive = true
        cryptoInputView.bottomAnchor.constraint(equalTo: amountContainer.bottomAnchor).isActive = true
        fiatHeightConstraint = cryptoInputView.heightAnchor.constraint(equalToConstant: CurrencyInputView.minHeight)
        fiatHeightConstraint?.isActive = true
        cryptoInputView.title = "0"
        cryptoInputView.setStyle(style: CurrencyInputView.Style.Collapsed, animated: false)
    }

}

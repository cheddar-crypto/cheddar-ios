//
//  RequestAmountViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class RequestAmountViewController: CheddarViewController<ViewModel> {
    
    private lazy var nextButton = {
        return CheddarButton(action: { [weak self] in
            (self?.navigationController as? CheddarNavigationController)?.pushRequestNote()
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
        return CheddarNumberPad.Coordinator(label: amountLabel)
    }()
    
    private lazy var amountLabel = {
        return UILabel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
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
        addAmountLabel()
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
    
    private func addAmountLabel() {
        view.addSubview(amountLabel)
        amountLabel.textColor = Theme.inverseBackgroundColor
        amountLabel.textAlignment = .center
        amountLabel.numberOfLines = 0
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        amountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        amountLabel.text = "0"
    }

}

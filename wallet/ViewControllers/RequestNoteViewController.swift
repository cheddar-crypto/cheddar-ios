//
//  RequestNoteViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class RequestNoteViewController: CheddarViewController<RequestViewModel> {
    
    private lazy var nextButton = {
        return CheddarButton(action: { [weak self] in
            if let self = self {
                self.navController?.pushInvoiceQR(sharedViewModel: self.viewModel)
            }
        })
    }()
    
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
    }
    
    private func setup() {
        
        // Navbar
        title = .note
        setLeftNavigationButton(.back)
        
        // Input areas
        addQRButton()
    }
    
    override func viewModelDidLoad() {
        
        print(viewModel.amount.value)
        
//        viewModel.amount.observe = { amount in
//            self.button.setTitle("\(amount)", for: .normal)
//        }
        
    }
    
    private func addQRButton() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.button)).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        nextButton.title = .createQR
    }

}

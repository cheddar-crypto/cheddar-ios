//
//  RequestInvoiceQRViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class RequestInvoiceQRViewController: CheddarViewController<RequestViewModel> {
    
    private lazy var actionBar = {
        return CheddarActionBar()
    }()
    
    private lazy var imageStackView = {
        return UIStackView()
    }()
    
    private lazy var imageView = {
        return UIImageView()
    }()
    
    private lazy var copyButton = {
        return CheddarButton(action: { [weak self] in
            UIPasteboard.general.string = self?.viewModel.invoice.value ?? "" // TODO: Use proper lnd invoice
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
        setLeftNavigationButton(.back)
        addActionBar()
        addImageStack()
        addQRImageView()
        addCopyButton()
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        title = String(viewModel.amount.value ?? 0.0) // TODO: Clean me
        imageView.image = viewModel.invoice.value?.toQR()
        
    }
    
    private func addActionBar() {
        view.addSubview(actionBar)
        actionBar.translatesAutoresizingMaskIntoConstraints = false
        actionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        actionBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        actionBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        actionBar.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.bar)).isActive = true
        
        // Add buttons
        actionBar.setLeftAction(title: "Close", action: { [weak self] in // TODO Localization
            self?.navController?.dismiss(animated: true, completion: nil)
        })
        
        actionBar.setRightAction(title: "Share", action: { // TODO Localization
            print("On Click Share")
        })
    }
    
    private func addImageStack() {
        imageStackView.spacing = CGFloat(Dimens.mediumMargin)
        imageStackView.axis = .vertical
        imageStackView.distribution = .equalCentering
        view.addSubview(imageStackView)
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        imageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        imageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        imageStackView.bottomAnchor.constraint(equalTo: actionBar.topAnchor, constant: 0).isActive = true
    }
    
    private func addQRImageView() {
        imageView.contentMode = .scaleAspectFit
        imageStackView.addArrangedSubview(imageView)
    }
    
    private func addCopyButton() {
        copyButton.title = "Copy" // TODO Localization
        imageStackView.addArrangedSubview(copyButton)
        copyButton.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.button)).isActive = true
        copyButton.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(Dimens.minButtonWidth)).isActive = true
    }

}

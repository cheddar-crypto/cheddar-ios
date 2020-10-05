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
    
    private lazy var imageContainer = {
        return UIView()
    }()
    
    private lazy var imageView = {
        return UIImageView()
    }()
    
    private lazy var copyButton = {
        return CheddarButton(style: .bordered, action: { [weak self] in
            guard let self = self else { return }
            UIPasteboard.general.string = self.viewModel.invoice.value // TODO: Use proper lnd invoice
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
        title = viewModel.getAmountTitle()
        imageView.image = viewModel.invoice.value?.toQR()
    }
    
    private func addActionBar() {
        view.addSubview(actionBar)
        actionBar.translatesAutoresizingMaskIntoConstraints = false
        actionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        actionBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        actionBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        actionBar.heightAnchor.constraint(equalToConstant: Dimens.view88).isActive = true
        
        // Add buttons
        actionBar.setLeftAction(title: "Close", action: { [weak self] in // TODO Localization
            self?.navigationController?.popToRootViewController(animated: true)
        })
        
        actionBar.setRightAction(title: "Share", action: { // TODO Localization
            print("On Click Share")
        })
    }
    
    private func addImageStack() {
        view.addSubview(imageContainer)
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageContainer.bottomAnchor.constraint(equalTo: actionBar.topAnchor).isActive = true
    }
    
    private func addQRImageView() {
        imageView.contentMode = .scaleAspectFit
        imageContainer.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor, constant: -Dimens.margin32).isActive = true
        let margins = Dimens.margin32 * 2
        let size = view.frame.width - margins
        imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    private func addCopyButton() {
        copyButton.title = .copy
        imageContainer.addSubview(copyButton)
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.heightAnchor.constraint(equalToConstant: Dimens.view56).isActive = true
        copyButton.widthAnchor.constraint(greaterThanOrEqualToConstant: Dimens.view140).isActive = true
        copyButton.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        copyButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Dimens.margin16).isActive = true
    }

}

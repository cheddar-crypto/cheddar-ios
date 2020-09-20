//
//  SendPaymentViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/22/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class SendPaymentViewController: CheddarViewController<PaymentViewModel> {
    
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
        setNavBarStyles()
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        // TODO
        
    }
    
    private func setup() {
        
        // Navbar
        title = .pay
        setLeftNavigationButton(.back)
        
        // Other views
        addAmountChip()
        addToLabel()
        addReceiverChip()
    }
    
    private func addAmountChip() {
        view.addSubview(amountChip)
        amountChip.translatesAutoresizingMaskIntoConstraints = false
        amountChip.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.chip)).isActive = true
        amountChip.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        amountChip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        amountChip.title = viewModel.getAmountTitle()
    }
    
    private func addToLabel() {
        view.addSubview(toLabel)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.leadingAnchor.constraint(equalTo: amountChip.trailingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        toLabel.centerYAnchor.constraint(equalTo: amountChip.centerYAnchor).isActive = true
    }
    
    private func addReceiverChip() {
        view.addSubview(receiverChip)
        receiverChip.translatesAutoresizingMaskIntoConstraints = false
        receiverChip.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(Dimens.chip)).isActive = true
        receiverChip.topAnchor.constraint(equalTo: amountChip.bottomAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        receiverChip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        receiverChip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        receiverChip.title = viewModel.getReceiver()
    }

}

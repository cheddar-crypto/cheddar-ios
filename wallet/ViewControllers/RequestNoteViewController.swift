//
//  RequestNoteViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class RequestNoteViewController: CheddarViewController<RequestViewModel>, UITextViewDelegate {
    
    private lazy var nextButton = {
        return CheddarButton(action: { [weak self] in
            if let self = self {
                self.viewModel.createInvoice()
                Navigator.pushPaymentQR(self, sharedViewModel: self.viewModel)
            }
        })
    }()
    
    private lazy var amountChip = {
        return CheddarChip(action: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
    }()
    
    private let divider = UIView()
    private let textViewPlaceholder = UILabel()
    private let textView = UITextView()
    
    private var keyboardAnchor: NSLayoutConstraint? = nil
    
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
        
        // Handle keyboard
        NotificationCenter.default.addObserver(self,
                selector: #selector(self.keyboardNotification(notification:)),
                name: UIResponder.keyboardWillChangeFrameNotification,
                object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textView.endEditing(true)

        // Fixes layout issue with next button
        // ignoring the safe area bottom
        self.view.layoutIfNeeded()
    }
    
    private func setup() {
        
        // Navbar
        title = .note
        setLeftNavigationButton(.back)
        
        // Views
        addQRButton()
        addAmountChip()
        addDivider()
        addNoteSection()
        
    }
    
    override func viewModelDidLoad() {
        textView.text = viewModel.note.value ?? ""
        textViewPlaceholder.isHidden = textView.text.count > 0
    }
    
    private func addQRButton() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.button)).isActive = true
        keyboardAnchor = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -CGFloat(Dimens.mediumMargin))
        keyboardAnchor?.isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CGFloat(Dimens.mediumMargin)).isActive = true
        nextButton.title = .createQR
    }
    
    private func addAmountChip() {
        view.addSubview(amountChip)
        amountChip.translatesAutoresizingMaskIntoConstraints = false
        amountChip.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.chip)).isActive = true
        amountChip.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        amountChip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        amountChip.title = viewModel.getAmountTitle()
    }
    
    private func addDivider() {
        divider.backgroundColor = Theme.shadowColor
        view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.shadow)).isActive = true
        divider.topAnchor.constraint(equalTo: amountChip.bottomAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        divider.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func addNoteSection() {
        
        // For label
        let forLabel = UILabel()
        forLabel.text = String.forLabel.lowercased()
        forLabel.textColor = Theme.inverseBackgroundColor
        forLabel.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        view.addSubview(forLabel)
        forLabel.translatesAutoresizingMaskIntoConstraints = false
        forLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        forLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(Dimens.mediumMargin)).isActive = true
        
        // TextView
        view.addSubview(textView)
        textView.tintColor = Theme.primaryColor
        textView.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        textView.isScrollEnabled = true
        textView.backgroundColor = Theme.backgroundColor
        let padding = CGFloat(Dimens.mediumMargin)
        textView.textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: divider.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(Dimens.tall) - padding).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        textView.delegate = self
        
        // TextView Placeholder
        textViewPlaceholder.text = String.requestNotePlaceholder.lowercased()
        textViewPlaceholder.textColor = Theme.inverseBackgroundColor.withAlphaComponent(0.25)
        textViewPlaceholder.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        view.addSubview(textViewPlaceholder)
        textViewPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        textViewPlaceholder.topAnchor.constraint(equalTo: textView.topAnchor, constant: padding).isActive = true
        textViewPlaceholder.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: padding + 4).isActive = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.note.value = textView.text
        textViewPlaceholder.isHidden = textView.text.count > 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardAnchor?.constant = -CGFloat(Dimens.mediumMargin)
            } else {
                self.keyboardAnchor?.constant = -(endFrame?.size.height ?? -CGFloat(Dimens.mediumMargin))
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }

}

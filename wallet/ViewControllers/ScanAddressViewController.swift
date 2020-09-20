//
//  ScanAddressViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/22/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit
import AVFoundation

class ScanAddressViewController: CheddarViewController<PaymentViewModel>, AVCaptureMetadataOutputObjectsDelegate {

    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let gradientView = UIView()
    private let emptyView = UIView()
    private lazy var pasteButton: CheddarButton = {
        let button = CheddarButton(style: .primary, action: { [weak self] in
            if let copiedText = UIPasteboard.general.string {
                self?.viewModel.postDiscoveredValue(value: copiedText)
            }
        })
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen to view coming back to foreground
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        setup()
        
    }
    
    @objc private func appBecomeActive() {
        showPasteButtonIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fix nav bug
        setNavBarTransparent()
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPasteButtonIfNeeded()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        viewModel.bitcoinAddress.observe = { [weak self] address in
            // TODO: Handle flow slightly better here
            if let self = self {
                Navigator.pushPaymentSend(self, sharedViewModel: self.viewModel)
            }
        }
        
        viewModel.invoice.observe = { [weak self] invoice in
            if let self = self {
                Navigator.pushPaymentSend(self, sharedViewModel: self.viewModel)
            }
        }
        
    }
    
    private func setup() {
        
        // Navbar
        title = .scanAddressTitle
        setLeftNavigationButton(.back)
        
        // Add the show empty if needed
        if (Permissions.canAccessCamera) {
            addCameraPreview()
        } else {
            addNeedPermissionView()
        }
        
        // Other views
        addGradientView()
        addPasteButton()
    }
    
    private func addGradientView() {
        view.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        gradientView.heightAnchor.constraint(equalToConstant: statusBarHeight + 84).isActive = true
        gradientView.addGradient(startColor: .black, endColor: .clear)
    }
    
    private func addNeedPermissionView() {
        view.addSubviewAndFill(emptyView)
        
        // Add the container
        let container = UIStackView()
        container.spacing = CGFloat(Dimens.largeMargin)
        container.axis = .vertical
        container.distribution = .fillEqually
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(Dimens.largeMargin)).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CGFloat(Dimens.largeMargin)).isActive = true
        
        // Add stacked views
        let titleLabel = UILabel()
        titleLabel.font = Fonts.sofiaPro(weight: .regular, Dimens.titleText)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        let attributedString = NSMutableAttributedString(string: .requestCameraAccessTitle)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.4
        paragraphStyle.alignment = .center
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        titleLabel.attributedText = attributedString
        container.addArrangedSubview(titleLabel)
        
        let accessButton = CheddarButton(style: .bordered, action: {
            let auth = AVCaptureDevice.authorizationStatus(for: .video)
            switch auth {
            case .notDetermined:
                Permissions.requestCameraAccess { [weak self] in
                    self?.showCamera()
                }
            default:
                Navigator.openSettingsForApp()
            }
        })
        
        accessButton.title = .requestCameraAccess
        accessButton.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.button)).isActive = true
        container.addArrangedSubview(accessButton)
        
    }
    
    private func showCamera() {
        DispatchQueue.main.async {
            self.addCameraPreview()
            self.emptyView.removeFromSuperview()
            self.view.bringSubviewToFront(self.gradientView)
            self.view.bringSubviewToFront(self.pasteButton)
        }
    }
    
    private func addCameraPreview() {
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        
        // Add the qr frame
        let imageView = UIImageView()
        imageView.image = .qrFrame
        imageView.contentMode = .center
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -CGFloat(Dimens.bar)).isActive = true
        
    }
    
    private func addPasteButton() {
        view.addSubview(pasteButton)
        pasteButton.translatesAutoresizingMaskIntoConstraints = false
        pasteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pasteButton.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.button)).isActive = true
        pasteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -CGFloat(Dimens.button)).isActive = true
        showPasteButtonIfNeeded()
    }
    
    private func showPasteButtonIfNeeded() {
        if let copiedText = UIPasteboard.general.string {
            if (copiedText.isBitcoinAddress) {
                pasteButton.title = .pasteBitcoinAddress
                pasteButton.isHidden = false
            } else if (copiedText.isLightningInvoice) {
                pasteButton.title = .pasteInvoice
                pasteButton.isHidden = false
            } else {
                pasteButton.isHidden = true
            }
        } else {
            pasteButton.isHidden = true
        }
    }
    
    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    private func found(code: String) {
        viewModel.postDiscoveredValue(value: code)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

}

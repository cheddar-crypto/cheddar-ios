//
//  RequestInvoiceQRViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class RequestInvoiceQRViewController: CheddarViewController<RequestViewModel> {
    
    private lazy var imageView = {
        return UIImageView()
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
        addQRImageView()
    }
    
    override func viewModelDidLoad() {
        super.viewModelDidLoad()
        
        title = String(viewModel.amount.value ?? 0.0) // TODO: Clean me
        imageView.image = generateQRCode(from: viewModel.note.value as? String)
        
    }
    
    private func addQRImageView() {
        imageView.contentMode = .center
        view.addSubviewAndFill(imageView)
    }
    
    func generateQRCode(from string: String?) -> UIImage? {
        let data = string?.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

}

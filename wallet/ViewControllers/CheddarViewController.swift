//
//  CheddarViewController.swift
//  wallet
//
//  Created by Michael Miller on 8/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class CheddarViewController<VM: ViewModel>: UIViewController {
    
    private lazy var leftNavigationAction: () -> Void = {
        self.navigationController?.popViewController(animated: true)
    }
    
    internal var viewModel: VM! {
        didSet {
            viewModelDidLoad()
        }
    }
    
    lazy var loadingView: LoadingView = {
        return LoadingView()
    }()
    
    lazy var errorView: ErrorView = {
        return ErrorView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = VM()
        setTheme()
    }
    
    public func showContentView() {
        dropViews([errorView, loadingView])
    }
    
    public func showLoadingView() {
        dropViews([errorView])
        addViewIfNeeded(loadingView)
    }
    
    public func showErrorView(error: String = .defaultError) {
        dropViews([loadingView])
        addViewIfNeeded(errorView)
        errorView.title = error
    }
    
    private func dropViews(_ views: [UIView]) {
        views.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    private func addViewIfNeeded(_ subview: UIView) {
        if (!view.subviews.contains(subview)) {
            view.addSubviewAndFill(subview)
            view.bringSubviewToFront(subview)
        }
    }
    
    func viewModelDidLoad() {
        // Empty
    }
    
    @objc private func leftAction() {
        leftNavigationAction()
    }
    
    func setLeftNavigationButton(_ icon: UIImage, action: (() -> Void)? = nil) {
        
        // Attach left action
        // Or fallback with a pop
        if let leftAction = action {
            leftNavigationAction = leftAction
        } else {
            leftNavigationAction = {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .back,
            style: .plain,
            target: self,
            action: #selector(CheddarViewController.leftAction)
        )
    }
    
}

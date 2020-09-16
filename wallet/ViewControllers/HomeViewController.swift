//
//  HomeViewController.swift
//  wallet
//
//  Created by Jason van den Berg on 2020/08/18.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class HomeViewController: CheddarViewController<HomeViewModel> {
    
    let exampleTransactions = ["asdjkhasjd asjkldh ahjklsd ahjksda sdk ashjkd ", "asdasdasd", "asdasdasdklashdaklhj dalkjhsd ashjkld asklhjd ashjkld ahjklsd ahjksd asdjl a", "asdasdasd", "asdasdasd", "asdasdasd", "asdasdasd", "asdasdasd", "asdasdasd"]
    
    private lazy var collectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TransactionCollectionViewCell.self, forCellWithReuseIdentifier: TransactionCollectionViewCell.id)
        view.addSubviewAndFill(collectionView)
    }
    
    override func viewModelDidLoad() {
        
        viewModel.isLoading.observe = { [weak self] isLoading in
            if (isLoading) {
                self?.showLoadingView()
            }
        }
        
        viewModel.price.observe = { [weak self] price in
            self?.showContentView()
        }
        
        viewModel.error.observe = { [weak self] error in
            self?.showErrorView()
        }
        
        viewModel.resultMessage.observe = { [weak self] message in
//            self?.resultMessage.text = message
            self?.showContentView()
        }
        
        viewModel.newAddress.observe = { [weak self] address in
//            self?.resultMessage.text = address
            UIPasteboard.general.string = address
            self?.showContentView()
        }
        
        viewModel.walletWipe.observe = { _ in
            UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
        viewModel.load()
        
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCollectionViewCell.id, for: indexPath) as! TransactionCollectionViewCell
        cell.textView.text = exampleTransactions[indexPath.row]
        cell.maxWidth = collectionView.frame.width
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        // 2 because:
        // We have a top section, the header
        // and a bottom section, the cells
        // TODO: Handle pagination here
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 1 ? exampleTransactions.count : 1
    }
    
}

//
//  HomeViewController.swift
//  wallet
//
//  Created by Jason van den Berg on 2020/08/18.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class HomeViewController: CheddarViewController<HomeViewModel> {
    
    let exampleTransactions = ["asdjkhasjd asjkldh ahjklsd ahjksda sdk ashjkd ", "asdasdasd", "asdasdasdklashdaklhj dalkjhsd ashjkld asklhjd ashjkld ahjklsd ahjksd asdjl a", "asdasdasd", "asdasdasd", "asdasdasd", "asdasdasd", "asdasdasd", "asdasdasd", "asdjkhasjd asjkldh ahjklsd ahjksda sdk ashjkd ", "asdasdasd", "asdasdasdklashdaklhj dalkjhsd ashjkld asklhjd ashjkld ahjklsd ahjksd asdjl a", "asdasdasd", "asdasdasd", "asdasdasd", "asdasdasd", "asdasdasd", "asdasdasd"]
    
    private lazy var actionBar: CheddarActionBar = {
        let actionBar = CheddarActionBar()
        actionBar.setLeftAction(title: "Request", action: { [weak self] in
            if let self = self {
                Navigator.pushRequestAmount(self)
            }
        })
        actionBar.setRightAction(title: "Pay", action: { [weak self] in
            if let self = self {
                Navigator.pushPaymentScan(self)
            }
        })
        actionBar.translatesAutoresizingMaskIntoConstraints = false
        return actionBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delaysContentTouches = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TransactionCollectionViewCell.self, forCellWithReuseIdentifier: TransactionCollectionViewCell.id)
        collectionView.register(WalletHeaderCollectionViewCell.self, forCellWithReuseIdentifier: WalletHeaderCollectionViewCell.id)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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

    private func setup() {
        addActionBar()
        addCollectionView()
        view.bringSubviewToFront(actionBar)
    }
    
    private func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: actionBar.topAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    private func addActionBar() {
        view.addSubview(actionBar)
        actionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        actionBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        actionBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        actionBar.heightAnchor.constraint(equalToConstant: CGFloat(Dimens.bar)).isActive = true
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.section == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalletHeaderCollectionViewCell.id, for: indexPath) as! WalletHeaderCollectionViewCell
            cell.currencyView.title = "100" // TODO
            cell.amountLabel.text = "123 bitcoins"
            cell.addressButtonClick = {
                Navigator.showOnChainAddress(self)
            }
            cell.maxWidth = collectionView.frame.width
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCollectionViewCell.id, for: indexPath) as! TransactionCollectionViewCell
            cell.textView.text = exampleTransactions[indexPath.row]
            cell.maxWidth = collectionView.frame.width
            return cell
        }
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

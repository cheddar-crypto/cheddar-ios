//
//  HomeViewController.swift
//  wallet
//
//  Created by Jason van den Berg on 2020/08/18.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import UIKit

class HomeViewController: CheddarViewController<HomeViewModel> {
    
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
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var collectionView: UICollectionView = {
        
        // Create the layout
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(WalletHeaderCollectionViewCell.cellHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        // Create the collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delaysContentTouches = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TransactionCollectionViewCell.self, forCellWithReuseIdentifier: TransactionCollectionViewCell.id)
        collectionView.register(WalletHeaderCollectionViewCell.self, forCellWithReuseIdentifier: WalletHeaderCollectionViewCell.id)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        return collectionView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarStyles()
        
        // Reset the navigation bar if needed
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            let topSafeArea = window.safeAreaInsets.top
            let navBar = navigationController?.navigationBar
            if (navBar?.frame.origin.y != topSafeArea) {
                UIView.animate(withDuration: 0.2, animations: {
                    navBar?.frame.origin.y = topSafeArea
                })
            }
        }
        
    }
    
    override func viewModelDidLoad() {
            
        viewModel.isLoading.observe = { [weak self] isLoading in
            if (isLoading && !(self?.refreshControl.isRefreshing ?? true)) {
                self?.showLoadingView()
            }
        }
        
        viewModel.price.observe = { [weak self] price in
            self?.refreshPrice(price)
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.transactions.observe = { [weak self] transaction in
            self?.visibleCells.removeAll()
            self?.collectionView.reloadData()
            self?.showContentView()
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.error.observe = { [weak self] error in
            self?.showErrorView()
            self?.refreshControl.endRefreshing()
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
    
    @objc private func refresh() {
        // TODO
        print("Pull to refresh triggered")
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
    
    // MARK: Cell Refreshing
    // This is for handling realtime price updates
    
    private var visibleCells: [IndexPath] = []
    
    private func cacheIndexPath(_ indexPath: IndexPath) {
        if (!visibleCells.contains(indexPath)) {
            visibleCells.append(indexPath)
        }
    }
    
    private func unchacheIndexPath(_ indexPath: IndexPath) {
        visibleCells = visibleCells.filter { $0 != indexPath }
    }
    
    // Update all the visible cells with the current price
    private func refreshPrice(_ price: Price) {
        visibleCells.forEach { indexPath in
            let cell = collectionView.cellForItem(at: indexPath)
            
            // Wallet cell
            if let walletCell = cell as? WalletHeaderCollectionViewCell {
                walletCell.updatePrice(price)
            }
            
            // Transaction cells
            if let txCell = cell as? TransactionCollectionViewCell {
                txCell.updatePrice(price)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cacheIndexPath(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        unchacheIndexPath(indexPath)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.section == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalletHeaderCollectionViewCell.id, for: indexPath) as! WalletHeaderCollectionViewCell
            if let wallet = viewModel.wallet.value, let price = viewModel.price.value {
                cell.setWallet(wallet, price: price)
            }
            cell.addressButtonClick = {
                Navigator.showOnChainAddress(self)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCollectionViewCell.id, for: indexPath) as! TransactionCollectionViewCell
            if let txs = viewModel.transactions.value, let price = viewModel.price.value {
                cell.setTransaction(txs[indexPath.row], price: price)
            }
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
        return section == 1 ? viewModel.transactions.value?.count ?? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
}

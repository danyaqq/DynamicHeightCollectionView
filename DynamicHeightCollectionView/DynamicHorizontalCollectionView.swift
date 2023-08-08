//
//  DynamicHorizontalCollectionView.swift
//  DynamicHeightCollectionView
//
//  Created by Даниил Орлов on 08.08.2023.
//

import UIKit

protocol DynamicHorizontalCollectionViewDelegate: AnyObject {
    func didChangeCurrentIndexPath(
        _ collectionView: UICollectionView,
        currentIndexPath: IndexPath
    )
}

class DynamicHorizontalCollectionView: UICollectionView {
    
    // MARK: - Public properties
    
    weak var viewDelegate: DynamicHorizontalCollectionViewDelegate?
    
    // MARK: - Private properties
    
    private var data: [String] = []
    private var currentIndexPath = IndexPath(row: 0, section: 0)
    
    // MARK: - Init
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = Self.createFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods

    func update(with data: [String]) {
        self.data = data
        reloadData()
    }
    
    func updateHeight() {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: DynamicHeightCollectionViewCell.identifier,
            for: currentIndexPath
        ) as? DynamicHeightCollectionViewCell else { return }
        
        let text = data[currentIndexPath.row]
        let height = cell.calculateHeight(width: frame.size.width, text: text)
        
        collectionViewLayout.invalidateLayout()
        
        snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension DynamicHorizontalCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        data.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DynamicHeightCollectionViewCell.identifier,
            for: indexPath
        ) as? DynamicHeightCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: data[indexPath.row])
        
        return cell
    }
}

extension DynamicHorizontalCollectionView: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = contentOffset
        visibleRect.size = bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = indexPathForItem(at: visiblePoint),
              currentIndexPath != indexPath else {
            return
        }

        currentIndexPath = indexPath
        
        updateHeight()
        
        viewDelegate?.didChangeCurrentIndexPath(self, currentIndexPath: currentIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

// MARK: - Private properties

private extension DynamicHorizontalCollectionView {
    static func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return layout
    }
    
    func setupCollectionView() {
        backgroundColor = .white
        isPagingEnabled = true
        delegate = self
        dataSource = self
        register(
            DynamicHeightCollectionViewCell.self,
            forCellWithReuseIdentifier: DynamicHeightCollectionViewCell.identifier
        )
    }
}

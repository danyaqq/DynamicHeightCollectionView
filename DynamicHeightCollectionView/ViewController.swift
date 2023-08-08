//
//  ViewController.swift
//  DynamicHeightCollectionView
//
//  Created by Даниил Орлов on 07.08.2023.
//

import UIKit
import SnapKit

private let sample = [
    "asjdlasjdk jndsa kjhnlads kjnsadn kjadsn kjdsan jkdsa kjndk asjnn kadsjn kjsdan kjadskn jdasn kjdasn kjdasnk jads asjdlasjdk jndsa kjhnlads kjnsadn kjadsn kjdsan jkdsa kjndk asjnn kadsjn kjsdan kjadskn jdasn kjdasn kjdasnk jads asjdlasjdk jndsa kjhnlads kjnsadn kjadsn kjdsan jkdsa kjndk asjnn kadsjn kjsdan kjadskn jdasn kjdasn kjdasnk jads",
    "qewadsk nasd khjnasd hkjnasd jknhasd kjndsakn jsadn kjadsn kjadskn jdkans jdnk ajs",
    "io dfgsoiundfgi hudgf ihud fghiuod fghiouh idofgj",
    "sdf sdf kadsnk jsad nklasdn kads nkladsn kadsn ldans lkadsn ln das ndasl ndaskl",
    "asjdsdf sdfsdflasjdasdkj  lkadsjnadsk las dklm dlaksm dalskm dmaskl adksml dmalsk lkmads kmlads"
]

final class ViewController: UIViewController {

    // MARK: - UI properties
    
    private let scrollView = UIScrollView()
    private let containerView = UIStackView()
    private let yellowSquareView = UIView()
    private let collectionView = DynamicHorizontalCollectionView()
    private let squareView = UIView()
    private let titleLabel = UILabel()
    private let blueSquareView = UIView()
    private let greenSquareView = UIView()
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        fetchData { [weak self] data in
            self?.collectionView.update(with: sample)
            self?.collectionView.updateHeight()
            
            let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) {
                self?.collectionView.isHidden = false
                self?.view.layoutIfNeeded()
            }
            animator.startAnimation()
        }
    }
}

// MARK: - DynamicHorizontalCollectionViewDelegate

extension ViewController: DynamicHorizontalCollectionViewDelegate {
    func didChangeCurrentIndexPath(
        _ collectionView: UICollectionView,
        currentIndexPath: IndexPath
    ) {
        let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) {
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
}

// MARK: - Setup UI

private extension ViewController {
    func setupUI() {
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        setupContainerView()
        setupSquares()
        setupTitleLabel()
        setupCollectionView()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addArrangedSubview(yellowSquareView)
        containerView.addArrangedSubview(collectionView)
        containerView.addArrangedSubview(squareView)
        containerView.addArrangedSubview(titleLabel)
        containerView.addArrangedSubview(blueSquareView)
        containerView.addArrangedSubview(greenSquareView)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.bottom.width.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.centerY.equalToSuperview().priority(.low)
            make.horizontalEdges.width.equalToSuperview()
        }
        
        yellowSquareView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(212)
        }
        
        collectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(400)
        }
        
        squareView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(212)
        }
        
        blueSquareView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(212)
        }
        
        greenSquareView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(212)
        }
    }
    
    func setupContainerView() {
        containerView.axis = .vertical
    }
    
    func setupSquares() {
        yellowSquareView.backgroundColor = .yellow
        squareView.backgroundColor = .red
        blueSquareView.backgroundColor = .blue
        greenSquareView.backgroundColor = .green
    }
    
    func setupTitleLabel() {
        titleLabel.text = "askldjasldj aljsd jikasd iojas dijoa sijohd jiaosd iojakjl  adkljs"
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 14)
    }
    
    func setupCollectionView() {
        collectionView.viewDelegate = self
        collectionView.isHidden = true
    }
}

// MARK: - Private properties

private extension ViewController {
    func fetchData(_ completion: @escaping (([String]) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(sample)
        }
    }
}

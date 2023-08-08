//
//  DynamicHeightCollectionViewCell.swift
//  DynamicHeightCollectionView
//
//  Created by Даниил Орлов on 08.08.2023.
//

import UIKit
import SnapKit

private let INSET: CGFloat = 10
private let SQUARE_HEIGHT: CGFloat = 80

final class DynamicHeightCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DynamicHeightCollectionViewCell"
    
    // MARK: - UI properties
    
    private let containerView = UIView()
    private let squareView = UIView()
    private let titleLabel = UILabel()
    private let spacer = UIView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    // MARK: - Public methods
    
    func configure(with text: String) {
        titleLabel.text = text
    }
    
    func calculateHeight(width: CGFloat, text: String) -> CGFloat {
        let insets = INSET * 2
        let textHeight = text.height(
            withConstrainedWidth: width,
            font: titleLabel.font
        )
        return insets + SQUARE_HEIGHT + textHeight
    }
}

// MARK: - Private methods

private extension DynamicHeightCollectionViewCell {
    func setupUI() {
        addSubviews()
        setupConstraints()
        setupContainerView()
        setupSquareView()
        setupTitleLabel()
    }
    
    func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(squareView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(spacer)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        squareView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(SQUARE_HEIGHT)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(squareView.snp.bottom).offset(INSET)
            make.horizontalEdges.equalToSuperview().inset(INSET)
            make.bottom.equalTo(spacer.snp.top).priority(.low)
        }
        
        spacer.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(INSET)
        }
    }
    
    func setupContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 10
        containerView.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupSquareView() {
        squareView.backgroundColor = .blue
    }
    
    func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.contentMode = .top
    }
}

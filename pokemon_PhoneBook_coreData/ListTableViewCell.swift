//
//  ListTableViewCell.swift
//  pokemon_PhoneBook_coreData
//
//  Created by 임혜정 on 7/11/24.
//

import UIKit
import SnapKit

class ListTableViewCell: UITableViewCell {
    static let id = "TableViewCell"
    
    private let previewImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.layer.borderWidth = 1
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.layer.borderWidth = 1
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        label.layer.borderWidth = 1
        return label
    }()
    
    // 추가버튼 클릭 화면 전환
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupListLayout()
    }
    
    // MARK: ------------------------ Auto Layout ------------------------
    private func setupListLayout() {
        [previewImage, nameLabel, phoneNumberLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        previewImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(previewImage.snp.trailing).offset(20)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    public func configureListCell(with phoneBook: PhoneBook) {
        nameLabel.text = phoneBook.name
        phoneNumberLabel.text = phoneBook.phoneNumber
        
        // 이미지 캐싱. 불러오기
        if let imageURLString = phoneBook.imageURL, let imageURL = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                if let error = error {
                    print("\(error)")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Invalid image data")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.previewImage.image = image
                }
            }.resume()
        } else {
            // 기본 이미지 설정
            previewImage.image = UIImage(named: "sun.fill")
        }
    }
    

}

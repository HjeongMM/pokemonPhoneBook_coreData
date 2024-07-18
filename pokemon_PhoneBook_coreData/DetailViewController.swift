//
//  DetailViewController.swift
//  pokemon_PhoneBook_coreData
//
//  Created by 임혜정 on 7/11/24.
//

import UIKit
import SnapKit
import CoreData

class DetailViewController: UIViewController {
    
    var container: NSPersistentContainer!
    var randomImageURL: String?
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        return button
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 100
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var randomImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(loadRandomImage), for: .touchUpInside)
        return button
    }()
    
    private let nameTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .black
        textView.layer.borderWidth = 1
        return textView
    }()
    
    private let phoneNumberTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .black
        textView.layer.borderWidth = 1
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "연락처 추가"
        detailConfigureUI()
        configureNavigationBar2()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
    }
    
    @objc private func saveProfile() {
        guard let name = nameTextView.text, !name.isEmpty,
              let phoneNumber = phoneNumberTextView.text, !phoneNumber.isEmpty,
              let imageURL = randomImageURL else {
            showAlert(message: "모든 칸을 입력하세요")
            return
        }
        createData(name: name, phoneNumber: phoneNumber, imageURL: imageURL)
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    // 데이터 create
    func createData(name: String, phoneNumber: String, imageURL: String) {
        let context = container.viewContext
        let newPhoneBook = PhoneBook(context: context)
        newPhoneBook.name = name
        newPhoneBook.phoneNumber = phoneNumber
        newPhoneBook.imageURL = imageURL

        do {
            try context.save()
            print("저장 완료")
        } catch {
            print("\(error)")
        }
    }

    
    // 데이터 read
    func readAllData() {
        let request: NSFetchRequest<PhoneBook> = PhoneBook.fetchRequest()
        
        do {
            let phoneBooks = try container.viewContext.fetch(request)
            
            for phoneBook in phoneBooks {
                if let name = phoneBook.name,
                   let phoneNumber = phoneBook.phoneNumber,
                   let imageURL = phoneBook.imageURL {
                    print("Name: \(name), Phone Number: \(phoneNumber), Image URL: \(imageURL)")
                }
            }
        } catch {
            print("\(error)")
        }
    }
    
    // 데이터 update
    
//    func updateData(currentName: String, updateName: String, currentPhoneNumber: String, updatePhoneNumber: String) {
//        // 데이터 수정
//        let fetchRequest = PhoneBook.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@", currentName)
//        fetchRequest.predicate = NSPredicate(format: "phoneNumber == %@", currentPhoneNumber)
//        do {
//            let result = try self.container.viewContext.fetch(fetchRequest)
//            
//            for data in result as [NSManagedObject] {
//                data.setValue(updateName, forKey: PhoneBook.Key.name)
//                data.setValue(updatePhoneNumber, forKey: PhoneBook.Key.phoneNumber)
//                try self.container.viewContext.save()
//                print("데이터 수정 완료")
//            }
//        } catch {
//            print("데이터 수정 실패")
//        }
//    }
//    
//    // 데이터 delete
//    func deleteData(name: String) {
//        let fetchRequest = PhoneBook.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
//        
//        do {
//            let result = try self.container.viewContext.fetch(fetchRequest)
//            
//            for data in result as [NSManagedObject] {
//                self.container.viewContext.delete(data)
//                print("삭제됨 : \(data)")
//            }
//            try self.container.viewContext.save()
//            print("삭제완료")
//        } catch {
//            print("삭제실패\(error)")
//        }
//    }
    
    private func detailConfigureUI() {
        [saveButton,
         profileImage,
         randomImageButton,
         nameTextView,
         phoneNumberTextView].forEach {
            self.view.addSubview($0)
        }
        
        saveButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        
        randomImageButton.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        nameTextView.snp.makeConstraints {
            $0.top.equalTo(randomImageButton.snp.bottom).offset(20)
            $0.width.equalTo(250)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        
        phoneNumberTextView.snp.makeConstraints {
            $0.top.equalTo(nameTextView.snp.bottom).offset(10)
            $0.width.equalTo(250)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configureNavigationBar2() {
        let barButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = barButtonItem
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("\(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.profileImage.image = image
            }
        }.resume()
    }
    
    @objc private func loadRandomImage() {
        let randomId = Int.random(in: 1...1000)
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(randomId)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("\(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let userData = try JSONDecoder().decode(UserData.self, from: data)
                self?.randomImageURL = userData.sprites.frontDefault
                self?.loadImage(from: userData.sprites.frontDefault)
            } catch let jsonError {
                print("\(jsonError)")
            }
        }.resume()
    }
}

// MARK: - 모델 나중에 분리할거
struct UserData: Codable {
    let sprites: Sprites
}

struct Sprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

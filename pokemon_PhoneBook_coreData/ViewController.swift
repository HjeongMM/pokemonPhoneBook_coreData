//
//  ViewController.swift
//  pokemon_PhoneBook_coreData
//
//  Created by 임혜정 on 7/11/24.
//

import UIKit
import SnapKit
import CoreData


class ViewController: UIViewController {
    var container: NSPersistentContainer!
    var phoneBooks: [PhoneBook] = []
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(detailView), for: .touchDown)
        return button
    }()
    
    private lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
        view.backgroundColor = .white
        title = "친구 목록"
        
        configureUI()
        configureNavigationBar()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        listTableView.delegate = self
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPhoneBooks()
    }
    
    private func fetchPhoneBooks() {
        let request: NSFetchRequest<PhoneBook> = PhoneBook.fetchRequest()
        
        //항상 이름 기준 정렬
        let sortedName = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortedName]
        
        do {
            phoneBooks = try container.viewContext.fetch(request)
            listTableView.reloadData()
        } catch {
            print("\(error)")
        }
    }
    
    //네비게이션 커스텀
    private func configureNavigationBar() {
        let barButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = barButtonItem
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    // MARK: ------------------------ Auto Layout ------------------------
    private func configureUI() {
        view.backgroundColor = .white
        [addButton, listTableView].forEach {
            view.addSubview($0)
        }

        addButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(50)
        }

        listTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(30)
        }
    }
    
    @objc private func detailView() {
        let detailViewController = DetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoneBook = phoneBooks[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.phoneBook = selectedPhoneBook
        detailViewController.isEditingMode = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id) as? ListTableViewCell else { return UITableViewCell() }
        let phoneBook = phoneBooks[indexPath.row]
        cell.configureListCell(with: phoneBook)
        return cell
    }
}

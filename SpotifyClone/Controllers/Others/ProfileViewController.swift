//
//  ProfileViewController.swift
//  SpotifyClone
//
//  Created by Berkay Unal on 13.11.2023.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchProfile()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        title = "Profile"
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    private func fetchProfile() {
        
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let model):
                self?.updateUI(with: model)
            case .failure(let error):
//                print(error.localizedDescription)
                self?.failedToGetProfile()
            }
        }
    }
    
    private func updateUI(with model: UserProfile) {
        
        DispatchQueue.main.sync {
            tableView.isHidden = false
        }
        models.append("Full \(model.display_name)")
        models.append("Email address: \(model.email)")
        models.append("User id: \(model.id)")
        models.append("Plan: \(model.product)")
        createTableHeader(with: model.images.first?.url)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func createTableHeader(with string: String?) {
        
        guard let urlString = string, let url = URL(string: urlString) else { return }
            
        DispatchQueue.main.async {
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.width/1.5))
            let imageSize: CGFloat = headerView.height/2
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
            headerView.addSubview(imageView)
            imageView.center = headerView.center
            imageView.contentMode = .scaleAspectFit
            imageView.sd_setImage(with: url, completed: nil)
            self.tableView.tableHeaderView = headerView
        }
    }
    
    private func failedToGetProfile() {
        
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        self.view.addSubview(label)
        label.center = self.view.center
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

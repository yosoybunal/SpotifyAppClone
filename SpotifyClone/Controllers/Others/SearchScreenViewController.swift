//
//  SearchScreenViewController.swift
//  SpotifyClone
//
//  Created by Berkay Unal on 13.11.2023.
//

import UIKit

struct SearchSection {
    
    let title: String
    let results: [SearchResults]
    
}

protocol SearchScreenViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResults)
}

class SearchScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SearchScreenViewControllerDelegate?
    
    private var sections: [SearchSection] = []
    
    private var tableView = {
       
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results: [SearchResults]) {
        
        let artists = results.filter ({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        let albums = results.filter ({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        let tracks = results.filter ({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        let playlists = results.filter ({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Albums", results: albums)
        ]
        
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let result = sections[indexPath.section].results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch result {
        case .album(let model):
            cell.textLabel?.text = model.name
        case .artist(let model):
            cell.textLabel?.text = model.name
        case .playlist(let model):
            cell.textLabel?.text = model.name ?? "-"
        case .track(let model):
            cell.textLabel?.text = model.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = sections[indexPath.section].results[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didTapResult(result)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
}

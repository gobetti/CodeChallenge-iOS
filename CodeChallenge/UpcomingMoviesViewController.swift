//
//  UpcomingMoviesViewController.swift
//  CodeChallenge
//
//  Created by Marcelo Gobetti on 10/27/16.
//

import UIKit
import RxCocoa
import RxSwift

final class UpcomingMoviesViewController: UIViewController {
    private lazy var tmdbModel = TMDBModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Elements
    private let collectionView = UICollectionView(frame: CGRect.zero,
                                                  collectionViewLayout: UpcomingMoviesFlowLayout())
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.setupContent()
    }
    
    // MARK: - Private methods
    private func setupContent() {
        self.collectionView.backgroundColor = .clear
        self.collectionView.register(cellType: UpcomingMovieCell.self)
        self.view.addSubview(self.collectionView)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        self.tmdbModel.upcomingMovies()
            .asObservable() // temporary hack to allow `bind`
            .bind(to: self.collectionView.rx.items(cellType: UpcomingMovieCell.self)) { (_, movie, cell) in
                cell.titleLabel.text = movie.name
                cell.releaseDateLabel.text = DateFormatter.localizedString(from: movie.releaseDate,
                                                                           dateStyle: .medium,
                                                                           timeStyle: .none)
            }.disposed(by: self.disposeBag)
    }
}

private class UpcomingMoviesFlowLayout: UICollectionViewFlowLayout {
    override var itemSize: CGSize {
        get { return CGSize(width: UIScreen.main.bounds.width, height: 55) }
        set {}
    }
}

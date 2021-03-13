//
//  HomeView.swift
//  BCAppMovie
//
//  Created by Cesar Velasquez on 13/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeView: UIViewController {

    private var viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()
    private var movies = [Movie]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        self.getData()
    }

    private func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "CustomMovieCell", bundle: nil), forCellReuseIdentifier: "CustomMovieCell")
        tableView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func getData() {
        return viewModel.gestListMoviesData()
            .subscribeOn(MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { movies in
                    self.movies = movies
                    self.reloadTableView()
            }, onError: { error in
                print(error.localizedDescription)
            }, onCompleted: {
            }).disposed(by: disposeBag)
        //Dar por completado la secuencia de RxSwift
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMovieCell") as! CustomMovieCell
        cell.imageMovie.imageFromServerURL(urlString: "\(Constants.URL.urlImages+self.movies[indexPath.row].image)", placeHolderImage: UIImage(named: "background")!)
        cell.titleMovie.text = movies[indexPath.row].title
        cell.descriptionMovie.text = movies[indexPath.row].sinopsis
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

   //         viewModel.makeDetailView(movieID: String(self.movies[indexPath.row].movieID))

    }
}


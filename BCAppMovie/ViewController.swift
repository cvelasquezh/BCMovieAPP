//
//  ViewController.swift
//  BCAppMovie
//
//  Created by Cesar Velasquez on 12/03/21.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {

    private var viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()
    private var movies = [Movie]()
    private var filteredMovies = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        return viewModel.gestListMoviesData()
        //Manejar la concurrencia o hilos de RxSwift
            .subscribeOn(MainScheduler.instance)
        .observeOn(MainScheduler.instance)
        //Suscríbirme a el observable
            .subscribe(
                onNext: { movies in
                    self.movies = movies
                    print("ok ok ok")

                   // self.reloadTableView()
            }, onError: { error in
                print(error.localizedDescription)
            }, onCompleted: {
            }).disposed(by: disposeBag)
    }


}


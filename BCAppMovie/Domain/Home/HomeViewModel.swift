//
//  HomeViewModel.swift
//  BCAppMovie
//
//  Created by Cesar Velasquez on 13/03/21.
//

import Foundation
import RxSwift
class HomeViewModel{
    
    private weak var view: HomeView?
    private var router: HomeRouter?
    private var managerConnection = HomeApiManager()
    
     
    func gestListMoviesData() -> Observable<Movies> {
        return managerConnection.getPopularMovies()
    }
    
    func bind(view: HomeView, router: HomeRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func makeDetailView(movieID: String) {
        router?.navigateToDetailView(movieID: movieID)
    }
}

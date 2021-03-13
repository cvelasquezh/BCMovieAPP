//
//  HomeViewModel.swift
//  BCAppMovie
//
//  Created by Cesar Velasquez on 13/03/21.
//

import Foundation
import RxSwift
class HomeViewModel{
    private var managerConnection = HomeApiManager()
    
    func gestListMoviesData() -> Observable<[Movie]> {
        return managerConnection.getPopularMovies()
    }
}

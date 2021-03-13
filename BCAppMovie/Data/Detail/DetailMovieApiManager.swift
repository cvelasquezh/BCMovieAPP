//
//  DetailMovieApiManager.swift
//  BCAppMovie
//
//  Created by Cesar Velasquez on 13/03/21.
//

import Foundation
import RxSwift

class DetailMovieApiManager {
    
    func getDetailMovies(movideID: String) -> Observable<MovieDetail> {
        return Observable.create { observer in
            
            let session = URLSession.shared
            var request = URLRequest(url: URL(string: Constants.URL.main+Constants.Endpoints.urlDetailMovie+movideID+Constants.apiKey)!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            session.dataTask(with: request) { (data, response, error) in
                
                guard let data = data, error == nil, let response = response as? HTTPURLResponse else { return }
                
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let detailMovie = try decoder.decode(MovieDetail.self, from: data)
                        observer.onNext(detailMovie)
                    } catch let error{
                        observer.onError(error)
                        print("Ha ocurrido un error: \(error.localizedDescription)")
                    }
                }
                else if response.statusCode == 401 {
                    print("Error 401")
                }
                observer.onCompleted()
            }.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
        }
    }
    
    func getImageFromServer(urlString: String) -> Observable<UIImage> {
        
        return Observable.create { observer in
            
            let placeHolderImage = UIImage(named: "background")!
            
            URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
                
                guard let data = data, error == nil, let response = response as? HTTPURLResponse else { return }
                
                if error != nil {
                    print(error ?? "No Error")
                    return
                }
                
                if response.statusCode == 200 {
                        guard let image = UIImage(data: data) else { return }
                        observer.onNext(image)
                } else {
                    observer.onNext(placeHolderImage)
                }
                //MARK: observer onCompleted event
                observer.onCompleted()
                
            }).resume()
            
            //MARK: return our disposable
            return Disposables.create {}
        }
    }
}

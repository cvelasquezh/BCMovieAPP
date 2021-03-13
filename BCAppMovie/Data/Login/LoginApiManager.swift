//
//  LoginApiManager.swift
//  BCAppMovie
//
//  Created by Cesar Velasquez on 13/03/21.
//

import Foundation
import RxSwift

class LoginApiManager {
    
    func getToken() -> Observable<TokenEntity>{
        return Observable.create { observer in
            
            let session = URLSession.shared
            var request = URLRequest(url: URL(string: Constants.URL.main+Constants.Endpoints.urlTokenNew+Constants.apiKey)!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            session.dataTask(with: request) { (data, response, error) in
                
                guard let data = data, error == nil, let response = response as? HTTPURLResponse else { return }
                
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let tokenEntity = try decoder.decode(TokenEntity.self, from: data)
                        observer.onNext(tokenEntity)
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
    
    
    
    func login(user: UserEntity) -> Observable<TokenEntity> {
        return Observable.create { observer in
            
            let session = URLSession.shared
            var request = URLRequest(url: URL(string: Constants.URL.main+Constants.Endpoints.urValidateWithLogin+Constants.apiKey)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let data =  try? JSONEncoder().encode(user)
            request.httpBody = data
            session.dataTask(with: request) { (data, response, error) in
                
                guard let data = data, error == nil, let response = response as? HTTPURLResponse else { return }
                
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let tokenEntity = try decoder.decode(TokenEntity.self, from: data)
                        observer.onNext(tokenEntity)
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
}

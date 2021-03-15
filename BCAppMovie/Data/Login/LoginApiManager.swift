//
//  LoginApiManager.swift
//  BCAppMovie
//
//  Created by Cesar Velasquez on 13/03/21.
//

import Foundation
import RxSwift

class LoginApiManager: BaseApiManager<TokenEntity,Error> {
    
    func getToken() -> Observable<TokenEntity> {
        self.urlPath = Constants.URL.main+Constants.Endpoints.urlTokenNew+Constants.apiKey
        self.httpMethod = HTTPMehod.GET
        createRequest()
        return requestToService()
    }
    
    func login(user: UserEntity) -> Observable<TokenEntity> {
        self.urlPath = Constants.URL.main+Constants.Endpoints.urValidateWithLogin+Constants.apiKey
        self.httpMethod = .POST
        addBody(user)
        createRequest()
        return requestToService()
    }
}

//
//  LoginView.swift
//  BCAppMovie
//
//  Created by Cesar Velasquez on 13/03/21.
//

import UIKit
import RxSwift
import ProgressHUD
class LoginView: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var viewModel = LoginViewModel()
    private var loginRouter = LoginRouter()
    private var disposeBag = DisposeBag()
    private var tokenEntity: TokenEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: loginRouter)
    }

    func getToken(){
        ProgressHUD.show()
        return viewModel.getToken()
            .subscribe(
                onNext: { tokenEntity in
                    self.tokenEntity = tokenEntity
                    print("SE obtuvo token")
                    DispatchQueue.main.async {
                        self.setLogin()
                    }

            }, onError: { error in
                print(error.localizedDescription)
                print("SE obtuvo error en token")

            }, onCompleted: {
                ProgressHUD.dismiss()
            }).disposed(by: disposeBag)
    }
    
    func setLogin(){
        return viewModel.loginWithUser(user: UserEntity(username: userTextField.text!, password: passwordTextField.text!, request_token: self.tokenEntity?.request_token!))
            .subscribe(
                onNext: { tokenEntity in
                    print("SESSION INICIADA")
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                        self.loginRouter.navigateToHomeView()
                        
                    }
            }, onError: { error in
                print(error.localizedDescription)
                ProgressHUD.dismiss()

                print("SE obtuvo error iniciando sesion")

            }, onCompleted: {
                ProgressHUD.dismiss()

            }).disposed(by: disposeBag)
    }
        
    @IBAction func onStartSession(_ sender: Any) {
        self.getToken()
    }
}
        

//
//  RegistrationViewController.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright (c) 2020 Юрий Султанов. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol RegistrationDisplayLogic: class {
    func displayCheckUserName(viewModel: Registration.CheckUserName.ViewModel)
    func displayRegisterUser(viewModel: Registration.RegistrationUser.ViewModel)
}

final class RegistrationViewController: UIViewController, CustomableView {
    typealias RootView = RegistrationView
    
    // MARK: - Private Properties
    private let interactor: RegistrationBusinessLogic
    private var state: Registration.ViewControllerState
    
    // MARK: - Object Lifecycle
    init(interactor: RegistrationBusinessLogic, initialState: Registration.ViewControllerState = .initial) {
        self.interactor = interactor
        self.state = initialState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func loadView() {
        let view = RegistrationView(frame: UIScreen.main.bounds)
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.isSecuredScreen = true
        configureNavController()
    }
    
    // MARK: - Private Methods
    private func checkUser() {
        guard let login = view().loginTextField.text,
            !login.isEmpty else {
                view().showLoginError(text: "Required field")
                return }
        let request = Registration.CheckUserName.Request(login: login)
        interactor.checkUser(request: request)
    }
    
    private func registerUser() {
        guard let login = view().loginTextField.text,
            let password = view().passwordTextField.text,
            !password.isEmpty else {
                view().showPasswordError(text: "Required field")
                return }
        let request = Registration.RegistrationUser.Request(login: login,
                                                            password: password,
                                                            userAvatar: view().avatarPicker.backgroundImage(for: .normal))
        interactor.registerUser(request: request)
    }
    
    private func configureNavController() {
        title = "Registration"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func success(userID: Int) {
        UserDefaults.standard.isLoginedUserID = userID
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func authorizeToCamera(completion: @escaping (Bool) -> Void ) {
      if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
        AVCaptureDevice.requestAccess(for: .video) { (status) in
          DispatchQueue.main.async(execute: {
            completion(status == true)
          })
        }
      } else {
        completion(true)
      }
    }
    
    private func presentCameraPickerController() {
        authorizeToCamera { [weak self] (authorized) in
            if authorized {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                picker.cameraCaptureMode = .photo
                picker.cameraDevice = .front
                picker.allowsEditing = true
                self?.present(picker, animated: true)
            } else {
                let goToSettings = UIAlertAction(title: "Open settings", style: .default) { _ in
                    let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(settingsUrl)
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                
                let actionController = UIAlertController(title: "Camera unavailable!",
                                                         message: "You shoud switch camera access at settings before use it",
                                                         preferredStyle: .actionSheet)
                actionController.addAction(goToSettings)
                actionController.addAction(cancel)
            }
        }
    }
    
    private func authorizeToPhotoLibrary(completion: @escaping (Bool) -> Void ) {
        if PHPhotoLibrary.authorizationStatus() != .authorized {
        PHPhotoLibrary.requestAuthorization({ (status) in
          DispatchQueue.main.async(execute: {
            completion(status == .authorized)
          })
        })
      } else {
        completion(true)
      }
    }
    
    private func presentImagePickerController() {
        authorizeToPhotoLibrary { [weak self] (authorized) in
            guard let self = self else { return }
            if authorized {
                let picker: UIImagePickerController = {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                    return picker
                }()
                self.present(picker, animated: true)
            } else {
                let goToSettings = UIAlertAction(title: "Open settings",
                                                 style: .default) { _ in
                                                    let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
                                                    UIApplication.shared.open(settingsUrl)
                }
                let cancel = UIAlertAction(title: "Cancel",
                                           style: .cancel)
                
                let actionController = UIAlertController(title: "Library access denied!",
                                                         message: "You shoud switch library access at settings before use it",
                                                         preferredStyle: .actionSheet)
                actionController.addAction(goToSettings)
                actionController.addAction(cancel)
            }
        }
    }
    
    private func avatarOptionsAlert() {
        let makePhoto = UIAlertAction(title: "Make photo",
                                      style: .default) { [weak self] _ in
                                        guard let self = self else { return }
                                        self.presentCameraPickerController()
        }
        
        let choosePhoto = UIAlertAction(title: "Choose photo",
                                        style: .default) { [weak self] _  in
                                            guard let self = self else { return }
                                            self.presentImagePickerController()
        }
        
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .cancel)
        let actions = [makePhoto, choosePhoto, cancel]
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
}

// MARK: - Display Logic
extension RegistrationViewController: RegistrationDisplayLogic {
    func displayCheckUserName(viewModel: Registration.CheckUserName.ViewModel) {
        display(newState: viewModel.state)
    }
    
    func displayRegisterUser(viewModel: Registration.RegistrationUser.ViewModel) {
        display(newState: viewModel.state)
    }
    
    func display(newState: Registration.ViewControllerState) {
        state = newState
        switch state {
        case .initial:
            break
        case .success(let userID):
            success(userID: userID)
        case .registration:
            registerUser()
        case .failure(let error):
            switch error {
            case .userExists:
                view().showLoginError(text: "User exists")
            case .somethingGoneWrong:
                print("some error")
            }
        }
    }
}

// MARK: - View Delegate
extension RegistrationViewController: RegistrationViewDelegate {
    func didTapPickAvatar() {
        avatarOptionsAlert()
    }
    
    func didTapRegister() {
        checkUser()
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
    view().photoIcon.isHidden = true
    view().avatarPicker.setBackgroundImage(image, for: .normal)
    view().avatarPicker.layer.cornerRadius = view().avatarPicker.frame.height / 2
    dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
}

//
//  APIManager.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/14/21.
//

import UIKit
import Combine
import Alamofire

protocol NetworkService {
    func isTokenValid() -> Bool
    func refreshAccessToken(completion: @escaping (() -> Void))
    func fetch<T: Decodable>( at endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void)
}

class APIService: NetworkService {
    
    private static var token: String {
        get { UserDefaults.standard.string(forKey: Keys.tokenKey) ?? "" }
        set {  UserDefaults.standard.setValue(newValue, forKey: Keys.tokenKey) }
    }
    
    private static var tokenExpirationDate: Date {
        get { UserDefaults.standard.object(forKey: Keys.tokenExpiration) as? Date ?? Date() }
        set { UserDefaults.standard.set(newValue, forKey: Keys.tokenExpiration) }
    }
    
    //MARK: - Methods
    
    static func signIn(username: String, password: String, completion: @escaping ((Result<Patient, Error>) -> Void)) {
        let json: [String: Any] = [
            "username": username,
            "password": password,
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: EndPoint.logInPath.path)!
        let method = "POST"
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print("\(#function) - response: \(response.statusCode)")
            }
            if error != nil {
                print("\(#function) - Error: \(error!.localizedDescription)")
                completion(.failure(error!))
            }
            if let userData = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: userData, options: .mutableContainers) as? [String: Any] {
                        print("JSON received = ", json)
                        if let passwordError = json["password"] as? [String] {
                            //Example error = ["password": "This password is too common"]
                            print("PASSWORD ERROR \(passwordError)")
                        }
                        if let emailError = json["email"] as? [String] {
                            //Example error = ["email": "This field must be unique"]
                            print("EMAIL ERROR \(emailError)")
                        }
                        if let errors = json["error"] as? [String] {
                            print("Sign In ERROR \(errors)")
                        }
                        // handle json...
                    }
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase  //convert keys from snake case to camel case
                    let loginResponse = try decoder.decode(LogInResponse.self, from: userData)
                    self.updateToken(newToken: loginResponse.token, expiration: loginResponse.expiresIn)
                    completion(.success(loginResponse.getAsPatient()))
                } catch let error {
                    print("❌ \(#function) - Decoding error: \(error)\nsignIn error: \(String(decoding: userData, as: UTF8.self))")
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    static func signUp(email: String, username: String, password: String, password2: String, completion: @escaping ((Result<Patient, Error>) -> Void)) {
        let json: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "password2": password2
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: EndPoint.signUpPath.path)!
        let method = "POST"
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print("\(#function) - response: \(response.statusCode)")
            }
            if error != nil {
                print("\(#function) - Error: \(error!.localizedDescription)")
            }
            if let userData = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase  //convert keys from snake case to camel case
                do {
//                    let object = try decoder.decode(TokenResponse.self, from: tokenData)
//                    self.token = object.access_token
//                    let date = Date().addingTimeInterval(TimeInterval(object.expires_in))
//                    print("\ntoken local expiration date: \(date)")
//                    self.tokenExpirationDate = date
                    if let json = try JSONSerialization.jsonObject(with: userData, options: .mutableContainers) as? [String: Any] {
                        print("JSON received = ", json)
                        if let passwordError = json["password"] as? [String] {
                            //Example error = ["password": "This password is too common"]
                            print("PASSWORD ERROR \(passwordError)")
                        }
                        if let emailError = json["email"] as? [String] {
                            //Example error = ["email": "This field must be unique"]
                            print("Email ERROR \(emailError)")
                        }
                        if let errors = json["error"] as? [String] {
                            print("Sign Up ERROR \(errors)")
                        }
                    }
                    let object = try decoder.decode(SignUpResponse.self, from: userData)
                    //TODO - Samuel - update token here once it is implemented on the backend
                    completion(.success(object.getAsPatient()))
                } catch let error {
                    print("❌ \(#function) - Decoding error: \(error) \ntokenData error: \(String(decoding: userData, as: UTF8.self))")
                }
            }
        }
        task.resume()
    }
    
    func refreshAccessToken(completion: @escaping (() -> Void)) {
//        let tokenURL = EndPoint.tokenPath.urlString
//
//        guard let url = EndPoint.tokenPath.url else {
//            print("\(#function) - Error: Cannot create URL using - \(tokenURL)")
//            return
//        }
//
//        let method = "POST"
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        request.httpBody = "grant_type=client_credentials&client_id=\(apiKey)&client_secret=\(secret)".data(using: .utf8)
//
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            if let response = response as? HTTPURLResponse {
//                print("\(#function) - response: \(response.statusCode)")
//            }
//            if error != nil {
//                print("\(#function) - Error: \(error!.localizedDescription)")
//            }
//
//            if let tokenData = data {
//                do {
//                    let object = try JSONDecoder().decode(TokenResponse.self, from: tokenData)
//                    self.token = object.access_token
//
//                    let date = Date().addingTimeInterval(TimeInterval(object.expires_in))
//                    print("\ntoken local expiration date: \(date)")
//                    self.tokenExpirationDate = date
//                    completion()
//                } catch let error {
//                    print("❌ \(#function) - Decoding error: \(error) \ntokenData error: \(String(decoding: tokenData, as: UTF8.self))")
//                }
//            }
//        }
//        task.resume()
    }
    
    func fetch<T: Decodable>( at endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
//        if isTokenValid() {
//            guard let url = endPoint.url else {
//                print("❌ \(#function) - Error: Cannot create URL using - \(endPoint.urlString)")
//                return
//            }
//            let method = "GET"
//            var request = URLRequest(url: url)
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            request.httpMethod = method
//            request.cachePolicy = .reloadRevalidatingCacheData
//
//            let session = URLSession.shared
//            let task = session.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    completion(.failure(error))
//                }
//                if let data = data {
//                    do {
//                        let object = try JSONDecoder().decode(T.self, from: data)
//                        DispatchQueue.main.async {
//                            completion(.success(object))
//                        }
//
//                    } catch let error {
//                        completion(.failure(error))
//                    }
//                }
//            }
//            task.resume()
//        } else {
//            refreshAccessToken { [weak self] in
//                self?.fetch(at: endPoint, completion: completion)
//            }
//        }
    }
    
    static func finishSigningUp(firstName: String, lastName: String, dob: String, zip: String, image: UIImage, completion: @escaping ((_ error: String?) -> Void)) {
        guard let email = Patient.current?.email else { return } //TODO: Fix this to not require getting Patient.current
        guard let username = Patient.current?.username else { return }
        
//        let resizedImage: UIImage
//        if let imageResized = image.resized(toWidth: 1000) {
//            resizedImage = imageResized
//        } else if let imageResized = image.resized(withPercentage: 0.5) {
//            resizedImage = imageResized
//        } else {
//            resizedImage = image
//        }
//        let imageData = resizedImage.pngData()
//        var retreivedImage: UIImage? = nil
//        //Get image
//        do {
//            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//            let readData = try Data(contentsOf: URL(string: "file://\(documentsPath)/myImage")!)
//            retreivedImage = UIImage(data: readData)
//            addProfilePicView.setImage(retreivedImage, for: .normal)
//        }
//        catch {
//            print("Error while opening image")
//            return
//        }
//
//        let imageData = UIImageJPEGRepresentation(retreivedImage!, 1)
//        if (imageData == nil) {
//            print("UIImageJPEGRepresentation return nil")
//            return
//        }
        
        let json: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
//            "image": imageData!.base64EncodedString(options: []),
//            "image": UIImage(systemName: "person.crop.square.fill")!.jpegData(compressionQuality: 0.7)!, //default image
            "dob": dob,
            "zip": zip,
            "email": email,
        ]
        let postBody = try? JSONSerialization.data(withJSONObject: json)
//        let postBody = try? JSONSerialization.data(withJSONObject: json)
//        print("image data for Finish Sign Up \(imageData!.base64EncodedString(options: []))")
        
//        APIService.uploadUserImage(image: image, for: username, json: [:]) { error in
//            if let error = error {
//                print("Error uploading user image \(error)")
//            } else {
//                print("No error uploading user image")
//            }
//        }
        
        let url = URL(string: "\(Keys.baseURLPath)new/profile/\(username)/")!
        let method = "POST"
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = postBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print("\(#function) - response: \(response.statusCode)")
            }
            if error != nil {
                completion(error!.localizedDescription)
            }
//            if let userData = data {
//                do {
////                    let dictionary = try JSONSerialization.jsonObject(with: userData, options: .fragmentsAllowed) as! NSDictionary
//                    print("FINISH SIGN UP: Converting usedata \(userData)")
////                    if let json = try JSONSerialization.jsonObject(with: userData, options: .mutableContainers) as? [String: Any] {
////                        print("JSON received from finish sign up = ", json)
////                    }
////                    let decoder = JSONDecoder()
////                    decoder.keyDecodingStrategy = .convertFromSnakeCase //convert keys from snake case to camel case
//                    completion(nil)
//                } catch let error {
//                    completion("Error finishing sign up \(error.localizedDescription)")
//                }
//            }
        }
        task.resume()
    }
    
    private init() {}
}

//MARK: - Helpers
extension APIService {
    
    func isTokenValid() -> Bool {
        let tokenDate = APIService.tokenExpirationDate
        let isValid = Date() < tokenDate && !APIService.token.isEmpty
        print("\n\(#function) = \(isValid)")
        return isValid
    }
    
    static func updateToken(newToken: String, expiration: String) {
        self.token = newToken
        let newExpiration = Date.init(timeIntervalSinceNow: TimeInterval(expiration)!)
//        print("Token \(token) expiring in \(expiration) meaning \(newExpiration)")
        self.tokenExpirationDate = newExpiration
    }
}

// MARK: - Image
extension APIService {
    
}

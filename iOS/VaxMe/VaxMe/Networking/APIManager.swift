//
//  APIManager.swift
//  VaxMe
//
//  Created by Samuel Folledo on 6/14/21.
//

import Foundation
import Combine

protocol NetworkService {
    func isTokenValid() -> Bool
    func refreshAccessToken(completion: @escaping (() -> Void))
    func fetch<T: Decodable>( at endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void)
}

class APIService: NetworkService {
    
    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Petfinder-Info", ofType: "plist") else {
            fatalError("Petfinder-Info file NOT found! Create it and add your API Key and Secret")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let loadedKey = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("API_KEY NOT found in Petfinder-Info.plist")
        }
        
        if(loadedKey.starts(with: "_")) {
            fatalError("Register and get your own Petfinder API Key at: https://www.petfinder.com/developers/v2/docs/")
        }
        return loadedKey
    }
    
    private var secret: String {
        guard let filePath = Bundle.main.path(forResource: "Petfinder-Info", ofType: "plist") else {
            fatalError("Petfinder-Info file NOT found!")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let loadedSecret = plist?.object(forKey: "API_SECRET") as? String else {
            fatalError("API_SECRET NOT found in Petfinder-Info.plist")
        }
        
        if(loadedSecret.starts(with: "_")) {
            fatalError("Register and get your own Petfinder API Secret at: https://www.petfinder.com/developers/v2/docs/")
        }
        return loadedSecret
    }
    
    private var token: String {
        get { UserDefaults.standard.string(forKey: Keys.tokenKey) ?? "" }
        set {  UserDefaults.standard.setValue(newValue, forKey: Keys.tokenKey) }
    }
    
    private var tokenExpirationDate: Date {
        get { UserDefaults.standard.object(forKey: Keys.tokenExpiration) as? Date ?? Date() }
        set { UserDefaults.standard.set(newValue, forKey: Keys.tokenExpiration) }
    }
    
    // To decode server answer to a token request
    private struct TokenResponse: Decodable {
        let token_type: String
        let expires_in: Int
        let access_token: String
    }
    
    func isTokenValid() -> Bool {
        let tokenDate = tokenExpirationDate
        let isValid = Date() < tokenDate && !token.isEmpty
        print("\n\(#function) = \(isValid)")
        return isValid
    }
    
    struct Patient: Codable {
//        var id: Int
        var email: String
        var lastLogin: String? //optional
        var isSuperuser: Bool
        var username: String
        var firstName: [String]
        var lastName: [String]
        var groups: [String] = []
        var userPermissions: [String] = []
        var isStaff: Bool?
        var isActive: Bool?
        var dateJoined: String?
    }
    
    struct SignInResponse: Codable {
        var token: String
        var expiresIn: String //Int in seconds
        var user: User
        
        func getAsPatient() -> Patient {
            let patient = Patient(email: user.email, isSuperuser: false, username: user.username, firstName: [user.firstName], lastName: [user.lastName])
            return patient
        }
        
        struct User: Codable {
            var email: String
            var firstName: String
            var lastName: String
            var username: String
        }
    }
    
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
                completion(.failure(error))
            }
            if let userData = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase  //convert keys from snake case to camel case
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
                        // handle json...
                    }
                    let object = try decoder.decode(SignInResponse.self, from: userData)
                    completion(.success(object.getAsPatient()))
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
//        request.httpBody = json.percentEncoded()
        
//        request.httpBody = "username=\(username)&email=\(email)&password=\(password)&password2=\(password2)".data(using: .utf8)
//        request.httpBody = "grant_type=client_credentials&client_id=\(apiKey)&client_secret=\(secret)".data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print("\(#function) - response: \(response.statusCode)")
            }
            if error != nil {
                print("\(#function) - Error: \(error!.localizedDescription)")
            }
            print("Got data!")
            if let userData = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase  //convert keys from snake case to camel case
                do {
//                    let object = try decoder.decode(TokenResponse.self, from: tokenData)
//                    self.token = object.access_token
//
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
                        
                        // handle json...
                    }
                    
                    let object = try decoder.decode(Patient.self, from: userData)
                    print("Patient data \(object)")
                    completion(.success(object))
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
}

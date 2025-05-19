//
//  APIService.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/13/25.
//

import Foundation
import SwiftData

public class APIService {
    static let shared = APIService()
    private init() {}

    private let baseURL = URL(string: "https://genericrestaurantapi.onrender.com/")!
    public let apiURL   = URL(string: "https://genericrestaurantapi.onrender.com/api/v1/")!

    private var accessToken: String? {
        KeychainHelper.shared.readString(service: "auth", account: "accessToken")
    }

    private var refreshToken: String? {
        KeychainHelper.shared.readString(service: "auth", account: "refreshToken")
    }

    func saveTokens(access: String, refresh: String) {
        KeychainHelper.shared.saveString(access, service: "auth", account: "accessToken")
        KeychainHelper.shared.saveString(refresh, service: "auth", account: "refreshToken")
    }

    func clearTokens() {
        KeychainHelper.shared.delete(service: "auth", account: "accessToken")
        KeychainHelper.shared.delete(service: "auth", account: "refreshToken")
    }

    // MARK: - Petición con token y gestión de expiración
    var onUnauthorized: (() -> Void)?  // Para cerrar sesión si el refresh falla

    func request<T: Decodable>(
        url: URL,
        method: String = "GET",
        body: Data? = nil,
        addAuthHeader: Bool = true,
        headers: [String: String] = [:],
        completion: @escaping (Result<T, Error>) -> Void
        ) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body

        var finalHeaders = headers
            if addAuthHeader, let token = self.accessToken {
            finalHeaders["Authorization"] = "Bearer \(token)"
        }

        finalHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                // Token expirado, intentar refrescar
                self.refreshAccessToken { success in
                    if success {
                        // Reintentar la misma solicitud
                        self.request(
                            url: url,
                            method: method,
                            body: body,
                            addAuthHeader: addAuthHeader,
                            headers: headers,
                            completion: completion
                        )
                    } else {
                        DispatchQueue.main.async {
                            self.onUnauthorized?()
                            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized – token expired."])))
                        }
                    }
                }
                return
            }

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 400{
                // Intenta decodificar el error personalizado
                if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                   DispatchQueue.main.async {
                       completion(.failure(apiError))
                   }
                } else {
                   DispatchQueue.main.async {
                       completion(.failure(URLError(.badServerResponse)))
                   }
                }
            }
            do {
                
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    // MARK: - Refrescar token
    public func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = self.refreshToken else {
            completion(false)
            return
        }

        var request = URLRequest(url: baseURL.appendingPathComponent("api/token/refresh/"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["refresh": refreshToken]
        request.httpBody = try? JSONEncoder().encode(body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let newAccess = json["access"] as? String else {
                completion(false)
                return
            }

            let newRefresh = json["refresh"] as? String ?? refreshToken
            // Guarda el nuevo access token
            DispatchQueue.main.async {
                self.saveTokens(access: newAccess, refresh: newRefresh)
                completion(true)
            }
        }
        task.resume()
    }
    // MARK: - Login
    func login(username: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let loginURL = apiURL.appendingPathComponent("auth/login/")
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let authRequest = AuthRequest(username: username, password: password)
        do {
            let jsonData = try JSONEncoder().encode(authRequest)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.unknown))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let response = response as? HTTPURLResponse, response.statusCode == 400 {
                    let error = try decoder.decode(APIErrorResponse.self, from: data);
                    completion(.failure(error))
                    return
                }
                let authResponse = try decoder.decode(AuthResponse.self, from: data)
                if let access = authResponse.tokens?.access, let refresh = authResponse.tokens?.refresh {
                    self.saveTokens(access: access, refresh: refresh)
                }
                completion(.success(authResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    // MARK: - Logout
    public func logout(context: ModelContext) {
        // 1. Borrar sesión en SwiftData
        let sessions = try? context.fetch(FetchDescriptor<SessionModel>())
        sessions?.forEach { context.delete($0) }
        // 2. Borrar tokens del Keychain
        clearTokens()
        // TODO: 3. Set token to blacklist
        // /api/v1/auth/logout/
    }
    // MARK: Get Initial config
    func getInitialConfig(completion: @escaping(Result<InitialConfig, Error>) -> Void){
        let url = self.apiURL.appendingPathComponent("config/initial_setup/");
        self.request(url: url){ (result: Result<InitialConfig, Error>) in
            switch result {
                case .success(let config):
                    completion(.success(config))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
        
    }
    func getOrders(completion: @escaping(Result<PaginatedResult<[Order]>, Error>) -> Void){
        let url = self.apiURL.appendingPathComponent("orders/");
        self.request(url: url){ (result: Result<PaginatedResult<[Order]>, Error>) in
            switch result {
                case .success(let orders):
                    completion(.success(orders))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    func getOrdersByRestaurantId(_ id: Int, completion: @escaping(Result<PaginatedResult<[Order]>, Error>) -> Void){
        var url = self.apiURL.appendingPathComponent("orders/");
        url.append(queryItems: [URLQueryItem(name:"restaurantId", value: String(id))])
        self.request(url: url){ (result: Result<PaginatedResult<[Order]>, Error>) in
            switch result {
                case .success(let orders):
                    completion(.success(orders))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    func getOrdersByStatus(restaurantId: Int, status: String = "ACTIVE", completion: @escaping(Result<PaginatedResult<[Order]>, Error>) -> Void){
        var url = self.apiURL.appendingPathComponent("orders/by_status/");
        url
            .append(
                queryItems: [
                    URLQueryItem(name: "restaurantId", value: String(restaurantId)),
                    URLQueryItem(name: "status", value: status.uppercased())
                ]
            )
        self.request(url: url){ (result: Result<PaginatedResult<[Order]>, Error>) in
            switch result {
                case .success(let orders):
                    completion(.success(orders))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    func getOrderById(_ id : Int, completion: @escaping(Result<Order, Error>) -> Void){
        let url = self.apiURL.appendingPathComponent("orders/\(id)/");
        self.request(url: url){ (result: Result<Order, Error>) in
            switch result {
                case .success(let orders):
                    completion(.success(orders))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    // MARK: - async Methods
    // MARK: - Versión async/await del método request
    func requestAsync<T: Decodable>(
        url: URL,
        method: String = "GET",
        body: Data? = nil,
        addAuthHeader: Bool = true,
        headers: [String: String] = [:]
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body

        var finalHeaders = headers
        if addAuthHeader, let token = self.accessToken {
            finalHeaders["Authorization"] = "Bearer \(token)"
        }

        finalHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        // Token expirado
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            let refreshed = try await refreshAccessTokenAsync()
            if refreshed {
                return try await requestAsync(
                    url: url,
                    method: method,
                    body: body,
                    addAuthHeader: addAuthHeader,
                    headers: headers
                )
            } else {
                self.onUnauthorized?()
                throw APIError.unauthorized
            }
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        if httpResponse.statusCode == 400 {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw apiError
            } else {
                throw URLError(.badServerResponse)
            }
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error:", error)
            throw error
        }
    }
    func refreshAccessTokenAsync() async throws -> Bool {
        guard let refreshToken = self.refreshToken else {
            return false
        }

        var request = URLRequest(url: baseURL.appendingPathComponent("api/token/refresh/"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["refresh": refreshToken]
        request.httpBody = try? JSONEncoder().encode(body)

        let (data, _) = try await URLSession.shared.data(for: request)

        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let newAccess = json["access"] as? String else {
            return false
        }

        let newRefresh = json["refresh"] as? String ?? refreshToken
        self.saveTokens(access: newAccess, refresh: newRefresh)
        return true
    }
    func getProductPricingAsync(_ restaurantId: Int, onlyValid: Int = 1, productName: String = String()) async throws -> PaginatedResult<[Pricing]> {
        var url = self.apiURL.appendingPathComponent("pricing/");
        url.append(
            queryItems: [
                URLQueryItem(name:"restaurantId", value: String(restaurantId)),
                URLQueryItem(name:"onlyValid", value: String(onlyValid)),
            ]
        );
        if !productName.isEmpty {
            url.append(queryItems: [URLQueryItem(name:"productName", value: productName)])
        }
        let response : PaginatedResult<[Pricing]> = try await self.requestAsync(url: url);
        return response
    }
}

// MARK: - Errores comunes
enum APIError: Error {
    case unauthorized
    case unknown
}

struct APIErrorResponse: Codable, Error {
    let error: String
}

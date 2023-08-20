import Foundation
class APICaller {
    
    static let sheared = APICaller()
    
    let baseURL = AppConfig.appURL
    
    let decoder = JSONDecoder()
    
    var refresh_token: String?
    
    func callAPI<Model: Decodable>(endpoint: String, method: HTTPMethod, parameters: [String: AnyHashable] = [:],  existRefreshToken: Bool = false, isAuth: Bool = true, completion: @escaping (Result<Model,CustomError>) -> Void){
        
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            completion(.failure(CustomError.invalidURL))
            return
        }
        
        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(CustomError.invalidURL))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
          
        if method != .get {
            // HTTP body를 사용하는 경우는 parameters를 JSON 데이터로 변환하여 설정
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(.networkError(error)))
                return
            }
        }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30 // 30초로 설정
        
        let task = URLSession(configuration: sessionConfig).dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                if let jsonErrorData = data,
                   let errorJSON = try? JSONSerialization.jsonObject(with: jsonErrorData, options: []) as? [String: Any],
                   let errorMessage = errorJSON["message"] as? String{
                    completion(.failure(.invalidStatusCode(httpResponse.statusCode, errorMessage)))
                    return
                }
            }
            
            guard let data = data else {
                completion(.failure(CustomError.noData))
                return
            }

            do {
                let model = try self.decoder.decode(Model.self, from: data)
                if existRefreshToken {
                    if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                        // 쿠키 저장하기
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response!.url!)
                        if let session = cookies.filter({$0.name == "refreshToken"}).first {
                            UserDefaults.standard.set(session.value, forKey: UserDefaults.userRefreshTokenKey)
                        }
                    }
                }
                completion(.success(model))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}

enum CustomError: Error {
    case invalidURL
    case invalidStatusCode(Int,String)
    case noData
    case unauthorized
    case networkError(Error)
    case decodingError(Error)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

import Foundation
class APICaller<Model: Decodable> {
    
    let baseURL = AppConfig.appURL
    
    let decoder = JSONDecoder()
    
    func callAPI(endpoint: String, method: HTTPMethod, parameters: [String: AnyHashable] = [:], completion: @escaping (Result<Model,Error>) -> Void){
        
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidURL))
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
                completion(.failure(error))
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.invalidStatusCode(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let model = try self.decoder.decode(Model.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode(Int)
    case noData
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

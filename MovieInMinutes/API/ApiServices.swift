import Foundation
import SwiftyJSON

// MARK: - APIError
enum ApiErrors: Error {
    case invalidURL
    case invalidResponse(Int)
    case invalidBody
    case parseJsonError(Error)
    case networkError(Error)
    case noData
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return LanguageDictionary.invalidURL.dictionary
        case .networkError(let error):
            return "\(LanguageDictionary.networkError.dictionary)"
        case .parseJsonError(let error):
            return "\(LanguageDictionary.jsonError.dictionary)"
        case .invalidResponse(let statusCode):
            return "\(LanguageDictionary.responseError.dictionary) \(statusCode)"
        case .invalidBody:
            return LanguageDictionary.invalidData.dictionary
        case .noData:
            return LanguageDictionary.noData.dictionary
        case .unknownError:
            return LanguageDictionary.unknownError.dictionary
        }
    }
}
// MARK: - Enum Result
enum Result<T> {
    case success(T)
    case failure(ApiErrors)
}

// MARK: - APIServices
class ApiServices {
    
    init() {}
    
    // MARK: - URLSession request with error handling
    static func execute(request: HttpRequest, completion: @escaping (Result<JSON>) -> Void) {
        if !AppConstant.isLoading {
            LoadingManager.shared.showLoadingIndicator()
            AppConstant.isLoading = true
        }
        switch request.createRequest() {
        case .failure:
            if AppConstant.isLoading {
                LoadingManager.shared.hideLoadingIndicator()
                AppConstant.isLoading = false
            }
            completion(.failure(.invalidURL))
            return
        case .success(let urlRequest):
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                if let error = error {
                    if AppConstant.isLoading {
                        LoadingManager.shared.hideLoadingIndicator()
                        AppConstant.isLoading = false
                    }
                    completion(.failure(.networkError(error)))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    guard (200...299).contains(httpResponse.statusCode) else {
                        if AppConstant.isLoading {
                            LoadingManager.shared.hideLoadingIndicator()
                            AppConstant.isLoading = false
                        }
                        if httpResponse.statusCode == 401 {
                            BaseAppController.showAlertInWindow(title: LanguageDictionary.loginToUse.dictionary, message: "")
                            return
                        }
                        completion(.failure(.invalidResponse(httpResponse.statusCode)))
                        return
                    }
                } else {
                    if AppConstant.isLoading {
                        LoadingManager.shared.hideLoadingIndicator()
                        AppConstant.isLoading = false
                    }
                    completion(.failure(.unknownError))
                    return
                }
                
                guard let safeData = data else {
                    if AppConstant.isLoading {
                        LoadingManager.shared.hideLoadingIndicator()
                        AppConstant.isLoading = false
                    }
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let json = try JSON(data: safeData)
                    if AppConstant.isLoading {
                        LoadingManager.shared.hideLoadingIndicator()
                        AppConstant.isLoading = false
                    }
                    completion(.success(json))
                } catch {
                    if AppConstant.isLoading {
                        LoadingManager.shared.hideLoadingIndicator()
                        AppConstant.isLoading = false
                    }
                    completion(.failure(.parseJsonError(error)))
                }
            }
            task.resume()
        }
    }
    
}



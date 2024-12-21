//
//  NetworkErrors.swift
//  NooroWeatherApp
//
//  Created by ravinder vatish on 12/17/24.
//

import Foundation

enum NetworkErrors : Error, LocalizedError {
    case invalidURL
    case requestFailed
    case decodingFailed
    case unknownError(Error)

       var errorDescription: String? {
           switch self {
           case .invalidURL:
               return "The URL is invalid."
           case .requestFailed:
               return "The network request failed."
           case .decodingFailed:
               return "Failed to decode the response."
           case .unknownError(let error):
               return error.localizedDescription
           }
       }
}

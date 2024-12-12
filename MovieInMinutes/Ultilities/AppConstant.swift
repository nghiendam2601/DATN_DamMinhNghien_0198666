//
//  AppConstant.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 14/11/24.
//

import Foundation

struct AppConstant {
    static var isNetworkAvailable: Bool = false
    static var isLoading: Bool = false
    static var isRefresh: Bool = false
    static var requestToken: RequestToken?
    static var isFromSafari: Bool = false
    static var moviesRated: [Int: Double] = [:]
    static var tvRated: [Int: Double] = [:]
}

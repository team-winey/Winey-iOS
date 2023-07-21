//
//  AnimationView.swift
//  
//
//  Created by Woody Lee on 2023/07/20.
//

import Foundation

import Lottie

public struct AnimationView {
    public static let loadingView = LottieAnimationView(name: "loading", bundle: .module)
    public static let splashView = LottieAnimationView(name: "splash", bundle: .module)
}

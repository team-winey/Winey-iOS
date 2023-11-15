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
    
    public static let onboardingView1 = LottieAnimationView(name: "onboarding1", bundle: .module)
    public static let onboardingView2 = LottieAnimationView(name: "onboarding2", bundle: .module)
    public static let onboardingView3 = LottieAnimationView(name: "onboarding3", bundle: .module)
}

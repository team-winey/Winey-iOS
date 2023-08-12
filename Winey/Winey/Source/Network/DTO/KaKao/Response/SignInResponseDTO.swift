//
//  SignInResponseDTO.swift
//  Winey
//
//  Created by 고영민 on 2023/08/08.
//

import Foundation

// MARK: - SignIn
struct SignInResponseDTO: Codable {
    let social, email: String
    let profileImage: String
    let groupID, groupAdmissionYear: Int
    let name, ID, gender: String
    let friends: [Int]
    let recommendID: String
    
    enum CodingKeys: String, CodingKey {
        case social, email, profileImage
        case groupID = "groupId"
        case groupAdmissionYear, name
        case ID = "Id"
        case gender, friends
        case recommendID = "recommendId"
    }
}

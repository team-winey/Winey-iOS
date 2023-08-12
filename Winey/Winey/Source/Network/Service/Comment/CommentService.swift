//
//  CommentService.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/10.
//

import UIKit

import Moya

final class CommentService {
    let provider = MoyaProvider<CommentAPI>()

    typealias CreateCommentRes = BaseResponse<CreateCommentResponse>
    
    func createComment(feedId: Int, comment: String) async throws -> CreateCommentResponse {
        return try await withCheckedThrowingContinuation { continuation in
            let request = CreateCommentRequest(feedId: feedId, content: comment)
            provider.request(.create(request: request)) { result in
                do {
                    guard let response = try result.get().map(CreateCommentRes.self).data
                    else { throw CommentNetworkError.undefined }
                    continuation.resume(returning: response)
                } catch {
                    continuation.resume(throwing: CommentNetworkError.undefined)
                }
            }
        }
    }
    
    func deleteComment(commentId: Int) async throws -> Void {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.delete(commentId: commentId)) { result in
                do {
                    let response = try result.get().map(BaseResponse<EmptyResponseData>.self)
                    continuation.resume(returning: Void())
                } catch {
                    continuation.resume(throwing: CommentNetworkError.undefined)
                }
            }
        }   
    }
    
    enum CommentNetworkError: Error {
        case undefined
    }
}

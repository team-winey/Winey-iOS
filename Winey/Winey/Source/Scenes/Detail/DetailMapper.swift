//
//  DetailMapper.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/13.
//

import Foundation
import Kingfisher

protocol DetailMappingLogic {
    func convertToCommentViewModel(_ dto: CommentResponse) throws -> CommentCell.ViewModel
    func convertToDetailInfoViewModel(
        _ dto: FeedDetailResponse
    ) async throws -> DetailInfoCell.ViewModel
    func convertToCommentViewModel(
        _ dto: CreateCommentResponse
    ) throws -> CommentCell.ViewModel
}

final class DetailMapper: DetailMappingLogic {
    func convertToCommentViewModel(_ dto: CommentResponse) throws -> CommentCell.ViewModel {
        guard let level = UserLevel(value: dto.authorLevel)?.rawValue
        else { throw ConversionError.invalidUserLevel }
        
        let isMine = UserSingleton.getNickname() == dto.author
        
        return .init(
            id: dto.commentId,
            level: level,
            nickname: dto.author,
            comment: dto.content,
            isMine: isMine
        )
    }
    
    func convertToDetailInfoViewModel(
        _ dto: FeedDetailResponse
    ) async throws -> DetailInfoCell.ViewModel {
        let feedDto = dto.getFeedResponseDto
        
        guard let level = UserLevel(value: feedDto.writerLevel)
        else { throw ConversionError.invalidUserLevel }
        
        let commentCount = dto.getCommentResponseList.count
        
        let createdTime = String(feedDto.createdAt.prefix(19))
        guard let createdDate = dateFormatter.date(from: createdTime)
        else { throw ConversionError.invalidFeedCreatedAt }
        
        let duration = Int(Date().timeIntervalSince(createdDate))
        let timeAgo = getTimeAgo(by: duration)
        
        guard let imageUrl = URL(string: feedDto.image)
        else { throw ConversionError.invalidImageUrl(feedDto.image) }
        
        let imageInfo = await getDetailImageInfo(by: imageUrl)
        
        return .init(
            userLevel: level,
            nickname: feedDto.nickname,
            isLiked: feedDto.isLiked,
            title: feedDto.title,
            likeCount: feedDto.likes,
            commentCount: commentCount,
            timeAgo: timeAgo,
            imageInfo: imageInfo,
            money: feedDto.money,
            isMine: feedDto.userID == UserSingleton.getId()
        )
    }
    
    // TODO: DTO를 사용하지 않지만 DTO 형태가 바뀐다면 사용하도록 변경
    func convertToCommentViewModel(_ dto: CreateCommentResponse) throws -> CommentCell.ViewModel {
        let nickname = UserSingleton.getNickname()
        
        guard let commentId = dto.commentId
        else { throw ConversionError.invalidCommentId }
        
        guard let comment = dto.content
        else { throw ConversionError.invalidCommentContent }
        
        return .init(
            id: commentId,
            level: UserSingleton.getLevel().rawValue,
            nickname: nickname,
            comment: comment,
            isMine: true
        )
    }
    
    private func getDetailImageInfo(by imageUrl: URL) async -> DetailInfoCell.ViewModel.ImageInfo {
        return await withCheckedContinuation { contiunation in
            KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
                switch result {
                case .success(let result):
                    let width = DeviceInfo.width - DetailInfoCell.PublicConst.inset * 2
                    let height = result.image.getHeightOfResizedImageView(avaliableWidth: width)
                    let image = result.image
                    let imageInfo = DetailInfoCell.ViewModel.ImageInfo(
                        image: image,
                        imageUrl: imageUrl,
                        height: height
                    )
                    contiunation.resume(returning: imageInfo)
                case .failure:
                    // TODO: 오류 처리
                    break
                }
            }
        }
    }
    
    private func getTimeAgo(by target: Int) -> String {
        let day = target / 86400 // 60 * 60 * 24
        let hour = target / 3600 // 60 * 60
        let minute = (target % 3600) / 60
        let second = target % 60
        
        if day > 0 { return "\(day)일 전" }
        else if hour > 0 { return "\(hour)시간 전"}
        else if minute > 0 { return "\(minute)분 전"}
        else { return "\(second)초 전" }
    }
    
    // TODO: 주입 형태로 변경
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }
    
    enum ConversionError: Error {
        case invalidUserLevel
        case invalidFeedCreatedAt
        case invalidImageUrl(String?)
        case invalidImage(URL)
        case invalidCommentId
        case invalidCommentContent
    }
}

private extension KFCrossPlatformImage {
    func getHeightOfResizedImageView(avaliableWidth: CGFloat) -> CGFloat {
        let ratio = avaliableWidth / self.size.width
        let scaledHeight = self.size.height * ratio
        
        return scaledHeight
    }
}

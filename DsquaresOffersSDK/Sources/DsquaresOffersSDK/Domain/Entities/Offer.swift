//
//  Offer.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 09/03/2026.
//

import Foundation

public struct Offer: Identifiable, Equatable {
  public let id: Int
  public let title: String
  public let description: String?
  public let imageUrl: URL?
  public let points: String?
  public let merchantName: String?
  public let isLocked: Bool
  public let rewardType: String?

  public init(
    id: Int, 
    title: String, 
    description: String?, 
    imageUrl: URL?, 
    points: String? = nil,
    merchantName: String? = nil,
    isLocked: Bool = false,
    rewardType: String? = nil
  ) {
    self.id = id
    self.title = title
    self.description = description
    self.imageUrl = imageUrl
    self.points = points
    self.merchantName = merchantName
    self.isLocked = isLocked
    self.rewardType = rewardType
  }
}

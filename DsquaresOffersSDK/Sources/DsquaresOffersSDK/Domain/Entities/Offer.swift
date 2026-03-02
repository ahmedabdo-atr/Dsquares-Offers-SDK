//
//  Offer.swift
//  DsquaresOffersSDK
//
//  Created by Ahmad A. on 02/03/2026.
//

import Foundation

/// Domain model representing an offer.
/// This is decoupled from any specific API implementation.
public struct Offer: Identifiable, Equatable {
  public let id: Int
  public let title: String
  public let description: String?
  public let imageUrl: URL?
  public let points: String?
  public let merchantName: String?

  public init(
    id: Int, title: String, description: String?, imageUrl: URL?, points: String? = nil,
    merchantName: String? = nil
  ) {
    self.id = id
    self.title = title
    self.description = description
    self.imageUrl = imageUrl
    self.points = points
    self.merchantName = merchantName
  }
}

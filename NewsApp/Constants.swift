//
//  Constants.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/12.
//  Copyright © 2020 Yifan. All rights reserved.
//

import Foundation
struct Constants {
    static let weatherApiKey = "997f3f3ec4894eba4f7e77dc382a51b3"
    static let weatherUrl = "https://api.openweathermap.org/data/2.5/weather"
    static let weatherDataReady = Notification.Name("weatherDataReady")
    static let homeNewsReady = Notification.Name("homeNewsReady")
    static let searchNewsReady = Notification.Name("searchNewsReady")
    static let headlinesNewsReady = Notification.Name("headlinesNewsReady")
    static let detailNewsReady = Notification.Name("detailNewsReady")
    static let chartDataReady = Notification.Name("chartDataReady")
    static let showSearchResultPage = Notification.Name("showSearchResultPage")
    static let statesDictionary = ["NM": "New Mexico", "SD": "South Dakota", "TN": "Tennessee", "VT": "Vermont", "WY": "Wyoming", "OR": "Oregon", "MI": "Michigan", "MS": "Mississippi", "WA": "Washington", "ID": "Idaho", "ND": "North Dakota", "GA": "Georgia", "UT": "Utah", "OH": "Ohio", "DE": "Delaware", "NC": "North Carolina", "NJ": "New Jersey", "IN": "Indiana", "IL": "Illinois", "HI": "Hawaii", "NH": "New Hampshire", "MO": "Missouri", "MD": "Maryland", "WV": "West Virginia", "MA": "Massachusetts", "IA": "Iowa", "KY": "Kentucky", "NE": "Nebraska", "SC": "South Carolina", "AZ": "Arizona", "KS": "Kansas", "NV": "Nevada", "WI": "Wisconsin", "RI": "Rhode Island", "FL": "Florida", "TX": "Texas", "AL": "Alabama", "CO": "Colorado", "AK": "Alaska", "VA": "Virginia", "AR": "Arkansas", "CA": "California", "LA": "Louisiana", "CT": "Connecticut", "NY": "New York", "MN": "Minnesota", "MT": "Montana", "OK": "Oklahoma", "PA": "Pennsylvania", "ME": "Maine"]
    static let sections = ["WORLD": "world", "BUSINESS": "business", "POLITICS": "politics", "SPORTS":"sport",
                           "TECHNOLOGY": "technology", "SCIENCE":"science"]
//    static let backendUrl = "http://ec2-13-52-97-136.us-west-1.compute.amazonaws.com:5000/"
    static let backendUrl = "http://localhost:5000/"
    static let loadingMessage = "Loading Home Page.."
    static let bookmarkRemoveMessage = "Article Removed from Bookmarks"
    static let bookmarkSaveMessage = "Article Bookmarked. Check out the Bookmarks tab to view"
    static let loadingDetailMessage = "Loading Detailed article.."
}

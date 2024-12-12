
import Foundation

enum MovieListType: String {
    case NowPlaying = "now_playing"
    case Upcoming = "upcoming"
    case TopRated = "top_rated"
    case Popular = "popular"
    
    var title: String {
        switch self {
        case .NowPlaying:
            return LanguageDictionary.nowPlaying.dictionary
        case .Upcoming:
            return LanguageDictionary.upComing.dictionary
        case .TopRated:
            return LanguageDictionary.topRated.dictionary
        case .Popular:
            return LanguageDictionary.popular.dictionary
        }
    }
}

enum TVSeriesListType: String {
    case AiringToday = "airing_today"
    case Popular = "popular"
    case OnTheAir = "on_the_air"
    case TopRated = "top_rated"
    var title: String {
        switch self {
        case .AiringToday:
            return LanguageDictionary.airingToday.dictionary
        case .OnTheAir:
            return LanguageDictionary.onTheAir.dictionary
        case .TopRated:
            return LanguageDictionary.topRated.dictionary
        case .Popular:
            return LanguageDictionary.popular.dictionary
        }
    }
}

enum Category: String {
    case Movie = "movie"
    case TVSeries = "tv"
}


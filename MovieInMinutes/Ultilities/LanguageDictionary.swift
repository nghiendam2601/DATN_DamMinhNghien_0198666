enum LanguageDictionary {
    // Existing cases
    case login
    case logout
    case signUp
    case guest
    case loginSuggest
    case light
    case dark
    case currentLanguage
    case myProfile
    case movies
    case tvSeries
    case search
    case personal
    case nowPlaying
    case popular
    case topRated
    case upComing
    case airingToday
    case onTheAir
    case myRated
    case ratingThis
    case ok
    case cancel
    case searchHere
    case suggestSearch
    case noData
    case askDeleteRated
    case askRated
    case seeAll
    case addToList
    case overview
    case cast
    case officialTrailer
    case seasons
    case information
    case watchReview
    case watchNow
    case myCollection
    case createList
    case listName
    case listDescription
    case inputListName
    case inputListDescription
    case myRating
    case myRatedMovies
    case myRatedTV
    case episodes
    case genres
    case status
    case runtime
    case originalName
    case adult
    case budget
    case revenue
    case numberOfEpisodes
    case type
    case airDate
    case season
    case voteAverage
    case voteCount
    case numberOfSeasons
    case reviewMovie
    case itemMovie
    case delete
    
    // New cases
    case pleaseLoginAgain
    case error
    case addSuccess
    case movieAlreadyAdded
    case failedCreateRequestToken
    case clearListConfirmation
    case nameRequired
    case invalidURL
    case networkError
    case jsonError
    case responseError
    case invalidData
    case unknownError
    case suggestWatchReview
    case loginToUse
    case birthDay
    case deathDay
    case knownFor
    case placeOfBirth
    case biography
    case like
    case view
    case person
    
    var dictionary: String {
        switch self {
        case .login:
            return "login".localized()
        case .logout:
            return "logout".localized()
        case .signUp:
            return "sign_up".localized()
        case .guest:
            return "guest".localized()
        case .loginSuggest:
            return "loginSuggest".localized()
        case .light:
            return "light".localized()
        case .dark:
            return "dark".localized()
        case .currentLanguage:
            return "current_language".localized()
        case .myProfile:
            return "my_profile".localized()
        case .movies:
            return "movies".localized()
        case .tvSeries:
            return "tvseries".localized()
        case .search:
            return "search".localized()
        case .personal:
            return "personal".localized()
        case .nowPlaying:
            return "now_playing".localized()
        case .popular:
            return "popular".localized()
        case .topRated:
            return "top_rated".localized()
        case .upComing:
            return "up_coming".localized()
        case .airingToday:
            return "airing_today".localized()
        case .onTheAir:
            return "on_the_air".localized()
        case .myRated:
            return "my_rated".localized()
        case .ratingThis:
            return "rating_this".localized()
        case .ok:
            return "ok".localized()
        case .cancel:
            return "cancel".localized()
        case .searchHere:
            return "search_here".localized()
        case .suggestSearch:
            return "suggest_search".localized()
        case .noData:
            return "no_data".localized()
        case .askDeleteRated:
            return "ask_delete_rated".localized()
        case .seeAll:
            return "see_all".localized()
        case .addToList:
            return "add_to_list".localized()
        case .overview:
            return "overview".localized()
        case .cast:
            return "cast".localized()
        case .officialTrailer:
            return "official_trailer".localized()
        case .seasons:
            return "seasons".localized()
        case .information:
            return "information".localized()
        case .watchReview:
            return "watch_review".localized()
        case .watchNow:
            return "watch_now".localized()
        case .myCollection:
            return "my_collection".localized()
        case .createList:
            return "create_list".localized()
        case .listName:
            return "list_name".localized()
        case .listDescription:
            return "list_des".localized()
        case .inputListName:
            return "input_list_name".localized()
        case .inputListDescription:
            return "input_list_des".localized()
        case .myRating:
            return "my_rating".localized()
        case .myRatedMovies:
            return "my_rated_movies".localized()
        case .myRatedTV:
            return "my_rated_tv".localized()
        case .episodes:
            return "episodes".localized()
        case .genres:
            return "genres".localized()
        case .status:
            return "status".localized()
        case .runtime:
            return "run_time".localized()
        case .originalName:
            return "original_name".localized()
        case .adult:
            return "adult".localized()
        case .budget:
            return "budget".localized()
        case .revenue:
            return "revenue".localized()
        case .numberOfEpisodes:
            return "number_of_episodes".localized()
        case .type:
            return "type".localized()
        case .airDate:
            return "air_date".localized()
        case .season:
            return "season".localized()
        case .voteAverage:
            return "vote_avarage".localized()
        case .voteCount:
            return "vote_count".localized()
        case .numberOfSeasons:
            return "number_of_seasons".localized()
        case .reviewMovie:
            return "review_movie".localized()
            
            // New cases
        case .pleaseLoginAgain:
            return "please_login_again".localized()
        case .error:
            return "error".localized()
        case .addSuccess:
            return "add_success".localized()
        case .movieAlreadyAdded:
            return "movie_already_added".localized()
        case .failedCreateRequestToken:
            return "failed_create_request_token".localized()
        case .clearListConfirmation:
            return "clear_list_confirmation".localized()
        case .nameRequired:
            return "name_required".localized()
        case .invalidURL:
            return "invalid_url".localized()
        case .networkError:
            return "network_error".localized()
        case .jsonError:
            return "json_error".localized()
        case .responseError:
            return "response_error".localized()
        case .invalidData:
            return "invalid_data".localized()
        case .unknownError:
            return "unknown_error".localized()
        case .askRated:
            return "ask_rated".localized()
        case .suggestWatchReview:
            return "suggest_watch_review".localized()
        case .loginToUse:
            return "login_to_use".localized()
        case .itemMovie:
            return "item_movie".localized()
        case .delete:
            return "delete".localized()
        case .birthDay:
            return "birth_day".localized()
        case .deathDay:
            return "death_day".localized()
        case .knownFor:
            return "known_for".localized()
        case .placeOfBirth:
            return "place_of_birth".localized()
        case .biography:
            return "biography".localized()
        case .like:
            return "like".localized()
        case .view:
            return "view".localized()
        case .person:
            return "person".localized()
        }
    }
}

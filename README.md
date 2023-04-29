# Wikipedia Search App

A Flutter project that allows users to search for articles on Wikipedia using the Wikipedia API. The project uses BLoC state management, Dio for API calls, and implements both light and dark themes.

## Table of Contents

* [Features](#features)
* [Screenshots](#screenshots)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [Architecture](#architecture)
* [API Calls](#api-calls)
* [Themes](#themes)
* [Caching Mechanism](#caching-mechanism)
* [Contributing](#contributing)

## Features

- Search for articles on Wikipedia using the Wikipedia API
- Implements both light and dark themes
- Uses BLoC state management
- Uses Dio for API calls
- Shimmer effect while loading items
- Cache the responses with a cache eviction policy of having maximum 5 responses at one time
- Truncates description to a fixed number of characters

## Screenshots

| Light Theme | Dark Theme |
| --- | --- |
| ![Light Theme Screenshot](https://user-images.githubusercontent.com/52314451/235284922-12ec0754-3b65-439b-a452-b22f980d38b3.png) | ![Dark Theme Screenshot](https://user-images.githubusercontent.com/52314451/235284866-d4b70dba-9fba-4d26-9b0f-b933e8c579f0.png) |

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio / VS Code

### Installation

To get started with this project, follow these steps:

1. Clone this repository to your local machine:

```sh
git clone https://github.com/mrsidrdx/wikipedia-search-app.git
```

2. Change directory to the project folder:

```sh
cd wikipedia-search-app
```

3. Install the dependencies:

```sh
flutter pub get
```

4. Run the app:

```sh
flutter run
```

## Usage

The app allows users to search for articles on Wikipedia using the Wikipedia API. Users can enter a search term in the search bar and click on the search button to get a list of articles related to the search term.

## Architecture

The app follows the BLoC pattern for state management. The `SearchBloc` handles the search logic and emits `SearchState` objects based on the search results.

## API Calls

The app uses the Dio package to make API calls to the Wikipedia API. The `SearchRepository` class handles the API calls and returns the search results.

## Themes

The app supports both dark and light themes. The theme is controlled by the `SettingsController` class which uses `ChangeNotifier` mixin , which updates the theme based on the system theme or the user's preference.

## Caching Mechanism

The app implements a caching mechanism to improve search performance and reduce API requests. The caching mechanism is implemented using shared preferences.

The `WikipediaSearchCache` class is responsible for caching search results. It uses the singleton pattern to ensure that there is only one instance of the class throughout the app. The class has two private properties `_cachedQueries` and `_cachedResults`. `_cachedQueries` is a list of the cached search queries, while `_cachedResults` is a map of cached search results.

The class has three static methods:

1. `init()`: Initializes the cache by loading cached queries and results from shared preferences.
2. `get(String query)`: Retrieves the cached search result for a given query. If the query is not found in the cache, it returns null.
3. `put(String query, Map<dynamic, dynamic> result)`: Adds a new search query and result to the cache. If the cache has reached its maximum capacity, it removes the oldest query and result to make room for the new ones.

The maximum capacity of the cache is set to 5. This means that the cache can store up to 5 search queries and results at a time.

The caching mechanism improves search performance by reducing the number of API requests made by the app. It also ensures that the app can still display search results even when there is no internet connection available.

## Contributing

Contributions to this project are welcome. If you would like to contribute, please fork the repository and submit a pull request.

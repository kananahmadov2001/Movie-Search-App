<div align="center">
    <h1 id="Header">Movie Search App</h1>
</div>

## Overview
```
Note: I developed this project as my Lab 4 assignment for my Mobile App. Dev. class at WashU.
```

The Movie Search App is a mobile application that allows users to search for movies, view details, and manage their favorites. This project was designed to practice working with APIs, collection views, and dynamic UI updates in Swift. The app provides a sleek interface for browsing movies and offers functionality for saving and reviewing favorite movies.

<div align="center">
    <img src="Movie-Search-Vertical.png" alt="screenshot" height="700px">
</div>

## Technologies/Frameworks Used
- **Language**: Swift
- **Frameworks**: UIKit, Auto Layout
- **Tools**: Xcode, Interface Builder
- **APIs**: The Movie Database (TMDb) API
- **Design Pattern**: MVC (Model-View-Controller)

## Features
1. **Movie Search**:  
   - Users can search for movies by title using the TMDb API.
   - Real-time updates display search results as users type.

2. **Movie Details**:  
   - Click on any movie to view detailed information such as:
     - Title
     - Description
     - Release date
     - Genre

3. **Favorites Management**:  
   - Save movies to a personalized favorites list.
   - Access and manage saved favorites in a separate view.

4. **Genre Filtering**:  
   - Browse movies by genre through a dedicated genre selection screen.

5. **Write Reviews**:  
   - Users can write reviews for movies and rate them.
   - Submitted reviews are displayed in the **Review View**.

## Project Structure
1. **AppDelegate.swift**: Handles app lifecycle events and configurations.
2. **SceneDelegate.swift**: Manages app scenes and UI lifecycle.
3. **MoviesViewController.swift**: Displays the main movie search interface and handles API interactions.
4. **MovieViewController.swift**: Presents detailed information for a selected movie.
5. **ReviewViewController.swift**: Allows users to write and view reviews for movies.
6. **GenreViewController.swift**: Enables users to filter movies by genre.
7. **Favorites.swift**: Manages data related to favorite movies.
8. **MovieCollectionCellView.swift**: Defines the layout and behavior of movie items displayed in the collection view.
9. **Movie.swift**: Defines the `Movie` model with attributes such as title, description, and genre.


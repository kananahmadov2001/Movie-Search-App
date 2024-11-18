Student: Kanan Ahmadov
Class: CSE 438 - Mobile App. Dev.
Assignment: Lab #4 (Movie Search Application)- Creative Feature Explanation

------------------------------------------------------------------------------------

1. What I implemented:

	- 1) User Reviews and Ratings System
	
		* I implemented a user reviews and ratings feature, allowing users to leave their own comments and rate movies from 1 to 5 stars.
	
	- 2) Displaying Movies by Genre (Though I couldn't finish this feature, have my code and viewcontroller, but had hard time debugging)
		
		* I tried to make users to explore movies by specific genres (Comedy, Romance, Action, Horror) in a visually organized way. By selecting a genre, users would 		see a collection of movie posters and titles in that genre.
	
	- 3) Movie Quote Generator

------------------------------------------------------------------------------------

2. How I implemented it:

	- 1) In MovieViewController, I added a "Write a Review" button. When tapped, it presents an alert where the user can enter a review and select a rating from 1 to 5. Reviews are saved to UserDefaults using the movie title as a unique identifier to ensure reviews are tied to specific movies. I used Codable to handle data encoding and decoding, allowing me to store reviews as structured data. I created a ReviewViewController linked to the tab bar where users can see all submitted reviews. The reviews are displayed in a table view, showing the movie title, rating, and user comment. I added validations to ensure only valid ratings are submitted. If the user attempts to add an invalid rating, they receive an error message. When a review is successfully submitted, a success alert confirms their review has been saved.

	- 2) I set up genre collections in the Interface by creating a new GenreViewController and linked it to the app’s Tab Bar. For each genre, I set up individual 	UICollectionViews in GenreViewController, each intended to display movies horizontally. To get movies in specific genres, I used The Movie Database (TMDb) API. By specifying the genre IDs in the API request, I pulled movies belonging to each genre separately.

	- 3) 

------------------------------------------------------------------------------------

3. Why I implemented it:

	- 1) The reviews and ratings system enhances the app's interactivity and user experience by enabling users to leave personalized feedback on movies; it makes the app feel more engaging and community-oriented.

	- 2) Offering genre-based browsing helps users find movies they’re interested in more easily.

	- 3) 

------------------------------------------------------------------------------------

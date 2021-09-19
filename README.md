# ios-themoviedb

## App Architecture
Apply MVVM architecture pattern. 

### Details
 1. **Overviews**
	 * Apply MVVM architecture pattern with Protocol Oriented Programming(POP)
 	 * 'Custom' folder contains custom views
 	 * 'Extensions' folder contains extensions of application
 	 * 'View Controllers' folder contains views of application
 	 * 'Services' folder contains class API services
 	 * 'iOS_TheMovieDBTests' contains unit test classes for ViewModels, Services

 2. **Custom Rating View**
	 * Create custom rating circle view

 3. **Photos**
	 * class PhotosViewController is an collection UICollectionViewController contains horizontal collection for Now Playing movies
	 * protocol PhotosViewModel and class PhotosViewModelImpl for viewmodel loading image and caching. Contain array image urls, manage collection data 
	 * use UICollectionViewFlowLayout to config collection layout
	 * create utilityQueue to handle image queue

 4. **Movie List**
	 * MovieListViewController contains table view that has 3 sections : Logo view, Now Playing movies, Popular movies
	 * + Load more movies by using func scrollViewDidEndDragging in UIScrollViewDelegate. When scrolling to bottom offset
	 * MovieViewModel
	 * + Control fetch data movies and page number
	 * + Control caching image, loading image 

 5. **Movie Detail**
	 * MovieDetailViewController shows movie detail 
	 * + Generate genres labels 
	 * + Loading image for movie detail

 6. **Unit Tests**
	 * Understand concept of Given-When-Then pattern
	 * In “given” part we should put object definitions, mocks definitions, whole initial assumptions.
	 * In “when” part we are putting action/behavior that we want to test.
	 * “Then” section is dedicated for verification part. Here we should put our assertions.
	 * Code Coverage

## Videos

https://youtu.be/PLkZeO-utm4

 

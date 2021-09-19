//
//  ViewController.swift
//  iOS_TheMovieDB
//
//  Copyright © 2021 PhucBui. All rights reserved.
//

import UIKit

enum MovieListType : String {
    case playing = "Playing now"
    case popular = "Most popular"
}

class MovieListViewController: UIViewController {
    
    private var viewModel : MovieViewModel!
    
    //MARK: - Outlets
    @IBOutlet weak var moviesTableView: UITableView!
    
    //MARK: - Private Declarations
    private var spinner = UIActivityIndicatorView(style: .large)
    
    private enum MovieTableSections : Int, CaseIterable {
        case logo = 0, playing, popular
    }
    
    private struct Constants {
        //colors
        static let backgroundTableViewColor = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1)
        static let titleHearderTableViewColor = UIColor(red: 252.0/255.0, green: 208.0/255.0, blue: 82.0/255.0, alpha: 1)
        static let backgroundHearderTableViewColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1)
        //keys
        struct Keys {
            static let posterImage : String = "poster_path"
            static let movieId : String = "id"
        }
       
        
        
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MovieViewModelImpl(nowPlayingService: MovieNowPlayingServiceImpl(), popularService: MoviePopularServiceImpl(), movieDetailService: MovieDetailServiceImpl())
        
        configureUI()
        
        loadData()
    }
    
    //MARK: - Private functions
    private func configureUI() {
        moviesTableView.backgroundColor = Constants.backgroundTableViewColor
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
       
        configSpinnerLoadingView()
    }
    
    ///
    /// Config Spinner Loading View
    ///
    private func configSpinnerLoadingView() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        //Autolayout
        spinner.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            spinner.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            spinner.widthAnchor.constraint(equalToConstant: 24),
            spinner.heightAnchor.constraint(equalToConstant: 24)
            
        ]
        NSLayoutConstraint.activate(constraints)
        
        spinner.isHidden = true
    }
    
    private func showSpinnerLoadingView(isShow: Bool) {
        if isShow {
            self.spinner.isHidden = false
            spinner.startAnimating()
        } else if spinner.isAnimating {
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
    
    ///
    /// Load Data
    ///
    private func loadData() {
        viewModel.fetchNowPlayingMovies { [weak self] in
            self?.moviesTableView.reloadData()
        }
        
        viewModel.fetchPopularMovies(pageNumber: viewModel.pageNumber) { [weak self] in
            self?.moviesTableView.reloadData()
        }
    }
    
    ///
    /// Load More Popular Movies
    ///
    private func loadMorePopularMovies() {
        //Increase page number
        let pageNumber = viewModel.pageNumber
        viewModel.pageNumber = pageNumber + 1
        //Start Spinner Loading View
        showSpinnerLoadingView(isShow: true)
        viewModel.fetchPopularMovies(pageNumber: viewModel.pageNumber) { [weak self] in
            //Stop Spinner Loading View
            self?.showSpinnerLoadingView(isShow: false)
            //Reload table view
            self?.moviesTableView.reloadSections(IndexSet(integer: 2), with: .none)
        }
    }

}

//MARK: - Tableview DataSource
extension MovieListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MovieTableSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0://Logo Movie
            return nil
        case 1://Playing Now
            return MovieListType.playing.rawValue
        case 2://Popular
            return MovieListType.popular.rawValue
        default:
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0://Logo Movie
            return 1
        case 1://Playing Now
            return 1
        case 2://Popular
           return viewModel.moviePopularArray.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0://Logo Movie
            
            let cell:LogoMovieCell = tableView.dequeueReusableCell(withIdentifier: LogoMovieCell.identifier,
                                                                   for: indexPath) as! LogoMovieCell
            return cell
        case 1://Playing Now
            
            //Get list images
            let urlImagesArray = viewModel.movieNowPlayingArray.map { (dictionary) -> String in
                let dict = dictionary as! [String: Any]
                return dict[Constants.Keys.posterImage] as! String
            }
            
            //create collection view image
            let viewModel = PhotosViewModelImpl(urlsArray: urlImagesArray)
            let photosViewController = PhotosViewController(viewModel: viewModel)
            self.addChild(photosViewController)
            
            //Create cell and add custom collection view image
            let cell:MoviePlayingCell = tableView.dequeueReusableCell(withIdentifier: MoviePlayingCell.identifier,
                                                                      for: indexPath) as! MoviePlayingCell
            cell.configure(customView: photosViewController.view)
            return cell
        case 2://Popular
            
            let cell:MovieCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier,
                                                               for: indexPath) as! MovieCell

            //configure data
            let movieDict = viewModel.moviePopularArray[indexPath.row] as! [String: Any]
            cell.configure(movieDictionary: movieDict)
            
            //Load image with caching
            let itemNumber = NSNumber(value: indexPath.item)
           
            if let cachedImage = self.viewModel.cache.object(forKey: itemNumber) {
                //print("Popular Movie using a cached image for item: \(itemNumber)")
                cell.configureImage(cachedImage)
            } else {
                let urlImageString = movieDict[Constants.Keys.posterImage] as? String ?? ""
                self.viewModel.loadImage(with: urlImageString) { [weak self] (image) in
                    guard let self = self, let image = image else { return }
                    
                    cell.configureImage(image)
                    self.viewModel.upsertCache(with: image, for: itemNumber)
                }
            }
            
            //Configure and get movie detail
            let movieId = movieDict[Constants.Keys.movieId] as? Int ?? -1
            cell.configure(movieId: movieId, viewModel: self.viewModel)
            
            return cell
        default:
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            return cell
        }

    }
}
 
//MARK: - TableView Delegate
extension MovieListViewController : UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 115// case header logo
        case 1:
            return 160// case playing now
        default:
            return 88// case popular
        }
    }

  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1, 2:
            return 20
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = Constants.backgroundHearderTableViewColor
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = Constants.titleHearderTableViewColor
        header.textLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.section {
        case 2://Popular movies
            //Show Movie Detail
            
            let movieDict = viewModel.moviePopularArray[indexPath.row] as! [String: Any]
            let movieId = movieDict[Constants.Keys.movieId] as? Int ?? -1
            if movieId != -1 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as! MovieDetailViewController
                movieDetailViewController.modalPresentationStyle = .overCurrentContext
                self.present(movieDetailViewController, animated: true, completion: nil)

                movieDetailViewController.loadMovieDetail(movieId: movieId)
            }
        break
        default:
            break
        }
    }
}

//MARK: - UIScrollViewDelegate
extension MovieListViewController : UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 15.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 15.0 {
            self.loadMorePopularMovies()
        }
    }

}

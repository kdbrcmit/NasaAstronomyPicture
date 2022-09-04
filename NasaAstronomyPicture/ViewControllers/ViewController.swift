//
//  ViewController.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 02/09/22.
//

import UIKit
import YouTubePlayer_Swift

class ViewController: UIViewController, BaseProtocol {
    var viewModel: ViewControllerVM!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var imageView: DownloadableImageView!
    @IBOutlet weak var headerUIView: UIView!
    @IBOutlet weak var headerUIBottomLabel: UILabel!
    @IBOutlet weak var changeDateButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageDetailTextView: UITextView!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    @IBOutlet weak var favouriteNavigationButton: UIBarButtonItem!
    @IBOutlet weak var themeNavigationButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(ViewControllerVM())
        setupDefaultValues()
        setBarButtonItems()
        setupUI()
    }
    
    /// Function to setup the Theme
    func setupUI() {
        self.view.backgroundColor = NAPThemeManager.current.backgroundColor.withAlphaComponent(0.9)
        self.headerUIView.backgroundColor = NAPThemeManager.current.backgroundColor
        self.headerUIBottomLabel.backgroundColor = NAPThemeManager.current.color_1a9cdf
        bookmarkButton.tintColor = .white
        bookmarkButton.backgroundColor = NAPThemeManager.current.color_0080ff
        bookmarkButton.layer.cornerRadius = 4
        changeDateButton.tintColor = .white
        changeDateButton.backgroundColor = NAPThemeManager.current.color_0080ff
        changeDateButton.layer.cornerRadius = 4
        self.imageDetailTextView.textColor = NAPThemeManager.current.textColor
        self.titleLabel.textColor = NAPThemeManager.current.textColor
        self.youtubePlayerView.layer.borderColor = NAPThemeManager.current.textColor.cgColor
        self.youtubePlayerView.layer.cornerRadius = 4
        self.youtubePlayerView.layer.borderWidth = 1
        activityIndicator.color = NAPThemeManager.current.textColor
        dateTextField.backgroundColor = NAPThemeManager.current.color_1a9cdf
        dateTextField.textColor = NAPThemeManager.current.textColor
    }
    
    /// TODO: Better to keep this code in separate Naviagtion Bar subclass
    /// get Bar Button Item For Theme
    private func setBarButtonItems() {
        let themeTitle = NAPThemeManager.current is NAPLightTheme ? "dark" : "light"
        themeNavigationButton.title = themeTitle.localized
        themeNavigationButton.applyStyle()
        
        favouriteNavigationButton.title = "favourite".localized
        favouriteNavigationButton.applyStyle()
    }
    
    /// Function called when user click on favourite button
    @IBAction func favouriteNavigationButtonClicked(_ sender: Any) {
        let casesController: FavouriteViewController = UIStoryboard(.Main).getController()
        casesController.configure(FavouriteViewControllerVM())
        self.navigationController?.pushViewController(casesController, animated: true)
    }
    
    /// Function called when theme button is clicked
    @IBAction func themeNavigationButtonClicked(_ sender: Any) {
        if NAPThemeManager.current is NAPLightTheme {
            NAPThemeManager.setTheme = .dark
            navigationItem.rightBarButtonItem?.title = "light".localized
        } else {
            NAPThemeManager.setTheme = .light
            navigationItem.rightBarButtonItem?.title = "dark".localized
        }
        setupUI()
    }
    
    /// Function called when bookmark button clicked
    @IBAction func bookmarkButtonClicked(_ sender: Any) {
        bookmarkButton.isSelected = !bookmarkButton.isSelected
        viewModel.changeBookmarkStatus(bookmarkButton.isSelected)
        
    }
    
    /// Function used to configure the values
    func configure(_ viewModel: ViewControllerVM) {
        self.viewModel = viewModel
    }
    
    /// Function to setup the default values
    func setupDefaultValues() {
        self.title = "nasa_astrology".localized
        dateChanged(Date())
    }
    
    /// Function called when calendar button is clicked
    @IBAction func selectDateButtonClicked(_ sender: Any) {
        /// picker code is copied from Raywenderlich
        let pickerController = CalendarPickerViewController(
            baseDate: self.viewModel.selectedDate ?? Date(),
            selectedDateChanged: { [weak self] date in
                self?.dateChanged(date)
            })
        
        present(pickerController, animated: true, completion: nil)
    }
    
    /// Function called when new date is selected by user
    func dateChanged(_ date: Date) {
        resetViews()
        if self.viewModel.isValidDate(date) {
            self.imageViewHeightConstraints.isActive = false
            self.activityIndicator.isHidden = false
            self.dateTextField.text = self.viewModel.getStringValueForSelectedDate(date)
            self.viewModel.fetchAstronomyImage(date) { [weak self] result in
                switch result {
                case .success(_):
                    self?.titleLabel.text = self?.viewModel.response?.title
                    self?.imageDetailTextView.text = self?.viewModel.response?.explanation
                    self?.handleMedia()
                    self?.handleBookmark()
                case .failure(let error):
                    self?.activityIndicator.isHidden = true
                    let alert = UIAlertController(title: "error".localized,
                                                  message: error.localizedDescription,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            self.dismiss(animated: true)
        }
    }
    
    /// Function to handle the bookmark button status
    func handleBookmark() {
        self.bookmarkButton.isSelected = viewModel.isBookmarked()
        self.bookmarkButton.isHidden = false
    }
    
    /// Function to handle the Media
    func handleMedia() {
        if self.viewModel.response?.mediaType == .image {
            self.imageView.downloaded(from: self.viewModel.response?.url ?? "") {
                self.activityIndicator.isHidden = true
                self.imageView.isHidden = false
            }
        } else {
            self.imageViewHeightConstraints.isActive = true
            youtubePlayerView.playerVars = ["playsinline": "1" as AnyObject]
            youtubePlayerView.loadVideoURL(viewModel.response?.url)
            youtubePlayerView.delegate = self
            youtubePlayerView.isHidden = false
        }
    }
    
    /// Function to reset the UI
    func resetViews() {
        self.titleLabel.text = ""
        self.imageDetailTextView.text = ""
        self.imageView.image = nil
        self.imageView.isHidden = true
        self.bookmarkButton.isHidden = true
        self.youtubePlayerView.isHidden = true
    }
}

extension ViewController: YouTubePlayerDelegate {
    /// Function called when player is ready
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        Logger.d("Video player is ready")
        self.activityIndicator.isHidden = true
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        Logger.d("Video Player state changed \(playerState)")
    }
    
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        Logger.d("Video quality changed")
    }
}


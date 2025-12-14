import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Lifecycle
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        showBounds()
    }
    
    // MARK: - Private functions
    
    func showLoadingIndicator() -> Void {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() -> Void {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) -> Void {
        hideLoadingIndicator()
        
        let model = AlertModel(
            title: errorInfoText,
            message: message,
            buttonText: rebootTextForButton) { [weak self] in
                guard let self else { return }
                presenter.restartGame()
            }
        
        alertPresenter.show(in: self, model: model)
    }
    
    private func showBounds() -> Void {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func clearImageBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func show(quiz step: QuizStepViewModel) -> Void {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        return formatter.string(from: date)
    }
    
    func show(quiz result: QuizResultViewModel) -> Void {
        let message = presenter.makeResultsMessage()
        let model = AlertModel(title: result.title, message: message, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            
            presenter.restartGame()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) -> Void {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
}

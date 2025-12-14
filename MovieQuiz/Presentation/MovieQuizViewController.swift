import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol?
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statisticService = StatisticService()
        self.statisticService = statisticService
        presenter = MovieQuizPresenter(viewController: self)
        
        presenter.statisticService = statisticService
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
    
    func showAnswerResult(isCorrect: Bool) -> Void {
        presenter.disableButtons(state: true)
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.presenter.showNextQuestionOrResults()
        }
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
        let dateString = formatDate(statisticService?.bestGame.date ?? Date())
        
        let text = """
            \(result.text)
            Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)
            Рекорд \(statisticService?.bestGame.correct ?? 0)/10 (\(dateString))
            Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0.0))%
        """
        
        let model = AlertModel(title: result.title, message: text, buttonText: result.buttonText) { [weak self] in
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

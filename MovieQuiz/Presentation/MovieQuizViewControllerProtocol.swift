//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    var yesButton: UIButton! { get set }
    var noButton: UIButton! { get set }
    
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func clearImageBorder()
}

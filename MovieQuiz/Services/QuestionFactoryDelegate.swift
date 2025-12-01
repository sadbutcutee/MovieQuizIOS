//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?) -> Void
    func didLoadDatafromServer()
    func didFailToLoadData(with error: Error)
}

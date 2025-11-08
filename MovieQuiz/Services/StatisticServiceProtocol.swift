//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    var totalCorrectAnswers: Int { get }
    var totalQuestionsAsked: Int { get }
    
    func store(correct count: Int, total amount: Int)
}

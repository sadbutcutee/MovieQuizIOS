//
//  StatisticService.swift
//  MovieQuiz
//
//

import Foundation

final class StatisticService { private let storage: UserDefaults = .standard }

extension StatisticService: StatisticServiceProtocol {
    
    private enum DefaultsKeys: String {
        case totalCorrectAnswers
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
    }
    
    var totalCorrectAnswers: Int {
        get {
            return storage.integer(forKey: DefaultsKeys.totalCorrectAnswers.rawValue)
        }
        
        set {
            storage.set(newValue, forKey: DefaultsKeys.totalCorrectAnswers.rawValue)
        }
    }
    
    var totalQuestionsAsked: Int {
        return gamesCount * 10
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: DefaultsKeys.gamesCount.rawValue)
        }
        
        set {
            storage.set("\(newValue)", forKey: DefaultsKeys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: DefaultsKeys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: DefaultsKeys.bestGameTotal.rawValue)
            let date = storage.object(forKey: DefaultsKeys.bestGameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        
        set {
            storage.set(newValue.correct, forKey: DefaultsKeys.bestGameCorrect.rawValue)
            
            storage.set(newValue.total, forKey: DefaultsKeys.bestGameTotal.rawValue)
            
            storage.set(newValue.date, forKey: DefaultsKeys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        guard totalQuestionsAsked > 0 else { return 0.0 }
        return (Double(totalCorrectAnswers) / Double(totalQuestionsAsked)) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        totalCorrectAnswers += count
        gamesCount += 1
        
        let currentAccuracy: Double = Double(count) / Double(amount)
        let bestAccuracy =  bestGame.total > 0 ? Double(bestGame.correct) / Double(bestGame.total) : 0
        
        if currentAccuracy > bestAccuracy {
            bestGame = GameResult(correct: count, total: amount, date: Date())
        }
    }
}


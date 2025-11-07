//
//  GameResult.swift
//  MovieQuiz
//
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        self.correct > another.correct
    }
}

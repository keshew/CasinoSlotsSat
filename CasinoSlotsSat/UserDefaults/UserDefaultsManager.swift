import SwiftUI

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard

    private init() {}

    // MARK: - Игры
    var totalGames: Int {
        get { defaults.integer(forKey: "totalGames") }
        set { defaults.set(newValue, forKey: "totalGames") }
    }
    
    func incrementTotalGames() {
        totalGames += 1
    }
    
    var game1Played: Bool {
        get { defaults.bool(forKey: "game1Played") }
        set { defaults.set(newValue, forKey: "game1Played") }
    }
    var game2Played: Bool {
        get { defaults.bool(forKey: "game2Played") }
        set { defaults.set(newValue, forKey: "game2Played") }
    }
    var game3Played: Bool {
        get { defaults.bool(forKey: "game3Played") }
        set { defaults.set(newValue, forKey: "game3Played") }
    }
    var game4Played: Bool {
        get { defaults.bool(forKey: "game4Played") }
        set { defaults.set(newValue, forKey: "game4Played") }
    }
    
    var allFourGamesPlayed: Bool {
        return game1Played && game2Played && game3Played && game4Played
    }

    var coins: Int {
        get { defaults.integer(forKey: "coins") }
        set { defaults.set(newValue, forKey: "coins") }
    }

    func addCoins(_ amount: Int) {
        coins += amount
        addToTotalWins(amount)
        checkMaxSingleWin(amount)
    }

    func removeCoins(_ amount: Int) {
        coins = max(coins - amount, 0)
    }

     var totalWins: Int {
        get { defaults.integer(forKey: "totalWins") }
        set { defaults.set(newValue, forKey: "totalWins") }
    }
    
    private func addToTotalWins(_ amount: Int) {
        totalWins += amount
    }
    
    var hasBigTotalWin: Bool {
        return totalWins > 10000
    }
    
     var hasWon1000Once: Bool {
        get { defaults.bool(forKey: "hasWon1000Once") }
        set { defaults.set(newValue, forKey: "hasWon1000Once") }
    }
    
    private func checkBigWin(_ amount: Int) {
        if amount >= 1000 {
            hasWon1000Once = true
        }
    }
    
    private func checkMaxSingleWin(_ amount: Int) {
        if amount > maxSingleWin {
            maxSingleWin = amount
        }
        checkBigWin(amount)
    }
    
     var maxSingleWin: Int {
        get { defaults.integer(forKey: "maxSingleWin") }
        set { defaults.set(newValue, forKey: "maxSingleWin") }
    }
    
    var hasPlayed100Games: Bool {
        return totalGames >= 100
    }

    var totalSpins: Int {
        get { defaults.integer(forKey: "totalSpins") }
        set { defaults.set(newValue, forKey: "totalSpins") }
    }

    func incrementSpins() {
        totalSpins += 1
    }
    
    func resetAllData() {
        let keys = [
            "totalGames",
            "game1Played",
            "game2Played",
            "game3Played",
            "game4Played",
            "coins",
            "totalWins",
            "hasWon1000Once",
            "maxSingleWin",
            "totalSpins"
        ]
        for key in keys {
            defaults.removeObject(forKey: key)
        }
        coins = 5000
    }

}

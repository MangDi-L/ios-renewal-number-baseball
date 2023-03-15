//
//  NumberBaseballGame.swift
//  NumberBaseball
//
//  Created by Mangdi on 2023/03/15.
//

import Foundation

struct NumberBaseballGame {
    var computerNumbers: [Int] = []
    var userNumbers: [Int] = []
    var tryNumber = 9
    let inputCount = 3

    func generateThreeRandomNumbers() -> [Int] {
        var numbers: Set<Int> = []

        while numbers.count < inputCount {
            let num = Int.random(in: 1...9)
            numbers.update(with: num)
        }
        return Array(numbers)
    }

    func foundBall() -> Int {
        var ballCount = 0
        let pairNumbers = zip(userNumbers, computerNumbers)

        for (userNumber, computerNumber) in pairNumbers {
            if computerNumbers.contains(userNumber) && userNumber != computerNumber {
                ballCount += 1
            }
        }
        return ballCount
    }

    func foundStrike() -> Int {
        var strikeCount = 0
        let pairNumbers = zip(userNumbers, computerNumbers)

        for (userNumber, computerNumber) in pairNumbers {
            if userNumber == computerNumber {
                strikeCount += 1
            }
        }
        return strikeCount
    }

    enum InputError: Error {
        case countError(message: String)
        case numberError(message: String)
        case rangeError(message: String)
    }

    func filter(userInput: [String]) throws {
        let errorSentence: String = """
        입력이 잘못되었습니다.
        숫자 3개를 띄어쓰기로 구분하여 입력해주세요.
        중복 숫자는 허용하지 않습니다.
        """

        if Set(userInput).count != inputCount {
            throw InputError.countError(message: errorSentence)
        }

        for number in userInput {
            guard let individualNumber = Int(number) else {
                throw InputError.countError(message: errorSentence)
            }
            if individualNumber > 9 || individualNumber < 1 {
                throw InputError.rangeError(message: errorSentence)
            }
        }
    }

    func executeFilter(input: [String]) -> Bool {
        do {
            try filter(userInput: input)
        } catch InputError.countError(let message) {
            print(message)
            return false
        } catch InputError.numberError(let message) {
            print(message)
            return false
        } catch InputError.rangeError(let message) {
            print(message)
            return false
        } catch {
            print("someError")
            return false
        }
        return true
    }

    func bringUserInput() -> [String] {
        print("입력 : ", terminator: "")

        guard let userInput = readLine()?.components(separatedBy: " ") else {
            return []
        }
        return userInput
    }

    func checkUserVictory() -> Bool {
        let victoryCount = 3

        if tryNumber == 0 && foundStrike() == victoryCount {
            return true
        } else if tryNumber != 0 && foundStrike() == victoryCount {
            return true
        }
        return false
    }

    mutating func startBaseBallGame() {
        computerNumbers = generateThreeRandomNumbers()

        while(tryNumber > 0) {
            userNumbers.removeAll()

            let tryUserInput = bringUserInput()

            if executeFilter(input: tryUserInput) == false {
                userNumbers.removeAll()
                continue
            } else {
                userNumbers = tryUserInput.compactMap { Int($0) }
            }

            tryNumber -= 1
            let strikeCount = foundStrike()
            let ballCount = foundBall()

            print(strikeCount ," 스트라이크,", ballCount, " 볼")

            if checkUserVictory() {
                print("사용자 승리!")
                break
            } else if tryNumber == 0 {
                print("컴퓨터 승리...!")
                break
            }
            print("남은 기회 : \(tryNumber)")
        }
    }

    mutating func selectMenu() {
        let gameStartNumber = 1
        let gameExitNumber = 2
        var isExitSelectMenu = false

        while isExitSelectMenu == false {
            tryNumber = 9
            print("1. 게임시작")
            print("2. 게임종료")
            print("원하는 기능을 선택해 주세요",terminator: " ")

            guard let menuInput = readLine() else { continue }

            let userChoiceMenuNumber = Int(menuInput.replacingOccurrences(of: " ", with: ""))


            if userChoiceMenuNumber == gameStartNumber {
                startBaseBallGame()
            } else if userChoiceMenuNumber == gameExitNumber {
                print("게임을 종료합니다.")
                isExitSelectMenu = true
            } else {
                print("입력이 잘못되었습니다.")
                continue
            }
        }
    }
}

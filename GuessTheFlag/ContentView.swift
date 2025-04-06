//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Fazliddin Abdazimov on 01/04/25.
//

import SwiftUI

private enum ActiveAlert: Identifiable {
    case score(title: String, points: Int)
    case finish(points: Int)
    
    var id: String {
        switch self {
        case .score: return "score"
        case .finish: return "finish"
        }
    }
}

struct ContentView: View {
    @State var countries: [String] = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "United Kingdom", "Ukraine", "United States"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    @State private var activeAlert: ActiveAlert?
    @State private var scorePoints: Int = 0
    @State private var questionsCount: Int = 8
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(self.countries[number])
                                .clipShape(.rect(cornerRadius: 20))
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(scorePoints) / \(questionsCount)")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding()
        }
        .alert(item: $activeAlert) { alert in
            switch alert {
                case .score(let title, let points):
                return Alert(title: Text(title), message: Text("Your score is: \(points)"), dismissButton: .default(Text("continue"), action: askQuestion))
                case .finish(points: let points):
                return Alert(title: Text("🥳You Won!!!"), message: Text("Your score is: \(points)"), dismissButton: .default(Text("Play again"), action: restart))
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scorePoints += 1
            activeAlert = .score(title: "Correct!", points: scorePoints)
        } else {
            activeAlert = .score(title: "Wrong that's a flag of \(countries[number])", points: scorePoints)
        }
        
        guard scorePoints < questionsCount else {
            return activeAlert = .finish(points: scorePoints)
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restart() {
        scorePoints = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}

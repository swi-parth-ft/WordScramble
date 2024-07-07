//
//  ContentView.swift
//  WordScramble
//
//  Created by Parth Antala on 2024-07-07.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var reset = false
    @State private var showSparks = false
    
    var scene: SKScene {
        let scene = SparkScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        return scene
    }

    var body: some View {
        NavigationStack {
            ZStack {
                
                
                
                MeshGradient(width: 3, height: 3, points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [0.5, 0.5], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ], colors: [
                    .yellow, .white, .white,
                    .orange, .white, .yellow,
                    .yellow, .yellow, .orange
                ])
                .ignoresSafeArea()
                
              
                
                VStack {
                VStack {
                    
                    
                    List() {
                        ZStack {
                            Text(rootWord)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.system(size: 42, weight: .bold))
                        }
                        .listRowBackground(Color.white.opacity(0.5))
                        
                        
                        Section {
                            TextField("Enter your word", text: $newWord)
                                .textInputAutocapitalization(.never)
                        }
                        .listRowBackground(Color.white.opacity(0.5))
                        
                        Section {
                            ForEach(usedWords, id: \.self) { word in
                                HStack {
                                    Image(systemName: "\(word.count).circle")
                                    Text(word)
                                }
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.5))
                        
                    }
                    .scrollContentBackground(.hidden)
                
                   
                    
                }
                .navigationTitle("Word Scramble")
                .navigationBarTitleDisplayMode(.inline)
                .onSubmit(addNewWord)
                .onAppear(perform: startGame)
                .alert(errorTitle, isPresented: $showingError) {
                    Button("OK") {}
                } message: {
                    Text(errorMessage)
                }
                .overlay(
                    ConfettiView(isActive: $showSparks)
                                .frame(width: 300, height: 300)
                                .opacity(showSparks ? 1 : 0)
                )
                    
                
                
                    VStack {
                        Button{
                            startGame()
                            reset.toggle()
                            usedWords = []
                        } label: {
                            Label("Reset", systemImage: "gobackward")
                                .symbolEffect(.rotate, value: reset)
                                
                        }
                        .buttonStyle()
                    }
            }
                
            }
            
        }
        
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "word not possible", message: "you can't spell that word from \(rootWord)")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "word not recognized", message: "you can't just make them up!")
            return
        }
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
        showConfettiEffect()
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allwords = startWords.components(separatedBy: "\n")
                rootWord = allwords.randomElement() ?? "silkworm"
                return
            }
            
        }
        
        fatalError("Could not load the file.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var temp = rootWord
        
        for letter in word {
            if let pos = temp.firstIndex(of: letter) {
                temp.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    private func showConfettiEffect() {
        showSparks = true
        withAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showSparks = false
            }
        }
       }
}


struct ButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .tint(.white.opacity(0.4))
            .cornerRadius(20)
            .shadow(radius: 10)
    }
}

extension View {
    func buttonStyle() -> some View {
        modifier(ButtonViewModifier())
    }
}


#Preview {
    ContentView()
}

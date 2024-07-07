# WordScramble

Created by Parth Antala on 2024-07-07

## Overview
WordScramble is an interactive iOS game developed using SwiftUI and SpriteKit. The game challenges players to create as many unique words as possible from a randomly chosen root word.

## Features
- Dynamic word list generation.
- Real-time word validation and error handling.
- Interactive and animated user interface with SpriteKit effects.
- Custom mesh gradient background.

## Screenshots
Include some screenshots here to give a visual overview of the app.

## Getting Started

### Prerequisites
- Xcode 12 or later
- iOS 14 or later

### Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/wordscramble.git
    ```
2. Open the project in Xcode:
    ```bash
    cd wordscramble && open WordScramble.xcodeproj
    ```
3. Build and run the project on your preferred simulator or device.

## Usage
1. Launch the app to start a new game.
2. Enter words using the provided text field.
3. Submit words to see if they are valid and get scored accordingly.
4. Press the reset button to start a new game.

## Code Overview

### Main Components
- `ContentView.swift`: The main view of the app, handling the user interface and game logic.
- `SparkScene.swift`: Defines the SpriteKit scene for visual effects.

### Key Functions
- `addNewWord()`: Validates and adds new words to the list of used words.
- `startGame()`: Initializes the game with a random root word.
- `isOriginal(word: String) -> Bool`: Checks if the word has already been used.
- `isPossible(word: String) -> Bool`: Checks if the word can be made from the root word.
- `isReal(word: String) -> Bool`: Checks if the word is a valid English word.
- `wordError(title: String, message: String)`: Displays an error alert.
- `showConfettiEffect()`: Shows a confetti animation when a valid word is added.


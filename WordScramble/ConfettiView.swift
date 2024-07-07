//
//  ConfettiView.swift
//  WordScramble
//
//  Created by Parth Antala on 2024-07-07.
//

import SwiftUI
import SpriteKit

struct ConfettiView: UIViewRepresentable {
    @Binding var isActive: Bool

    class Coordinator: NSObject {
        var parent: ConfettiView
        var emitter: SKEmitterNode?

        init(parent: ConfettiView) {
            self.parent = parent
        }

        func startConfetti() {
            if let emitter = self.emitter {
                emitter.particleBirthRate = 300
                emitter.particleSpeed = 100
                emitter.particleLifetime = 5
            }
        }

        func stopConfetti() {
            if let emitter = self.emitter {
                // Reduce particle birth rate to 0
                emitter.particleBirthRate = 0

                // Create a smooth transition for particles to fall down and disappear
                let fallAction = SKAction.run {
                    emitter.particleSpeed = 600
                    emitter.particleLifetime = 2
                    emitter.yAcceleration = 300
                }

                // Sequence to wait for particles to fall and then remove them
                let sequence = SKAction.sequence([fallAction, SKAction.wait(forDuration: 2)])
                emitter.run(sequence)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.backgroundColor = .clear
        skView.allowsTransparency = true

        let scene = SKScene(size: CGSize(width: 300, height: 300))
        scene.backgroundColor = .clear

        if let emitter = SKEmitterNode(fileNamed: "Sparks.sks") {
            emitter.position = CGPoint(x: scene.size.width / 2, y: scene.size.height)
            emitter.particlePositionRange = CGVector(dx: scene.size.width, dy: 0)
            context.coordinator.emitter = emitter
            scene.addChild(emitter)
        }

        skView.presentScene(scene)
        return skView
    }

    func updateUIView(_ uiView: SKView, context: Context) {
        if isActive {
            context.coordinator.startConfetti()
        } else {
            context.coordinator.stopConfetti()
        }
    }
}




#Preview {
    ContentView()
}

//
//  GameScene.swift
//  Lab9_2024
//
//  Created by IMD 224 on 2024-03-22.
//
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sprite : SKSpriteNode!
    let spriteCategory1 : UInt32 = 0b1
    let spriteCategory2 : UInt32 = 0b10
    var opponentSprite: SKSpriteNode!
    var score : SKLabelNode!
    var touch : Int = 0
    
    override func didMove(to view: SKView) {
        opponentSprite = SKSpriteNode(imageNamed: "OpponentSprite")
        opponentSprite.position = CGPoint(x: size.width / 2, y: size.height)
        addChild(opponentSprite)
        
        let downMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: 0), duration: 1)
        let upMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height), duration: 1)
        let movement = SKAction.sequence([downMovement, upMovement])
        //opponentSprite.run(SKAction.repeatForever(movement))
        moveOpponent()
        
        sprite = SKSpriteNode(imageNamed: "PlayerSprite")
        sprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(sprite)
        //sprite.size = CGSize(width: 50, height: 50)
        
        score = SKLabelNode(text: "0")
        score.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(score)
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        opponentSprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        sprite.physicsBody?.categoryBitMask = spriteCategory1
        sprite.physicsBody?.contactTestBitMask = spriteCategory1
        sprite.physicsBody?.collisionBitMask = spriteCategory1
        opponentSprite.physicsBody?.categoryBitMask = spriteCategory1
        opponentSprite.physicsBody?.contactTestBitMask = spriteCategory1
        opponentSprite.physicsBody?.collisionBitMask = spriteCategory1
        self.physicsWorld.contactDelegate = self
        
    }
    
    //    func moveOpponent() {
    //        let randomX = GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.width))
    //        let randomY = GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.height))
    //        let movement = SKAction.move(to: CGPoint(x: randomX, y: randomY), duration: 1)
    //        opponentSprite.run(movement, completion: { [unowned self] in
    //            self.moveOpponent()
    //        })
    //    }
    
    func moveOpponent() {
        let randomX = GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.width))
        let randomY = GKRandomSource.sharedRandom().nextInt(upperBound: Int(self.size.height + opponentSprite.size.height))
        
        // let movement = SKAction.move(to: CGPoint(x: randomX, y: randomY), duration: 5)
        let moveDownAction = SKAction.moveTo(y: -opponentSprite.size.height, duration: 2)
        
        opponentSprite.run(moveDownAction, completion: { [unowned self] in
            self.moveOpponent()
        })
        
        let resetPositionAction = SKAction.run {
            // Nueva posición X aleatoria
            let newXPosition = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(self.size.width)))
            self.opponentSprite.position = CGPoint(x: newXPosition, y: self.size.height + self.opponentSprite.size.height)
        }
        
        let sequenceAction = SKAction.sequence([moveDownAction, resetPositionAction])
        // Repetir la secuencia indefinidamente
        opponentSprite.run(SKAction.repeatForever(sequenceAction))
    }
    
    func moveOpponent1() {
        // Configura la posición inicial del oponente fuera de la pantalla en la parte superior en una posición X aleatoria
        let randomXPosition = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.width)))
        opponentSprite.position = CGPoint(x: randomXPosition, y: self.size.height + opponentSprite.size.height)
        
        // Acción para mover al oponente directamente hacia abajo en el eje Y
        let moveDownAction = SKAction.moveTo(y: -opponentSprite.size.height, duration: 2)
        
        // Acción para "resetear" al oponente en una nueva posición aleatoria en X en la parte superior después de caer
        let resetPositionAction = SKAction.run {
            // Nueva posición X aleatoria
            let newXPosition = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(self.size.width)))
            self.opponentSprite.position = CGPoint(x: newXPosition, y: self.size.height + self.opponentSprite.size.height)
        }
        
        // Secuencia: mover hacia abajo y luego resetear la posición
        let sequenceAction = SKAction.sequence([moveDownAction, resetPositionAction])
        
        // Repetir la secuencia indefinidamente
        opponentSprite.run(SKAction.repeatForever(sequenceAction))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Hit!")
        touch += 1
        score.text = String(touch)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        sprite.run(SKAction.move(to: pos, duration: 1))
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
        sprite.run(SKAction.move(to: pos, duration: 1))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
}

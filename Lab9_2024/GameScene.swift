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
    var collisionOccured: Bool = false
    var originalPlayerYPosition: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        opponentSprite = SKSpriteNode(imageNamed: "OpponentSprite")
        opponentSprite.position = CGPoint(x: size.width / 2, y: size.height)
        addChild(opponentSprite)
        
        sprite = SKSpriteNode(imageNamed: "PlayerSprite")
        sprite.position = CGPoint(x: size.width / 2, y: sprite.size.height / 2 + 40)
        addChild(sprite)
        originalPlayerYPosition = sprite.position.y + 20
        //sprite.size = CGSize(width: 50, height: 50)
        
        //        let downMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: 0), duration: 1)
        //        let upMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height), duration: 1)
        //        let movement = SKAction.sequence([downMovement, upMovement])
        //        opponentSprite.run(SKAction.repeatForever(movement))
        
        score = SKLabelNode(text: "0")
        score.fontSize = 80
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
        
        moveOpponent()
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
        // X random
        let randomXPosition = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(self.size.width)))
        
        opponentSprite.position = CGPoint(x: randomXPosition, y: self.size.height + opponentSprite.size.height)
        // move opponent to botom
        let moveDownAction = SKAction.moveTo(y: -opponentSprite.size.height, duration: 2)
        
        // reset new x postiton
        let resetPositionAction = SKAction.run {
            let newXPosition = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(self.size.width)))
            self.opponentSprite.position = CGPoint(x: newXPosition, y: self.size.height + self.opponentSprite.size.height)
            // change the score
            if !self.collisionOccured {
                self.calculateScore(by: -1)
            }
            self.collisionOccured = false
            self.sprite.position.y = self.originalPlayerYPosition
        }
        
        // Secuencia: mover hacia abajo y luego resetear la posición
        let sequenceAction = SKAction.sequence([moveDownAction, resetPositionAction,])
        // Repetir la secuencia indefinidamente
        opponentSprite.run(SKAction.repeatForever(sequenceAction))
        
    }
    
    //    func didBegin(_ contact: SKPhysicsContact) {
    //        print("Hit!")
    //        touch += 1
    //        score.text = String(touch)
    //
    //    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Hit!")
        self.calculateScore(by: 1)
        self.collisionOccured = true
    }
    
    func calculateScore(by amount: Int)
    {
        touch += amount
        if touch < 0 {
            touch = 0
            endGame()
        }
        score.fontSize = 80
        score.text = "\(touch)"
    }
    
    func endGame() {
        print("End")
        self.removeAllActions()
        opponentSprite.removeAllActions()
        sprite.removeAllActions()
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = SKColor.yellow
        gameOverLabel.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2) + 100)
        addChild(gameOverLabel)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        //sprite.run(SKAction.move(to: pos, duration: 1))
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
        //sprite.run(SKAction.move(to: pos, duration: 1))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let newX = touchLocation.x
            let newY = sprite.position.y
            let moveAction = SKAction.move(to: CGPoint(x: newX, y: newY), duration: 0.8) // with speed
            // animation
            sprite.run(moveAction)
        }
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


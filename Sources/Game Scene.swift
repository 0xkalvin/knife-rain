import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    var balaozinho:SKSpriteNode = SKSpriteNode(imageNamed:"balao.png")
    var faca:SKSpriteNode = SKSpriteNode(imageNamed: "faca.png")
    var pressionado:Bool = false
    public override func sceneDidLoad(){
        self.backgroundColor = .black
        
        balaozinho.position = CGPoint(x: size.width/2, y: size.height/2)
        balaozinho.setScale(0.2)
        balaozinho.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "balao.png"), size: balaozinho.size)
        balaozinho.physicsBody!.affectedByGravity = false
        self.addChild(balaozinho)
        
        faca.setScale(0.2)
        faca.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "faca.png"), size: faca.size)
        
        balaozinho.physicsBody!.categoryBitMask = 0x1           //0x1 = 001
        faca.physicsBody!.categoryBitMask = 0x1 << 1             //0x1 < 1 = 010 = 2
        //0x1 < 2 = 100 = 4
        
        balaozinho.physicsBody!.contactTestBitMask = 0x1 << 1    //balao contato com faca
        faca.physicsBody!.contactTestBitMask = 0x1              //faca contato com balao
        
        self.physicsWorld.contactDelegate = self
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        balaozinho.removeFromParent()
        isPaused = true
    }
    
    public override func didMove(to view: SKView) {
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let nodesTocados = nodes(at: pos)
        if(nodesTocados.contains(balaozinho)){
            pressionado = true
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if(pressionado){
          balaozinho.position = pos
            balaozinho.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        pressionado = false
    }
    
    public func gerarFaca(){
        if(Int.random(in: 0...100) % 10 == 0){
            let novaFaca:SKSpriteNode = faca.copy() as! SKSpriteNode
            let xRandom = CGFloat(Float.random(in: 0.0...Float(size.width)))
            novaFaca.position = CGPoint(x:xRandom, y:size.height)
            addChild(novaFaca)
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        gerarFaca()
    }
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
}

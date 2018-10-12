import SpriteKit

class GameViewController: UIViewController {
  override func viewDidLoad() {
    let scene = GameScene(size: view.frame.size)
    let skView = view as! SKView
    skView.ignoresSiblingOrder = true
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.presentScene(scene)
  }
  override var prefersStatusBarHidden: Bool {
    return true
  }
}

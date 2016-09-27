//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Praneet Jain on 11/17/15.
//  Copyright © 2015 Praneet Jain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    // 1 = noughts, 2 = crosses
    var activePlayer = 1
    
    var gameActive = true
    
    var gameState = [0,0,0,0,0,0,0,0,0]
    
    var winningCombinations = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    
    @IBAction func playAgainTapped(_ sender: AnyObject) {
        
         activePlayer = 1
        
         gameActive = true
        
         gameState = [0,0,0,0,0,0,0,0,0]

        
        
        var button : UIButton
        
        for i in 1 ..< 10 {
            
        button = view.viewWithTag(i) as! UIButton
        
        button.setImage(nil, for: UIControlState())
        }
        
        gameOverLabel.isHidden = true
        
        playAgainButton.isHidden = true
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        gameOverLabel.center = CGPoint(x: gameOverLabel.center.x - 400, y: gameOverLabel.center.y)
        playAgainButton.center = CGPoint(x: playAgainButton.center.x - 400, y: playAgainButton.center.y)

        gameOverLabel.isHidden=true
        playAgainButton.isHidden=true
    
    }

    @IBAction func buttonTapped(_ sender: AnyObject) {
        
        if gameState[sender.tag-1] == 0 && gameActive == true{
        
        var image = UIImage()
        
        gameState[sender.tag-1] = activePlayer
        
        if activePlayer == 1 {
        image = UIImage(named: "nought.png")!
        
            activePlayer = 2
        }else{
            image = UIImage(named: "cross.png")!

            activePlayer = 1
        }
        
        sender.setImage(image, for: UIControlState())
            
            for combination in winningCombinations {
            
                if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]] {
            
                    var labelText = "Noughts has won"
                    
                    if gameState[combination[0]] == 2{

                        labelText = "Crosses has won"
                    }
                    
                    gameOverLabel.text = labelText
                    
                    gameOverLabel.isHidden = false
                    playAgainButton.isHidden = false
                    
UIView.animate(withDuration: 0.5, animations: { () -> Void in
    
    self.gameOverLabel.center = CGPoint(x: self.gameOverLabel.center.x + 400, y: self.gameOverLabel.center.y)
    self.playAgainButton.center = CGPoint(x: self.playAgainButton.center.x + 400, y: self.playAgainButton.center.y)

})
                    
                    gameActive = false
            }
            }
            
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
    }

}


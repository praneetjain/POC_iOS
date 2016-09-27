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
    
    @IBAction func playAgainTapped(sender: AnyObject) {
        
         activePlayer = 1
        
         gameActive = true
        
         gameState = [0,0,0,0,0,0,0,0,0]

        
        
        var button : UIButton
        
        for var i=1; i<10; i++ {
            
        button = view.viewWithTag(i) as! UIButton
        
        button.setImage(nil, forState: .Normal)
        }
        
        gameOverLabel.hidden = true
        
        playAgainButton.hidden = true
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        gameOverLabel.center = CGPointMake(gameOverLabel.center.x - 400, gameOverLabel.center.y)
        playAgainButton.center = CGPointMake(playAgainButton.center.x - 400, playAgainButton.center.y)

        gameOverLabel.hidden=true
        playAgainButton.hidden=true
    
    }

    @IBAction func buttonTapped(sender: AnyObject) {
        
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
        
        sender.setImage(image, forState: .Normal)
            
            for combination in winningCombinations {
            
                if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]] {
            
                    var labelText = "Noughts has won"
                    
                    if gameState[combination[0]] == 2{

                        labelText = "Crosses has won"
                    }
                    
                    gameOverLabel.text = labelText
                    
                    gameOverLabel.hidden = false
                    playAgainButton.hidden = false
                    
UIView.animateWithDuration(0.5, animations: { () -> Void in
    
    self.gameOverLabel.center = CGPointMake(self.gameOverLabel.center.x + 400, self.gameOverLabel.center.y)
    self.playAgainButton.center = CGPointMake(self.playAgainButton.center.x + 400, self.playAgainButton.center.y)

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


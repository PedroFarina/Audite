//
//  DocumentViewController.swift
//  Audite
//
//  Created by Pedro Giuliano Farina on 16/03/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import AudioKit

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var documentNameLabel: UILabel!

    var document: UIDocument?

    var player: AKAudioPlayer!
    var booster: AKBooster!
    @IBAction func changedValue(_ sender: UISlider) {
        booster.gain = Double(sender.value)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access the document
        document?.open(completionHandler: { (success) in
            if success {
                do {
                    let file = try AKAudioFile(forReading: self.document!.fileURL)

                    self.player = try AKAudioPlayer(file: file)
                    // Define your gain below. >1 means amplifying it to be louder
                    self.booster = AKBooster(self.player, gain: 1)
                    AudioKit.output = self.booster

                    // And then to play your file:
                    try AudioKit.start()
                    self.player.play()
                } catch {
                    fatalError(error.localizedDescription)
                }
                // Display the content of the document, e.g.:
                self.documentNameLabel.text = self.document?.fileURL.lastPathComponent
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }
    
    @IBAction func dismissDocumentViewController() {
        player.stop()
        try? AudioKit.stop()
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}

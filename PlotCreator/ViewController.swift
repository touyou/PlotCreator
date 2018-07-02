//
//  ViewController.swift
//  PlotCreator
//
//  Created by 藤井陽介 on 2018/06/18.
//  Copyright © 2018 touyou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvasView: CanvasView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func tapUndoButton() {
        canvasView.undo()
    }

    @IBAction func tapRedoButton() {
        canvasView.redo()
    }

    @IBAction func changeDensitySlider(_ sender: UISlider) {
        ForcePath.density = CGFloat(sender.value)
    }

    @IBAction func changePointSizeSlider(_ sender: UISlider) {
        CanvasView.pointSize = CGFloat(sender.value)
        canvasView.setNeedsDisplay()
    }

    @IBAction func tapSaveButton() {
        let snapshot = canvasView.takeSnapShot()
        UIImageWriteToSavedPhotosAlbum(snapshot, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {

        if error == nil {

            let alertController = UIAlertController(title: "保存完了", message: "保存完了しました", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in

                guard let `self` = self else { return }
                self.canvasView.reset()
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
}

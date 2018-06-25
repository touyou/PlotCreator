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
}

// NanoFocuserController.swift (Save in the "controller" folder)

import UIKit

class NanoFocuserController: UIViewController, NanoFocuserModelDelegate {
    var model: NanoFocuserModel
    var view: NanoFocuserView

    override func viewDidLoad() {
        super.viewDidLoad()

        model = NanoFocuserModel()
        model.delegate = self
        view = NanoFocuserView(frame: self.view.bounds)
        view.updateFocusPoint(CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2))
        model.getDistanceFromFocusPoint(CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2))

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)

        view.controller = self

        self.view.addSubview(view)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        view.updateFocusPoint(tapLocation)
        model.getDistanceFromFocusPoint(tapLocation)
    }

    func distanceDidChange(newDistance: Double) {
        view.updateDistanceDisplay(distance: newDistance)
    }
}

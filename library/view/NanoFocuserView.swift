// NanoFocuserView.swift (Save in the "view" folder)

import UIKit

class NanoFocuserView: UIView {
    var cameraFeedView: UIView
    var facesView: [UIView]
    var distanceDisplayView: UIView
    var trackingStatusView: UIView
    var isTracking: Bool = false
    var controller: NanoFocuserController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        trackingStatusView = UIView(frame: CGRect(x: frame.width - 50, y: 0, width: 50, height: 50))
        trackingStatusView.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.9)
        addSubview(trackingStatusView)

        distanceDisplayView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        distanceDisplayView.backgroundColor = UIColor.lightGray
        addSubview(distanceDisplayView)
    }

    func updateTrackingStatus(isTracking: Bool) {
        self.isTracking = isTracking
        if isTracking {
            trackingStatusView.isHidden = false
            let label = UILabel(frame: CGRect(x: 5, y: 5, width: trackingStatusView.frame.width - 10, height: trackingStatusView.frame.height - 10))
            label.text = "Tracking"
            label.textColor = .white
            label.textAlignment = .center
            trackingStatusView.addSubview(label)
        } else {
            trackingStatusView.isHidden = true
            for subview in trackingStatusView.subviews {
                subview.removeFromSuperview()
            }
        }
    }

    func updateDistanceDisplay(distance: Double) {
        let distanceString = String(format: "%.2f", distance) + "m"
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: distanceDisplayView.frame.width - 10, height: distanceDisplayView.frame.height - 10))
        label.text = distanceString
        label.textColor = .black
        label.textAlignment = .center
        distanceDisplayView.addSubview(label)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let tapLocation = touch.location(in: self)
            if let controller = controller {
                controller.handleTapLocation(tapLocation)
            }
        }
    }
}

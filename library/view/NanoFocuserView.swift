import UIKit

class NanoFocuserView: UIView {
    private var tapObservers: [(CGPoint) -> Void] = []
    private let distanceView: UIView
    private let trackingView: UIView
    private let videoFrameLayer: CALayer
    private let focusPointView: UIView
    private var objectViews: [CGRect: (id: String, selected: Bool)] = [:]
    
    override init(frame: CGRect) {
        distanceView = UIView(frame: CGRect(x: 10, y: 10, width: 100, height: 40))
        distanceView.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        let distanceLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 90, height: 30))
        distanceLabel.textColor = UIColor.white
        distanceLabel.textAlignment = .center
        distanceView.addSubview(distanceLabel)
        
        trackingView = UIView(frame: CGRect(x: frame.width - 110, y: 10, width: 100, height: 40))
        trackingView.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        let trackingLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 80, height: 20))
        trackingLabel.text = "Tracking"
        trackingLabel.textColor = UIColor.white
        trackingView.addSubview(trackingLabel)
        trackingView.isHidden = true
        
        videoFrameLayer = CALayer()
        
        focusPointView = UIView(frame: CGRect(x: frame.width / 2 - 5, y: frame.height / 2 - 5, width: 10, height: 10))
        focusPointView.backgroundColor = UIColor.white
        
        super.init(frame: frame)
        
        layer.addSublayer(videoFrameLayer)
        addSubview(distanceView)
        addSubview(trackingView)
        addSubview(focusPointView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(processTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        distanceView = UIView()
        trackingView = UIView()
        videoFrameLayer = CALayer()
        focusPointView = UIView()
        super.init(coder: coder)
    }
    
    func displayVideoFrame(_ image: UIImage) {
        videoFrameLayer.contents = image.cgImage
    }
    
    func highlightObjects(_ objects: [(rectangle: CGRect, id: String, selected: Bool)]) {
        for (_, view) in objectViews {
            view.removeFromSuperview()
        }
        objectViews.removeAll()
        
        for object in objects {
            let border: UIColor = object.selected ? .yellow : .white
            let borderWidth: CGFloat = object.selected ? 2.0 : 1.0

            let borderView = UIView(frame: object.rectangle)
            borderView.layer.borderColor = border.cgColor
            borderView.layer.borderWidth = borderWidth
            borderView.backgroundColor = UIColor.clear
            addSubview(borderView)
            
            if object.selected { // If selected, update focus point
                updateFocusPoint(CGPoint(x: object.rectangle.midX, y: object.rectangle.midY))
            }
            
            objectViews[object.rectangle] = (id: object.id, selected: object.selected)
        }
    }
    
    func displayDistance(_ distance: Double) {
        if let distanceLabel = distanceView.subviews.first as? UILabel {
            distanceLabel.text = String(format: "%.1f m", distance)
        }
    }
    
    func displayTracking() {
        trackingView.isHidden = false
    }
    
    func hideTracking() {
        trackingView.isHidden = true
    }
    
    @objc func processTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self)
        notify(tapLocation)
    }
    
    func notify(_ tapLocation: CGPoint) {
        for observer in tapObservers {
            observer(tapLocation)
        }
    }
    
    func onTap(observer: @escaping (CGPoint) -> Void) {
        tapObservers.append(observer)
    }
    
    func updateFocusPoint(_ coordinate: CGPoint) {
        focusPointView.frame.origin = CGPoint(x: coordinate.x - 5, y: coordinate.y - 5)
    }
}

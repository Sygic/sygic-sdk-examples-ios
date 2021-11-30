import UIKit
import SygicMaps

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if SYContext.isInitialized() {
            setupMapView()
        } else {
            let center = NotificationCenter.default
            var token: NSObjectProtocol?
            token = center.addObserver(forName: .DidInitSygicMaps, object: nil, queue: nil) { [weak self] (_) in

                center.removeObserver(token!)
                self?.setupMapView()
            }
        }
    }

    func setupMapView() {
        let mapView = SYMapView(frame: view.bounds)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: mapView.trailingAnchor)
        ])
    }
}

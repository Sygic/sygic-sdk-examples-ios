import UIKit
import SygicMaps

struct Constants {
    static let initialZoom = CGFloat(15)
    static let initialLookAt = SYGeoCoordinate(latitude: 51.500432, longitude: -0.126051)
    static let routeStart = initialLookAt
    static let routeEnd = SYGeoCoordinate(latitude: 51.505431, longitude: -0.103124)
    static let routeWaypoint = SYGeoCoordinate(latitude: 51.504387, longitude: -0.115477)
}

class ViewController: UIViewController {
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var mapView: SYMapView!
    var markersMapObjects = [SYMapObject]()
    var routeMapObjects = [SYMapObject]()

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

    @IBAction func onTapRouteCompute(_ sender: Any) {
        guard mapView != nil else {
            print("mapView not initialized")
            return
        }
        guard routeMapObjects.isEmpty else {
            print("Route already exists")
            return
        }
        createRoute()
    }

    @IBAction func onTapRouteRemove(_ sender: Any) {
        guard mapView != nil else {
            print("mapView not initialized")
            return
        }
        removeAllRoutesFromMap()
        animateToInitialLook()
    }
}

private extension ViewController {
    func setupMapView() {
        mapView = SYMapView(frame: mapContainer.bounds)
        mapView.camera.zoom = Constants.initialZoom
        mapView.camera.tilt = 0
        mapView.camera.geoCenter = Constants.initialLookAt

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapContainer.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: mapContainer.topAnchor),
            mapContainer.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: mapContainer.leadingAnchor),
            mapContainer.trailingAnchor.constraint(equalTo: mapView.trailingAnchor)
        ])

        addMapMarkers()
    }

    func animateToInitialLook() {
        mapView.camera.animate({
            self.mapView.camera.zoom = Constants.initialZoom
            self.mapView.camera.geoCenter = Constants.initialLookAt
        }, withDuration: 0.5, curve: .accelerateDecelerate, completion: nil)
    }

    func createRoute() {
        removeAllRoutesFromMap()
        activityIndicator.startAnimating()

        let start = SYWaypoint(
            position: Constants.routeStart,
            type: .start,
            name: nil
        )
        let end = SYWaypoint(
            position: Constants.routeEnd,
            type: .end,
            name: nil
        )
        let via = SYWaypoint(
            position: Constants.routeWaypoint,
            type: .via,
            name: nil
        )

        // Optional: create SYRoutingOptions to configure route compute process.
        let routingOptions = SYRoutingOptions()
        routingOptions.transportMode = .car
        routingOptions.routingType = .fastest

        // SYRouteRequest - set start, destination, waypoints, options.
        let request = SYRouteRequest(start: start, destination: end, options: routingOptions, viaPoints: [via])

        // SYPrimaryRequest - track progress and completion for primary route compute.
        let primary = SYPrimaryRequest(request) { (progress) in
            print("Primary progress: \(Int(progress * 100))%")

        } completion: { [weak self] (route, computeResult) in
            print("Primary compute done: \(route?.info.length ?? 0) meters")

            guard let route = route else { return }
            self?.addRouteToMap(route, type: .primary)
        }

        // Compute the route (optionally with alternatives),
        // completion is called when all computing routes for all requests are finished.
        SYRouting.computeRoute(primary, alternatives: nil) { [weak self] (primaryRoute, alternatives) in
            print("Compute fully finished")

            guard let self = self else { return }
            self.activityIndicator.stopAnimating()

            guard let primaryRoute = primaryRoute else {
                print("Error: no primary route")
                return
            }
            var allRoutes = [primaryRoute]

            if let alternatives = alternatives {
                let alterRoutes = alternatives.compactMap { $0.route }
                allRoutes.append(contentsOf: alterRoutes)
            }
            self.showBoundingBox(routes: allRoutes)
        }
    }

    func removeAllMapMarkers() {
        mapView.remove(markersMapObjects)
        markersMapObjects.removeAll()
    }

    func addMapMarkers() {
        let points = [Constants.routeStart, Constants.routeWaypoint, Constants.routeEnd]
        markersMapObjects = points.map { coordinate in
            let image = UIImage(named: "MapPin")!
            let marker = SYMapMarker(coordinate: coordinate, image: image)
            marker.anchorPosition = CGPoint(x: 0.5, y: 1)
            return marker
        }
        mapView.add(markersMapObjects)
    }

    func removeAllRoutesFromMap() {
        mapView.remove(routeMapObjects)
        routeMapObjects.removeAll()
    }

    func addRouteToMap(_ route: SYRoute, type: SYMapRouteType) {
        let text = "My route\n\(route.info.length) meters"

        let newMapObjects = [
            SYMapRoute(route: route, type: type),
            SYMapRouteLabel(text: text, textStyle: nil, placeOn: route)
        ]
        routeMapObjects.append(contentsOf: newMapObjects)
        mapView.add(newMapObjects)
    }

    func showBoundingBox(routes: [SYRoute]) {
        guard let firstRoute = routes.first else { return }

        let unionBox = routes.reduce(firstRoute.box) { partialResult, route in
            partialResult.union(with: route.box) ?? partialResult
        }

        // Zoom out with animation to display full route.
        mapView.camera.setViewBoundingBox(
            unionBox,
            with: UIEdgeInsets.init(top: 0.15, left: 0.15, bottom: 0.15, right: 0.15),
            duration: 1.0,
            curve: .accelerateDecelerate,
            completion: nil
        )
    }
}

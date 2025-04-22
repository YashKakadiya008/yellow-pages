import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yellowpages/utils/services/helpers.dart';

class GoogleMapScreen extends StatefulWidget {
  final LatLng latLng;
  const GoogleMapScreen({super.key, required this.latLng});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;

  bool loading = false;

  // Future loaddata() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   await mapcontroll.determinePosition();
  //   _initialPosition = LatLng(
  //     mapcontroll.position!.latitude,
  //     mapcontroll.position!.longitude,
  //   );
  //   setState(() {
  //     loading = false;
  //   });
  // }

  @override
  void initState() {
    // loaddata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Helpers.appLoader()
          : Stack(
              children: [
                GoogleMap(
                  mapType: Get.isDarkMode ? MapType.hybrid : MapType.terrain,
                  initialCameraPosition: CameraPosition(
                    target: widget.latLng,
                    zoom: 16,
                  ),
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                  myLocationButtonEnabled: false,
                  markers: {
                    Marker(
                        markerId: const MarkerId("4"), position: widget.latLng)
                  },
                  onMapCreated: (GoogleMapController mapController) {
                    mapController = mapController;
                    // if (!widget.fromAddAddress) {
                    //   // Get.find<LocationController>()
                    //   //     .getCurrentLocation(false, mapController: mapController);
                    // }
                  },
                  // scrollGesturesEnabled: !Get.isDialogOpen,
                  zoomControlsEnabled: true,
                  onCameraMove: (CameraPosition cameraPosition) {
                    cameraPosition = cameraPosition;
                  },
                  onCameraMoveStarted: () {
                    // locationController.disableButton();
                  },
                  onCameraIdle: () {
                    // Get.find<LocationController>()
                    //     .updatePosition(_cameraPosition, false);
                  },
                ),
              ],
            ),
    );
  }
}

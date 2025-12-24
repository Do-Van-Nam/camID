import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindStoresPage extends StatefulWidget {
  const FindStoresPage({super.key});

  @override
  State<FindStoresPage> createState() => _FindStoresState();
}

class _FindStoresState extends State<FindStoresPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(13.6238, 103.1818);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header AppBar tự custom
          Container(
            width: double.infinity,
            color: AppColors.colorMain,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: kToolbarHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.stores,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 14.0,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                Positioned(
                  top: 16,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.newLatLng(_center),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.black,
                      elevation: 4,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.title_search_find_stores,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const Icon(Icons.search, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  right: 10,
                  width: 40,
                  height: 40,
                  child: FloatingActionButton(
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.newLatLng(_center),
                      );
                    },
                    backgroundColor: Colors.blue[800],
                    child: const Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

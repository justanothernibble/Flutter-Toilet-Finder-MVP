import 'package:flutter/material.dart';
import 'package:flutter_toilet_finder_mvp/pages/list_toilets_temp.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../core/services/supabase_service.dart';
import '../core/repositories/toilet_repository.dart';
import '../core/models/toilet.dart';
import 'sign_in_screen.dart';
import 'list_toilets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(51.5074, -0.1278); // London default
  bool _loading = true;
  String? _error;
  List<Toilet> _toilets = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Ensure permissions
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      Position? pos;
      if (perm != LocationPermission.denied &&
          perm != LocationPermission.deniedForever) {
        pos = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
        );
      }

      if (pos != null) {
        _center = LatLng(pos.latitude, pos.longitude);
      }

      final repo = SupabaseToiletRepository(SupabaseService());
      final fetched = await repo.fetchNearby(
        lat: _center.latitude,
        lng: _center.longitude,
        radiusM: 1500,
        limit: 100,
      );
      if (!mounted) return;
      setState(() {
        _toilets = fetched;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  Set<Marker> _buildMarkers() {
    return _toilets.map((t) {
      final lat = t.lat ?? _center.latitude;
      final lng = t.lng ?? _center.longitude;
      return Marker(
        markerId: MarkerId(t.id),
        position: LatLng(lat, lng),
        onTap: () => _showToiletDetails(t),
      );
    }).toSet();
  }

  void _showToiletDetails(Toilet t) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.name ?? 'Toilet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (t.address != null) ...[
              const SizedBox(height: 8),
              Text(t.address!),
            ],
            if ((t.description ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(t.description!),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: const Text(
                'Toilet Finder London',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('List View'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListToilets()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('List View (Temporary)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListToiletsTemp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () {
                SupabaseService().signOut();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Toilet Finder London'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _load,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _error != null
          ? Center(child: Text('Error: $_error'))
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 14,
                  ),
                  markers: _buildMarkers(),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                ),
                if (_loading)
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: LinearProgressIndicator(),
                    ),
                  ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _loading
            ? null
            : () async {
                await _load();
                await _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(_center, 14),
                );
              },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

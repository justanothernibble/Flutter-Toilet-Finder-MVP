import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'home_screen.dart';
import 'list_toilets.dart';
import 'sign_in_screen.dart';
import '../core/services/supabase_service.dart';

class ListToiletsTemp extends StatefulWidget {
  const ListToiletsTemp({Key? key}) : super(key: key);

  @override
  State<ListToiletsTemp> createState() => _ListToiletsTempState();
}

class _ListToiletsTempState extends State<ListToiletsTemp> {
  final toiletTempStream = Supabase.instance.client
      .from('toilets')
      .stream(primaryKey: ['id']);

  Position? _currentPosition;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      //final position = await Geolocator.getCurrentPosition(
      //  locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      //);

      final position = Position(
        // temporary location for testing
        latitude: 51.4994,
        longitude: -0.1247,
        accuracy: 10.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        timestamp: DateTime.now(),
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }

  double _calculateDistance(Map<String, dynamic> toiletData) {
    if (_currentPosition == null) return 0.0;

    final toiletLat = toiletData['lat'] as double?;
    final toiletLng = toiletData['lng'] as double?;

    if (toiletLat == null || toiletLng == null) return 0.0;

    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      toiletLat,
      toiletLng,
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
              leading: const Icon(Icons.map),
              title: const Text('Map View'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
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
        title: Text('List Toilets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
            tooltip: 'Refresh Location',
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: toiletTempStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading stream...'));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          return Column(
            children: List<Widget>.generate(snapshot.data!.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom: 12,
                  ),
                  title: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              snapshot.data![index]['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            _currentPosition != null
                                ? _formatDistance(
                                    _calculateDistance(snapshot.data![index]),
                                  )
                                : _isLoadingLocation
                                ? 'Loading...'
                                : 'Location unavailable',
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              snapshot.data![index]['address'] ??
                                  'Address not available',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          for (var i = 0; i < 5; i++)
                            i < 3
                                ? const Icon(Icons.star, color: Colors.yellow)
                                : const Icon(
                                    Icons.star_border,
                                    color: Colors.yellow,
                                  ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

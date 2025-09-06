// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_toilet_finder_mvp/pages/list_toilets_temp.dart';
import 'package:geolocator/geolocator.dart';

import '../core/services/supabase_service.dart';
import '../core/repositories/toilet_repository.dart';
import '../core/models/toilet.dart';
import 'sign_in_screen.dart';
import 'home_screen.dart';

// State for toilet list
class ToiletListState {
  final bool isLoading;
  final List<Toilet> toilets;
  final String? error;
  final Position? currentLocation;

  ToiletListState({
    this.isLoading = false,
    this.toilets = const [],
    this.error,
    this.currentLocation,
  });

  ToiletListState copyWith({
    bool? isLoading,
    List<Toilet>? toilets,
    String? error,
    Position? currentLocation,
  }) {
    return ToiletListState(
      isLoading: isLoading ?? this.isLoading,
      toilets: toilets ?? this.toilets,
      error: error ?? this.error,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }
}

// Notifier for managing toilet list state
class ToiletListNotifier extends StateNotifier<ToiletListState> {
  ToiletListNotifier() : super(ToiletListState());

  Future<void> loadToilets() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get current location
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

      if (pos == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Unable to get current location',
        );
        return;
      }

      state = state.copyWith(currentLocation: pos);

      // Fetch nearby toilets
      final repo = SupabaseToiletRepository(SupabaseService());
      final fetched = await repo.fetchAll();

      // Sort by distance
      fetched.sort((a, b) {
        final distA = Geolocator.distanceBetween(
          pos!.latitude,
          pos.longitude,
          a.latitude ?? pos.latitude,
          a.longitude ?? pos.longitude,
        );
        final distB = Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          b.latitude ?? pos.latitude,
          b.longitude ?? pos.longitude,
        );
        return distA.compareTo(distB);
      });

      state = state.copyWith(isLoading: false, toilets: fetched);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Provider
final toiletListProvider =
    StateNotifierProvider<ToiletListNotifier, ToiletListState>(
      (ref) => ToiletListNotifier(),
    );

// Helper to format distance
String formatDistance(double meters) {
  if (meters < 1000) {
    return '${meters.round()} m';
  } else {
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}

class ListToilets extends ConsumerStatefulWidget {
  const ListToilets({super.key});

  @override
  ConsumerState<ListToilets> createState() => _ListToiletsState();
}

class _ListToiletsState extends ConsumerState<ListToilets> {
  @override
  void initState() {
    super.initState();
    // Load toilets on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(toiletListProvider.notifier).loadToilets();
    });
  }

  Position? examplePos;

  @override
  Widget build(BuildContext context) {
    final toiletState = ref.watch(toiletListProvider);
    examplePos = Position(
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
        title: const Text('Toilets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: toiletState.isLoading
                ? null
                : () => ref.read(toiletListProvider.notifier).loadToilets(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: toiletState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : toiletState.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${toiletState.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(toiletListProvider.notifier).loadToilets(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : toiletState.toilets.isEmpty
          ? const Center(child: Text('No toilets found nearby'))
          : ListView.builder(
              itemCount: toiletState.toilets.length,
              itemBuilder: (context, index) {
                final toilet = toiletState.toilets[index];
                /*                final distance = toiletState.currentLocation != null
                    ? Geolocator.distanceBetween(
                        toiletState.currentLocation!.latitude,
                        toiletState.currentLocation!.longitude,
                        toilet.latitude ??
                            toiletState.currentLocation!.latitude,
                        toilet.longitude ??
                            toiletState.currentLocation!.longitude,
                      )
                    : 0.0;*/
                final distance = toiletState.currentLocation != null
                    ? Geolocator.distanceBetween(
                        examplePos!.latitude,
                        examplePos!.longitude,
                        toilet.latitude ?? examplePos!.latitude,
                        toilet.longitude ?? examplePos!.longitude,
                      )
                    : 0.0;

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
                                toilet.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(formatDistance(distance)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                toilet.address ?? 'Address not available',
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
              },
            ),
    );
  }
}

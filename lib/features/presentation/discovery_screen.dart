import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../data/music_service.dart';

class DiscoveryScreen extends StatelessWidget {
  final String lang;
  const DiscoveryScreen({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RetroColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        iconTheme: const IconThemeData(color: RetroColors.secondary),
        title: Text(lang.toUpperCase(), style: const TextStyle(color: RetroColors.secondary, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<MusicArtist>>(
        future: MusicService.discover(lang),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: RetroColors.primary));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("NO DATA FOUND"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(30),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              final artist = snapshot.data![i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(artist.name.toUpperCase(), 
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: RetroColors.secondary)),
                    Text("ALBUM: ${artist.topAlbum}", style: const TextStyle(color: RetroColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text("SONG: ${artist.topSong}", style: const TextStyle(color: RetroColors.secondary, fontSize: 13)),
                    const SizedBox(height: 10),
                    const Divider(color: RetroColors.secondary, thickness: 2),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
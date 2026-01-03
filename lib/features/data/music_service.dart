import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart'; // ✅ Add this

class MusicArtist {
  final String name;
  final String topAlbum;
  final String topSong;

  MusicArtist({required this.name, required this.topAlbum, required this.topSong});
}

class MusicService {
  // Define a logger specific to this class
  static final _log = Logger('MusicService'); 
  
  static final String _apiKey = dotenv.env['LASTFM_API_KEY'] ?? '';
  static const String _baseUrl = 'https://ws.audioscrobbler.com/2.0/';

  static Future<List<MusicArtist>> discover(String language) async {
    List<MusicArtist> results = [];
    _log.info('Starting discovery for language: $language'); // ✅ Professional Log

    final artistUrl = Uri.parse(
      '$_baseUrl?method=tag.gettopartists&tag=$language&api_key=$_apiKey&format=json&limit=10'
    );

    try {
      final response = await http.get(artistUrl);
      if (response.statusCode != 200) {
        _log.severe('Failed to fetch artists: Status ${response.statusCode}');
        return [];
      }

      final data = json.decode(response.body);
      final List artists = data['topartists']['artist'];

      for (var a in artists) {
        String name = a['name'];
        _log.fine('Fetching details for artist: $name'); // ✅ Fine-grained log

        final trackUrl = Uri.parse('$_baseUrl?method=artist.gettoptracks&artist=${Uri.encodeComponent(name)}&api_key=$_apiKey&format=json&limit=1');
        final albumUrl = Uri.parse('$_baseUrl?method=artist.gettopalbums&artist=${Uri.encodeComponent(name)}&api_key=$_apiKey&format=json&limit=1');

        final responses = await Future.wait([http.get(trackUrl), http.get(albumUrl)]);

        String song = "Unknown Track";
        String album = "Unknown Album";

        if (responses[0].statusCode == 200) {
          var trackData = json.decode(responses[0].body);
          if (trackData['toptracks']['track'].isNotEmpty) {
            song = trackData['toptracks']['track'][0]['name'];
          }
        } else {
          _log.warning('Could not fetch top track for $name');
        }

        if (responses[1].statusCode == 200) {
          var albumData = json.decode(responses[1].body);
          if (albumData['topalbums']['album'].isNotEmpty) {
            album = albumData['topalbums']['album'][0]['name'];
          }
        }

        results.add(MusicArtist(name: name, topAlbum: album, topSong: song));
      }
    } catch (e, stacktrace) {
      // ✅ Log the error AND the stacktrace for easier debugging
      _log.shout('Critical failure in discovery service', e, stacktrace);
    }
    
    _log.info('Discovery completed. Found ${results.length} artists.');
    return results;
  }
}
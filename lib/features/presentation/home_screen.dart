import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ New Import
import '../../core/constants.dart';
import 'discovery_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final _log = Logger('HomeScreen');

  String _lang = 'English';
  final List<String> _languages = [
    'English',
    'Japanese',
    'French',
    'Spanish',
    'Hindi',
    'Korean'
  ];

  // ✅ Logic: Centralized link handler with error logging
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      _log.severe('Could not launch $url');
    } else {
      _log.info('User navigated to $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RetroColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const Spacer(flex: 3), // Pushes content down

            // Branding Header
            GestureDetector(
              onLongPress: () async {
                final directory = await getApplicationDocumentsDirectory();
                final path = '${directory.path}/poptart_logs.txt';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: RetroColors.secondary,
                      content: Text("LOGS: $path")),
                );
              },
              child: const Text("POPTART",
                  style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.w900,
                      color: RetroColors.secondary,
                      letterSpacing: -4)),
            ),
            const Text("RETRO DISCOVERY",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: RetroColors.primary,
                    letterSpacing: 2)),

            const SizedBox(height: 60),

            // Language Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                border: Border.all(color: RetroColors.secondary, width: 3),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _lang,
                  isExpanded: true,
                  dropdownColor: RetroColors.background,
                  style: const TextStyle(
                      color: RetroColors.secondary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                      fontSize: 18),
                  items: _languages
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                  onChanged: (v) => setState(() => _lang = v!),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Discover Button
            InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DiscoveryScreen(lang: _lang))),
              child: Container(
                height: 65,
                width: double.infinity,
                color: RetroColors.secondary,
                child: const Center(
                  child: Text("DISCOVER",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 4)),
                ),
              ),
            ),

            const Spacer(flex: 2),

            // ✅ RAWATJI CREDITS SECTION
            const Divider(color: RetroColors.secondary, thickness: 2),
            const SizedBox(height: 10),
            const Text("BUILT BY RAWATJI",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: RetroColors.secondary)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialLink("GITHUB", "https://github.com/ajy-ocean"),
                const Text(" / ", style: TextStyle(color: RetroColors.primary)),
                _socialLink("TWITTER", "https://x.com/ajy_ocean"),
                const Text(" / ", style: TextStyle(color: RetroColors.primary)),
                _socialLink("LINKEDIN",
                    "https://www.linkedin.com/in/ajay-laxmi-bisht-virendra-rawat/"),
              ],
            ),
            const SizedBox(height: 30), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _socialLink(String label, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Text(label,
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: RetroColors.primary,
              decoration: TextDecoration.underline)),
    );
  }
}

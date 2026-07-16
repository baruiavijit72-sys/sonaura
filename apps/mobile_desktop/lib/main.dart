import 'package:flutter/material.dart';

void main() {
  runApp(const SonauraApp());
}

class SonauraApp extends StatefulWidget {
  const SonauraApp({super.key});

  @override
  State<SonauraApp> createState() => _SonauraAppState();
}

class _SonauraAppState extends State<SonauraApp> {
  final ThemeMode _themeMode = ThemeMode.dark; // ডিফল্ট ডার্ক মোড

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonaura',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      // লাইট থিম ডেফিনিশন (যা মিসিং ছিল)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1DB954),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      // ডার্ক থিম ডেফিনিশন (যা মিসিং ছিল)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1DB954),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF090A0F),
      ),
      home: const SonauraHomeScreen(),
    );
  }
}

class SonauraHomeScreen extends StatefulWidget {
  const SonauraHomeScreen({super.key});

  @override
  State<SonauraHomeScreen> createState() => _SonauraHomeScreenState();
}

class _SonauraHomeScreenState extends State<SonauraHomeScreen> {
  bool _isPlaying = false;
  double _currentSliderValue = 12.0;

  // ডামি গানের লিস্ট (যাতে সার্ভার ছাড়াও সরাসরি গান চলে)
  final List<Map<String, String>> _dummySongs = [
    {
      'title': 'Sonaura Theme Song',
      'artist': 'Sonaura AI Gen',
      'duration': '3:45'
    },
    {
      'title': 'Acoustic Midnight',
      'artist': 'Independent Artist',
      'duration': '4:12'
    },
    {
      'title': 'Cyberpunk Beats',
      'artist': 'Retro Wave',
      'duration': '2:58'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // কাস্টম হেডার
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sonaura',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1DB954),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle, size: 30),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // স্বাগতম ব্যানার
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Music for everyone. Free, forever. 🔥',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // গানের লিস্ট ভিউ
            Expanded(
              child: ListView.builder(
                itemCount: _dummySongs.length,
                itemBuilder: (context, index) {
                  final song = _dummySongs[index];
                  return ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.music_note, color: Color(0xFF1DB954)),
                    ),
                    title: Text(song['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(song['artist']!),
                    trailing: Text(song['duration']!),
                    onTap: () {
                      setState(() {
                        _isPlaying = true;
                      });
                    },
                  );
                },
              ),
            ),

            // বটম মিউজিক প্লেয়ার কন্ট্রোল বার
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? const Color(0xFF121318) 
                    : const Color(0xFFEEEEEE),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1DB954),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.play_arrow, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Now Playing...', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Select a song to start listening', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                        iconSize: 40,
                        color: const Color(0xFF1DB954),
                        onPressed: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                          });
                        },
                      ),
                    ],
                  ),
                  Slider(
                    value: _currentSliderValue,
                    max: 100,
                    activeColor: const Color(0xFF1DB954),
                    inactiveColor: Colors.grey[600],
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

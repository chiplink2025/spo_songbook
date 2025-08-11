import 'package:flutter/material.dart';
import 'song.dart';

class SongPage extends StatelessWidget {
  final Song song;

  const SongPage({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a list of widgets instead of just lines
    final List<Widget> lyricWidgets = [];

    for (var section in song.lyrics) {
      final String sectionTitle = section[0];
      final List<String> sectionLines = section[1].trim().split('\n');

      lyricWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sectionTitle,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            ...sectionLines.map((line) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    line,
                    style: const TextStyle(fontSize: 18),
                  ),
                )),
            const SizedBox(height: 16), // space between sections
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(song.title, style: const TextStyle(fontSize: 20)),
            Text(
              song.author,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: lyricWidgets,
        ),
      ),
    );
  }
}

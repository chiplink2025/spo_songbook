import 'package:flutter/material.dart';
import 'song.dart';

class SongPage extends StatelessWidget {
  final Song song;

  const SongPage({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> lines = song.lyrics.trim().split('\n');

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
        child: ListView.builder(
          itemCount: lines.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(lines[index], style: const TextStyle(fontSize: 18)),
            );
          },
        ),
      ),
    );
  }
}

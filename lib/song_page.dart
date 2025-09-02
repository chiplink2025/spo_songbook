import 'package:flutter/material.dart';
import 'song.dart';

class SongPage extends StatefulWidget {
  final Song song;

  const SongPage({Key? key, required this.song}) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  double _textSize = 18.0; // Default text size for lyrics
  bool showChords = false;

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Text Size',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('12', style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: Slider(
                      value: _textSize,
                      min: 12.0,
                      max: 32.0,
                      divisions: 20,
                      label: _textSize.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _textSize = value;
                        });
                      },
                      onChangeStart: (value) {
                        // Optional: Add haptic feedback when starting to drag
                      },
                      onChangeEnd: (value) {
                        // Optional: Add haptic feedback when finishing drag
                      },
                    ),
                  ),
                  const Text('32', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  '${_textSize.round()}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget buildLyricLine(String line, bool showChords, double textSize) {
    // Split the line into parts: chord vs lyric
    final RegExp chordExp = RegExp(r'%([^%]+)%');
    final matches = chordExp.allMatches(line);

    // Build the chord line
    String chordLine = line;
    for (final m in matches) {
      // Replace the chord block with spaces so chords align
      final start = m.start;
      final length = m.group(0)!.length;
      chordLine = chordLine.replaceRange(
        start,
        m.end,
        ' ' * (length - 2),
      ); // subtract 2 for %%
    }

    // Extract just the chords in order
    String chordsOnlyLine = '';
    int lastIndex = 0;
    for (final m in matches) {
      // Add spaces for alignment
      chordsOnlyLine += ' ' * (m.start - lastIndex);
      chordsOnlyLine += m.group(1)!; // the chord inside %
      lastIndex = m.end;
    }

    // Remove chord blocks from lyrics
    String lyricText = line.replaceAll(chordExp, '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12), // fixed space above every line
        if (!showChords)
          Text(
            chordsOnlyLine,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: textSize,
              height: 1.2,
            ),
          ),
        Text(lyricText, style: TextStyle(fontSize: textSize, height: 1.2)),
      ],
    );
  }

  String stripChords(String line) {
    // removes all %...%
    return line.replaceAll(RegExp(r'%.*?%'), '');
  }

  String buildChordLine(String line) {
    String lyric = '';
    String chordLine = '';
    bool inChord = false;
    String buffer = '';
    int lyricPos = 0; // track position of lyrics without chords

    for (int i = 0; i < line.length; i++) {
      if (line[i] == '%') {
        if (inChord) {
          // chord ended → align chord exactly above the current lyric position
          chordLine = chordLine.padRight(lyricPos);
          chordLine += buffer;
          buffer = '';
        }
        if (!inChord) {
          if (chordLine.isNotEmpty && chordLine[chordLine.length - 1] == ' ') {
            chordLine = chordLine.substring(0, chordLine.length - 1);
          }
        }
        inChord = !inChord;
      } else if (inChord) {
        buffer += line[i];

      } else {
        lyric += line[i];
        chordLine += ' ';
        lyricPos++; // only increment when real lyric characters are added
      }
    }

    return chordLine;
  }

  @override
  Widget build(BuildContext context) {
    // Build lyric sections
    final List<Widget> lyricWidgets = [];

    for (var section in widget.song.lyrics) {
      final String sectionTitle = section[0]; // e.g., "Verse 1", "Chorus"
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
            ...sectionLines.map((line) {
              final lyricLine = stripChords(line);
              final chordLine = buildChordLine(line);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showChords)
                    SizedBox(
                      height: 20, // fixed height for chord line
                      child: Text(
                        chordLine,
                        style: TextStyle(
                          fontSize: _textSize,
                          fontFamily: 'monospace',
                          color: Colors.blue, // optional for chords
                        ),
                      ),
                    ),
                  Text(
                    lyricLine,
                    style: TextStyle(
                      fontSize: _textSize,
                      fontFamily: showChords ? 'monospace' : null,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 20), // space between sections
          ],
        ),
      );
    }

    // Add copyright at the end
    lyricWidgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Text(
          widget.song.copyright,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.song.title, style: const TextStyle(fontSize: 20)),
            Text(
              widget.song.author,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        //Show Chords button
        actions: [
          Padding(padding: const EdgeInsets.only(right: 4.0)),
          IconButton(
            icon: Icon(!showChords ? Icons.music_off : Icons.music_note),
            onPressed: () {
              setState(() {
                showChords = !showChords;
              });
            },
          ),
          //Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsBottomSheet();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: lyricWidgets),
      ),
    );
  }
}

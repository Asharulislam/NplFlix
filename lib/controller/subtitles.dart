import 'package:better_player_plus/better_player_plus.dart';
import 'package:http/http.dart' as http;

Future<List<BetterPlayerSubtitlesSource>> fetchSubtitles(String url) async {
  List<BetterPlayerSubtitlesSource> subtitles = [];
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final content = response.body;
      print("Subtitle Content ${content}");
      // Extract subtitle tracks from EXT-X-MEDIA tags
      final subtitleRegex = RegExp(
          r'#EXT-X-MEDIA:TYPE=SUBTITLES.*NAME="([^"]+)".*LANGUAGE="([^"]+)".*URI="([^"]+)"');
      final matches = subtitleRegex.allMatches(content);

      for (var match in matches) {
        String name = match.group(1) ?? "Unknown";
        String language = match.group(2) ?? "Unknown";
        String uri = match.group(3) ?? "";

        subtitles.add(BetterPlayerSubtitlesSource(
          type: BetterPlayerSubtitlesSourceType.network,
          name: "$name ($language)",
        //  url: uri,
        ));
      }
    }
  } catch (e) {
    print("Error fetching subtitles: $e");
  }
  return subtitles;
}

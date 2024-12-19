import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mood_sync/app/core/utils/functions/open_spotify_url.dart';
import 'package:mood_sync/app/data/models/track.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final accessToken = GetStorage().read('accessToken');

  TrackTile({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: track.image,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: Colors.grey),
        errorWidget: (context, url, error) =>
            const Icon(Icons.error, color: Colors.red),
      ),
      title: Text(track.title),
      subtitle: Text(track.artist),
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow, color: Colors.green),
        onPressed: () =>
            openSpotifyUrl(track.toJson(), accessToken, saveHistory: false),
      ),
    );
  }
}

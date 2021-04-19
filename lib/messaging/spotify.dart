import 'package:flutter/material.dart';

class Playlist {
  final String? name;
  final String? description;
  final String? spotifyUrl;
  final String? imageUrl;
  final String? playlistArtist;

  Playlist({
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    @required this.playlistArtist,
    @required this.spotifyUrl,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      name: json['name'],
      description: json['description'],
      imageUrl: json['images'][0]['url'],
      spotifyUrl: json['external_urls']['spotify'],
      playlistArtist: json['owner']['display_name'],
    );
  }
}

class Album {
  // final String? name;

}

class Song {
  final String? name;
  final String? spotifyUrl;
  final String? imageUrl;
  final String? artistName;
  final String? type;
  final String? preview;
  final String? date;

  Song({
    @required this.name,
    @required this.spotifyUrl,
    @required this.imageUrl,
    @required this.artistName,
    @required this.type,
    @required this.preview,
    @required this.date,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
        name: json['name'],
        imageUrl: json['album']['images'][0]['url'],
        spotifyUrl: json['external_urls']['spotify'],
        artistName: json['artists'][0]['name'],
        type: json['type'],
        preview: json['preview_url'],
        date: json['album']['release_date']);
  }
}

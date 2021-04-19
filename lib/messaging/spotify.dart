import 'package:flutter/material.dart';

class Playlist {}

class Album {}

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

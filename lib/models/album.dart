import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  String title;
  String description;
  Artwork artwork;
  String teacher;
  String published;
  DateTime releaseDate;
  List tracks = List();
  DocumentReference reference;

  Album(this.title,
      {this.artwork,
      this.description,
      this.published,
      this.releaseDate,
      this.teacher,
      this.tracks});

  factory Album.fromSnapshot(DocumentSnapshot snapshot) {
    Album newAlbum = Album.fromJson(snapshot.data);
    newAlbum.reference = snapshot.reference;
    return newAlbum;
  }

  factory Album.fromJson(Map<String, dynamic> json) => _albumFromJson(json);

  @override
  String toString() => "Album<$title>";
}

class Artwork {
  String name;
  String size;
  String url;

  Artwork({this.name, this.size, this.url});

  factory Artwork.fromJson(Map<String, dynamic> parsedJson) {
    return Artwork(
      name: parsedJson['name'],
      size: parsedJson['size'],
      url: parsedJson['url'],
    );
  }
}

Album _albumFromJson(Map<String, dynamic> json) {
  return Album(
    json['title'] as String,
    description: json['description'] as String,
    artwork: Artwork.fromJson(json['artwork']),
    teacher: json['teacher'] as String,
    published: json['published'] as String,
    releaseDate: json['releaseDate'] == null
        ? null
        : (json['releaseDate'] as Timestamp).toDate(),
    tracks: json['tracks'] as List,
  );
}

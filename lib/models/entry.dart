import 'package:airnote/models/recording.dart';
import 'package:airnote/models/sentiment.dart';
import 'package:airnote/models/transcript.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry.g.dart';

@JsonSerializable()
class Entry {
  final int id;
  final String title;
  final String imageUrl;
  final String created;
  final String backgroundMusic;
  final bool isLocked;
  final int routineId;
  final int questId;
  final Recording recording;
  final Transcript transcript;
  final List<Sentiment> sentiments;

  Entry(
      {this.id,
      this.created,
      this.imageUrl,
      this.title,
      this.sentiments,
      this.isLocked,
      this.routineId,
      this.transcript,
      this.backgroundMusic,
      this.recording,
      this.questId});
  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
  Map<String, dynamic> toJson() => _$EntryToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'recording.g.dart';

@JsonSerializable()
class Recording {
  final int id;
  final String audioUrl;
  final String created;
  final int duration;
  final bool isEncrypted;
  final String backgroundMusic;

  Recording(
      {this.id,
      this.created,
      this.audioUrl,
      this.isEncrypted,
      this.backgroundMusic,
      this.duration,});
  factory Recording.fromJson(Map<String, dynamic> json) => _$RecordingFromJson(json);
  Map<String, dynamic> toJson() => _$RecordingToJson(this);
}

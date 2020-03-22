import 'package:json_annotation/json_annotation.dart';

part 'transcript.g.dart';

@JsonSerializable()
class Transcript {
  final int id;
  final String content;
  final String created;
  final bool isEncrypted;
  final bool isTranscribed;
  final bool isTranscriptionSubmitted;

  Transcript({
    this.id,
    this.content,
    this.created,
    this.isEncrypted,
    this.isTranscribed,
    this.isTranscriptionSubmitted,
  });
  factory Transcript.fromJson(Map<String, dynamic> json) =>
      _$TranscriptFromJson(json);
  Map<String, dynamic> toJson() => _$TranscriptToJson(this);
}

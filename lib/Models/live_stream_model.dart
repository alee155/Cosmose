// models/live_stream.dart

class LiveStreamResponse {
  final bool success;
  final List<LiveStream> liveStreams;

  LiveStreamResponse({required this.success, required this.liveStreams});

  factory LiveStreamResponse.fromJson(Map<String, dynamic> json) {
    return LiveStreamResponse(
      success: json['success'],
      liveStreams: List<LiveStream>.from(
        json['live_streams'].map((x) => LiveStream.fromJson(x)),
      ),
    );
  }
}

class LiveStream {
  final int id;
  final String title;
  final String streamUrl;
  final String status;
  final String startedAt;
  final User user;

  LiveStream({
    required this.id,
    required this.title,
    required this.streamUrl,
    required this.status,
    required this.startedAt,
    required this.user,
  });

  factory LiveStream.fromJson(Map<String, dynamic> json) {
    return LiveStream(
      id: json['id'],
      title: json['title'],
      streamUrl: json['stream_url'],
      status: json['status'],
      startedAt: json['started_at'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }
}

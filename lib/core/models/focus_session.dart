class FocusSession {
  final int duration;
  final String date;
  final String sound;

  FocusSession({
    required this.duration,
    required this.date,
    required this.sound,
  });

  // Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'date': date,
      'sound': sound,
    };
  }

  // JSON -> Object
  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      duration: json['duration'],
      date: json['date'],
      sound: json['sound'],
    );
  }
}
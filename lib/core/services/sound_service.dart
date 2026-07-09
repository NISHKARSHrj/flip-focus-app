import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _rainPlayer = AudioPlayer();

  static final AudioPlayer _completePlayer = AudioPlayer();

  static Future<void> playRain() async {
    await _rainPlayer.setReleaseMode(ReleaseMode.loop);

    await _rainPlayer.play(AssetSource('sounds/rain.mp3'));
  }

  static Future<void> stopRain() async {
    await _rainPlayer.stop();
  }

  static Future<void> playComplete() async {
    await _completePlayer.play(
      AssetSource(
        "sounds/complete.mp3"
      )
    );
  }
  static Future<void> stopAll() async {
    await _rainPlayer.stop();

    await _completePlayer.stop();
  }
}

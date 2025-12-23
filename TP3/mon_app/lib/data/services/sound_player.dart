import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playWin() async {
    await _player.play(AssetSource('sounds/win.mp3'));
  }

  Future<void> playLose() async {
    await _player.play(AssetSource('sounds/lose.mp3'));
  }

  Future<void> dispose() => _player.dispose();
}

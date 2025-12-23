import 'package:audioplayers/audioplayers.dart';

class SfxPlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> correct() async {
    await _player.stop();
    await _player.play( AssetSource('sounds/correct.mp3'));
  }

  Future<void> wrong() async {
    await _player.stop();
    await _player.play( AssetSource('sounds/wrong.mp3'));
  }

  Future<void> win() async {
    await _player.stop();
    await _player.play( AssetSource('sounds/win.mp3'));
  }

  Future<void> lose() async {
    await _player.stop();
    await _player.play( AssetSource('sounds/lose.mp3'));
  }

  Future<void> dispose() => _player.dispose();
}

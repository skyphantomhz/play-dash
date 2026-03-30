import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class FeedbackService {
  static final FeedbackService instance = FeedbackService._();
  
  FeedbackService._();

  bool _hapticsEnabled = true;
  bool _audioEnabled = true;

  late final AudioPlayer _impactPlayer;
  late final AudioPlayer _successPlayer;
  late final AudioPlayer _errorPlayer;

  bool get hapticsEnabled => _hapticsEnabled;
  bool get audioEnabled => _audioEnabled;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _hapticsEnabled = prefs.getBool('haptics_enabled') ?? true;
    _audioEnabled = prefs.getBool('audio_enabled') ?? true;

    _impactPlayer = AudioPlayer();
    _successPlayer = AudioPlayer();
    _errorPlayer = AudioPlayer();

    // Fire-and-forget preloads so the files are instantly available on tap.
    // IMPORTANT: Make sure the physical asset files exist in `assets/sounds/`
    // e.g. `assets/sounds/thud.mp3`, `assets/sounds/chime.mp3`, `assets/sounds/buzz.mp3`
    // and that the folder is declared in `pubspec.yaml`.
    try {
      await _impactPlayer.setSource(AssetSource('sounds/thud.mp3'));
      await _successPlayer.setSource(AssetSource('sounds/chime.mp3'));
      await _errorPlayer.setSource(AssetSource('sounds/buzz.mp3'));
    } catch (_) {
      // Gracefully ignore missing assets at runtime
    }
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    _hapticsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('haptics_enabled', enabled);
  }

  Future<void> setAudioEnabled(bool enabled) async {
    _audioEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('audio_enabled', enabled);
  }

  Future<void> playImpact() async {
    if (_hapticsEnabled) {
      await HapticFeedback.lightImpact();
    }
    if (_audioEnabled) {
      _playSound(_impactPlayer);
    }
  }

  Future<void> playSuccess() async {
    if (_hapticsEnabled) {
      await HapticFeedback.mediumImpact();
    }
    if (_audioEnabled) {
      _playSound(_successPlayer);
    }
  }

  Future<void> playError() async {
    if (_hapticsEnabled) {
      await HapticFeedback.vibrate();
    }
    if (_audioEnabled) {
      _playSound(_errorPlayer);
    }
  }

  Future<void> _playSound(AudioPlayer player) async {
    if (player.state == PlayerState.playing) {
      await player.stop();
    }
    try {
      await player.resume();
    } catch (_) {
      // Ignored: either the audio pipeline isn't ready or the file is missing
    }
  }
}

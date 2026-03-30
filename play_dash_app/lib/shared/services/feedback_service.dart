import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackService {
  static final FeedbackService instance = FeedbackService._();
  
  FeedbackService._();

  bool _hapticsEnabled = true;
  bool _audioEnabled = true;

  bool get hapticsEnabled => _hapticsEnabled;
  bool get audioEnabled => _audioEnabled;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _hapticsEnabled = prefs.getBool('haptics_enabled') ?? true;
    _audioEnabled = prefs.getBool('audio_enabled') ?? true;
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
      // TODO: Implement audio
    }
  }

  Future<void> playSuccess() async {
    if (_hapticsEnabled) {
      await HapticFeedback.mediumImpact();
    }
    if (_audioEnabled) {
      // TODO: Implement audio
    }
  }

  Future<void> playError() async {
    if (_hapticsEnabled) {
      await HapticFeedback.vibrate();
    }
    if (_audioEnabled) {
      // TODO: Implement audio
    }
  }
}

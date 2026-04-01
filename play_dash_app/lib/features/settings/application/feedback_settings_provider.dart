import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/feedback_service.dart';

/// Immutable state snapshot for the FeedbackService toggles.
class FeedbackSettingsState {
  const FeedbackSettingsState({
    required this.hapticsEnabled,
    required this.audioEnabled,
  });

  final bool hapticsEnabled;
  final bool audioEnabled;

  FeedbackSettingsState copyWith({
    bool? hapticsEnabled,
    bool? audioEnabled,
  }) {
    return FeedbackSettingsState(
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      audioEnabled: audioEnabled ?? this.audioEnabled,
    );
  }
}

/// Notifier that wraps [FeedbackService] so the UI can rebuild on toggle.
class FeedbackSettingsNotifier extends Notifier<FeedbackSettingsState> {
  @override
  FeedbackSettingsState build() {
    return FeedbackSettingsState(
      hapticsEnabled: FeedbackService.instance.hapticsEnabled,
      audioEnabled: FeedbackService.instance.audioEnabled,
    );
  }

  Future<void> setHapticsEnabled(bool value) async {
    await FeedbackService.instance.setHapticsEnabled(value);
    state = state.copyWith(hapticsEnabled: value);
  }

  Future<void> setAudioEnabled(bool value) async {
    await FeedbackService.instance.setAudioEnabled(value);
    state = state.copyWith(audioEnabled: value);
  }
}

final feedbackSettingsProvider =
    NotifierProvider<FeedbackSettingsNotifier, FeedbackSettingsState>(
  FeedbackSettingsNotifier.new,
);

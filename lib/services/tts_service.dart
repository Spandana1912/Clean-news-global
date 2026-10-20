import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsResult { ok, languageUnavailable, failed }

/// Reads text aloud in the app's selected language.
class TtsService {
  final FlutterTts _tts = FlutterTts();

  int _session = 0; // incremented on every speak()/stop() to cancel old runs
  bool _speaking = false;

  /// Called whenever speaking starts or stops.
  void Function(bool speaking)? onStateChanged;

  bool get isSpeaking => _speaking;

  /// Maps the app language setting to a TTS locale.
  static String localeFor(String language) {
    switch (language) {
      case 'Tamil':
        return 'ta-IN';
      case 'Telugu':
        return 'te-IN';
      case 'Hindi':
        return 'hi-IN';
      default:
        return 'en-IN';
    }
  }

  Future<TtsResult> speak(String rawText, {required String language}) async {
    final session = ++_session;

    try {
      final locale = localeFor(language);

      final available = await _tts.isLanguageAvailable(locale);
      if (available != true && available != 1) {
        return TtsResult.languageUnavailable;
      }

      final chunks = _chunk(_clean(rawText));
      if (chunks.isEmpty) return TtsResult.failed;

      await _tts.setLanguage(locale);
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);

      _setSpeaking(true);

      for (final chunk in chunks) {
        if (session != _session) break; // stopped or replaced
        await _tts.speak(chunk);
      }

      return TtsResult.ok;
    } catch (e) {
      debugPrint('TTS error: $e');
      return TtsResult.failed;
    } finally {
      if (session == _session) _setSpeaking(false);
    }
  }

  Future<void> stop() async {
    _session++;
    _setSpeaking(false);
    try {
      await _tts.stop();
    } catch (e) {
      debugPrint('TTS stop error: $e');
    }
  }

  Future<void> dispose() => stop();

  void _setSpeaking(bool value) {
    if (_speaking == value) return;
    _speaking = value;
    onStateChanged?.call(value);
  }

  /// Removes markdown symbols so they are not read out loud.
  String _clean(String text) {
    return text
        .replaceAll(RegExp(r'[*#`]'), '')
        .replaceAll(RegExp(r'^\s*[-•]\s+', multiLine: true), '')
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .replaceAll(RegExp(r'\n{2,}'), '\n')
        .trim();
  }

  /// Android limits a single utterance to ~4000 characters, so long text is
  /// split at sentence boundaries.
  List<String> _chunk(String text, {int maxLength = 3000}) {
    if (text.isEmpty) return [];

    final sentences = text.split(RegExp(r'(?<=[.!?।\n])'));
    final chunks = <String>[];
    var current = StringBuffer();

    for (final sentence in sentences) {
      if (current.length + sentence.length > maxLength && current.isNotEmpty) {
        chunks.add(current.toString().trim());
        current = StringBuffer();
      }
      current.write(sentence);
    }

    if (current.toString().trim().isNotEmpty) {
      chunks.add(current.toString().trim());
    }

    return chunks;
  }
}
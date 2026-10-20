import 'package:flutter/material.dart';

import 'app_strings.dart';
import 'services/tts_service.dart';
import 'theme.dart';

/// Dialog that shows the AI summary and can read it aloud.
class AiSummaryDialog extends StatefulWidget {
  final Future<String> summaryFuture;
  final String language;

  const AiSummaryDialog({
    super.key,
    required this.summaryFuture,
    required this.language,
  });

  @override
  State<AiSummaryDialog> createState() => _AiSummaryDialogState();
}

class _AiSummaryDialogState extends State<AiSummaryDialog> {
  final TtsService _tts = TtsService();

  bool _loading = true;
  bool _speaking = false;
  String? _summary;
  String? _error;
  String? _voiceMessage;

  @override
  void initState() {
    super.initState();

    _tts.onStateChanged = (speaking) {
      if (mounted) setState(() => _speaking = speaking);
    };

    widget.summaryFuture.then(
      (text) {
        if (!mounted) return;
        setState(() {
          _summary = text;
          _loading = false;
        });
      },
      onError: (Object e) {
        if (!mounted) return;
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _loading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _tts.dispose();
    super.dispose();
  }

  Future<void> _toggleSpeech(AppStrings s) async {
    if (_speaking) {
      await _tts.stop();
      return;
    }

    final text = _summary;
    if (text == null || text.isEmpty) return;

    setState(() => _voiceMessage = null);

    final result = await _tts.speak(text, language: widget.language);

    if (!mounted) return;

    if (result == TtsResult.languageUnavailable) {
      setState(() => _voiceMessage = s.voiceNotAvailable);
    } else if (result == TtsResult.failed) {
      setState(() => _voiceMessage = s.voiceFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? darkCardColor : const Color(0xFFEFE2C7);
    final textColor = isDark ? darkInkColor : inkColor;
    final accentColor = isDark ? darkBrownColor : brownColor;

    Widget body;

    if (_loading) {
      body = Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: accentColor),
            const SizedBox(height: 16),
            Text(
              s.preparingSummary,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      );
    } else if (_error != null) {
      body = SingleChildScrollView(
        child: Text(_error!, style: TextStyle(color: textColor, height: 1.6)),
      );
    } else {
      body = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              (_summary == null || _summary!.isEmpty)
                  ? s.noSummaryReturned
                  : _summary!,
              style: TextStyle(color: textColor, height: 1.6, fontSize: 13),
            ),
            if (_voiceMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _voiceMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ],
          ],
        ),
      );
    }

    final canListen = !_loading && _error == null && (_summary ?? '').isNotEmpty;

    return AlertDialog(
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      title: Row(
        children: [
          Icon(Icons.auto_awesome, color: accentColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              s.aiArticleSummary,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(width: 520, child: body),
      actions: [
        if (canListen)
          TextButton.icon(
            onPressed: () => _toggleSpeech(s),
            icon: Icon(
              _speaking ? Icons.stop_circle_outlined : Icons.volume_up_outlined,
              color: accentColor,
            ),
            label: Text(
              (_speaking ? s.stopListening : s.listen).toUpperCase(),
              style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            s.close.toUpperCase(),
            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
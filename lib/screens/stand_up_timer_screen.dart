import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:todo_health_reminders/l10n/app_localizations.dart';
import 'package:todo_health_reminders/models/reminder.dart';
import 'package:todo_health_reminders/widgets/responsive_layout.dart';

class StandUpTimerScreen extends StatefulWidget {
  final Reminder reminder;
  final bool isManualSession;

  const StandUpTimerScreen({
    super.key,
    required this.reminder,
    this.isManualSession = false,
  });

  @override
  State<StandUpTimerScreen> createState() => _StandUpTimerScreenState();
}

class _StandUpTimerScreenState extends State<StandUpTimerScreen> {
  Timer? _timer;
  int _elapsedMinutes = 0;
  int _targetMinutes = 15;
  bool _isPaused = false;
  bool _isCompleted = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // Get target duration from reminder's customInterval field
    _targetMinutes = widget.reminder.customInterval ?? 15;
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (!_isPaused && !_isCompleted) {
        setState(() {
          _elapsedMinutes++;
          if (_elapsedMinutes >= _targetMinutes) {
            _completeChallenge();
          }
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _addMinutes() {
    setState(() {
      _targetMinutes++;
    });
  }

  void _completeChallenge() {
    setState(() {
      _isCompleted = true;
      _isPaused = true;
    });
    _timer?.cancel();
    _confettiController.play();
  }

  bool get _completedFullDuration => _elapsedMinutes >= _targetMinutes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progress = _elapsedMinutes / _targetMinutes;
    final title = widget.isManualSession 
        ? '${l10n.standUpChallenge} (${l10n.manualSession})'
        : l10n.standUpChallenge;

    return ResponsiveLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isCompleted) ...[
                      const Icon(
                        Icons.emoji_events,
                        size: 100,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.greatJob,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.youDidIt,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                    ] else ...[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 250,
                            height: 250,
                            child: CircularProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              strokeWidth: 12,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress >= 1.0 ? Colors.green : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '$_elapsedMinutes',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 72,
                                    ),
                              ),
                              Text(
                                'of $_targetMinutes ${l10n.minutes}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _togglePause,
                            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                            label: Text(_isPaused ? l10n.resume : l10n.pause),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _addMinutes,
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addMinutes),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (_elapsedMinutes >= _targetMinutes)
                        ElevatedButton(
                          onPressed: _completeChallenge,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                          ),
                          child: Text(
                            l10n.complete,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                    ],
                    if (_isCompleted) ...[
                      ElevatedButton(
                        onPressed: () {
                          // Return true if completed full duration, especially for manual sessions
                          Navigator.of(context).pop(_completedFullDuration);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      if (widget.isManualSession && _completedFullDuration) ...[
                        const SizedBox(height: 16),
                        Text(
                          l10n.nextPeriodMarked,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.green,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 3.14 / 2, // Down
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.3,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

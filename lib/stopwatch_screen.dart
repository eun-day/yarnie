
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  int _presetTime = 0;

  @override
  void initState() {
    super.initState();
    _loadPresetTime();
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
  }

  void _loadPresetTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _presetTime = prefs.getInt('presetTime') ?? 0;
      _stopWatchTimer.setPresetTime(mSec: _presetTime);
    });
  }

  void _savePresetTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('presetTime', _stopWatchTimer.rawTime.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snap) {
                final value = snap.data!;
                final displayTime = StopWatchTimer.getDisplayTime(value, hours: _isHours);
                return Text(
                  displayTime,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _stopWatchTimer.onStartTimer();
                  },
                  child: const Text('Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _stopWatchTimer.onStopTimer();
                  },
                  child: const Text('Stop'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _stopWatchTimer.onResetTimer();
                  },
                  child: const Text('Undo'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePresetTime,
              child: const Text('Save Time'),
            ),
          ],
        ),
      ),
    );
  }
}

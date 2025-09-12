class SessionStopwatch {
  final Stopwatch _sw = Stopwatch();
  int _baseElapsedMs = 0; // DB에서 불러온 누적 시간(ms)

  bool get isRunning => _sw.isRunning;

  void start({int initialElapsedMs = 0}) {
    _baseElapsedMs = initialElapsedMs;
    _sw.start();
  }

  void resume() {
    _sw.start();
  }

  void pause() {
    _sw.stop();
  }

  void stop() {
    _sw.stop();
    _baseElapsedMs = 0;
    _sw.reset();
  }

    void reset() {
    _sw.stop();
    _sw.reset();
    _baseElapsedMs = 0;
  }

  int get elapsedMs => _baseElapsedMs + _sw.elapsedMilliseconds;
  Duration get elapsed => Duration(milliseconds: elapsedMs);
}
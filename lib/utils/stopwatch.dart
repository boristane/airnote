class AirnoteStopwatch {
  final Stopwatch _stopWatch = Stopwatch();
  Duration _initialOffset;

  AirnoteStopwatch({Duration initialOffset = Duration.zero})
      : _initialOffset = initialOffset;

  start() => _stopWatch.start();
  stop() => _stopWatch.stop();

  reset({Duration initialOffset = Duration.zero}) {
    _stopWatch.reset();
    _initialOffset = initialOffset;
  }

  Duration get elapsed => _stopWatch.elapsed + _initialOffset;
  int get elapsedMilliseconds => _stopWatch.elapsedMilliseconds + _initialOffset.inMilliseconds;
  bool get isRunning => _stopWatch.isRunning;
}

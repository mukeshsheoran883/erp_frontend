import 'dart:async';

class CustomTimer implements Timer {
  final Zone _zone;
  final Stopwatch _activeTimer = Stopwatch();
  Timer? _timer;
  final Duration _originalDuration;
  void Function(CustomTimer)? _onTimeout;
  int _tick = 0;

  CustomTimer(Duration duration)
      : _originalDuration = duration,
        _zone = Zone.current {
    _startTimer();
  }

  void onTimeout(void Function(CustomTimer)? callback) {
    _onTimeout = callback == null ? null : _zone.bindUnaryCallback(callback);
  }

  @override
  int get tick => _tick;

  // Whether the timer is actively counting.
  @override
  bool get isActive => _timer?.isActive ?? false;

  // Whether the timer is started, but not currently actively counting.
  bool get isPaused {
    final timer = _timer;
    return timer != null && !timer.isActive;
  }

  // Whether the timer has expired.
  bool get isExpired => _timer == null;

  /// Pauses an active timer.
  ///
  /// Nothing happens if the timer is already paused or expired.
  void pause() {
    _pauseTimer();
  }

  /// Resumes counting when paused.
  ///
  /// Nothing happens if the timer is active or expired.
  void resume() {
    final timer = _timer;
    if (timer == null || timer.isActive) return;
    _startTimer();
  }

  /// Resets the timer.
  ///
  /// Sets the timer to its original duration.
  /// Does not change whether the timer is active, paused or expired.
  void reset() {
    final timer = _timer;
    if (timer == null) return; // is expired.
    _activeTimer
      ..stop()
      ..reset();
    if (timer.isActive) {
      timer.cancel();
    }
  }

  /// Restarts the timer.
  ///
  /// Starts counting for the original duration.
  /// Works whether the timer is active, paused or expired.
  void start() {
    _timer?.cancel();
    _activeTimer
      ..stop()
      ..reset();
    _startTimer();
  }

  /// Stops and expires the current timer.
  ///
  /// Nothing happens if the timer is already expired.
  @override
  void cancel() {
    _timer?.cancel();
    _expireTimer();
  }

  void _startTimer() {
    final elapsed = _activeTimer.elapsedMilliseconds;
    var duration = _originalDuration;
    if (elapsed > 0) {
      duration = Duration(milliseconds: _originalDuration.inMilliseconds - elapsed);
    }
    _timer = _zone.createTimer(duration, _onTick);
    _activeTimer.start();
  }

  void _expireTimer() {
    _timer = null;
    _activeTimer
      ..stop()
      ..reset();
  }

  void _pauseTimer() {
    _timer?.cancel();
    _activeTimer.stop();
  }

  void _onTick() {
    _tick++;
    _expireTimer();
    final callback = _onTimeout;
    if (callback != null) {
      _zone.runUnary(callback, this);
    }
  }
}

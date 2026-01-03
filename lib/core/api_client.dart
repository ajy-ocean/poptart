import 'dart:async';

class ApiClient {
  static DateTime? _lastRequest;
  static Future<void> throttle() async {
    if (_lastRequest != null) {
      final diff = DateTime.now().difference(_lastRequest!);
      if (diff.inMilliseconds < 1000) {
        await Future.delayed(Duration(milliseconds: 1000 - diff.inMilliseconds));
      }
    }
    _lastRequest = DateTime.now();
  }
}
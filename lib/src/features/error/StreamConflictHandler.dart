import 'dart:async';

import 'package:xmpp_stone/src/Connection.dart';
import 'package:xmpp_stone/src/elements/nonzas/Nonza.dart';
import 'package:xmpp_stone/src/elements/nonzas/StreamConflictNonza.dart';
import 'package:xmpp_stone/src/features/error/StreamErrorApi.dart';
import 'package:xmpp_stone/src/logger/Log.dart';

class StreamConflictHandler extends StreamErrorApi {
  static const TAG = 'StreamConflict';
  Connection? _connection;
  late StreamSubscription<Nonza> subscription;

  StreamConflictHandler(Connection? connection) {
    _connection = connection;
  }

  void init() {
    Log.d(TAG, 'checking stream conflict');
    subscription = _connection!.inNonzasStream.listen(checkNonzas);
  }

  void dispose() {
    subscription.cancel();
  }

  void checkNonzas(Nonza nonza) {
    if (match([nonza]).isNotEmpty && _connection!.isOpened()) {
      _connection!.handleStreamConflictErrorThrown();
    }
  }

  List<Nonza> match(List<Nonza> requests) {
    return requests
        .where((element) => StreamConflictNonza.match(element))
        .toList();
  }
}

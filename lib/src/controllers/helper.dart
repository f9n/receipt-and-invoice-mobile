import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

navTo(context, Widget child, {bool isDialog = false}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: ((context) => child),
      fullscreenDialog: isDialog,
    ),
  );
}

log(msg) {
  if (kDebugMode) {
    print(msg);
  }
}

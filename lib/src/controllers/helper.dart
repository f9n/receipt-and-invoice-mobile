import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

navTo(context, Widget child) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: ((context) => child),
    ),
  );
}

log(msg) {
  if (kDebugMode) {
    print(msg);
  }
}

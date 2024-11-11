import 'package:flutter/material.dart';

import '../config.dart';

Container circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 10.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(pcBlue),
    ),
  );
}

Container linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(bottom: 10.0),
    child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(pcBlue),
    ),
  );
}
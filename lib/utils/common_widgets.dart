import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class CommonWidgets {
  showDialog(BuildContext context, message) {
    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          // title: const Text("title"),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text("Ok"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      );
    } else {
      messangerKey.currentState!.showSnackBar(SnackBar(
        content: Text(message),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  void closekeyboard(ctx) {
    if (MediaQuery.of(ctx).viewInsets.bottom > 0) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

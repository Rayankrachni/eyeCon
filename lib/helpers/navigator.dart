import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

/// NAVIGATOR PUSH
void push({
  required BuildContext context,
  required Widget screen,
  PageTransitionType type = PageTransitionType.fade,
}) {
  Navigator.push(
    context,
    PageTransition(type: type, child: screen),
  );
}

/// NAVIGATOR PUSH AND REMOVE
void pushAndRemove({
  required BuildContext context,
  required Widget screen,
  PageTransitionType type = PageTransitionType.fade,
}) {
  Navigator.pushAndRemoveUntil(
    context,
    PageTransition(
      type: type,
      child: screen,
    ),
        (route) => false,
  );
}
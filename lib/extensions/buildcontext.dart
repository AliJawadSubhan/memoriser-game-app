import 'package:animate_routes/animate_routes.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get screenHeight => mediaQuery.size.height;
  double get screenWidth => mediaQuery.size.width;
  void pushScreenTo(Widget page) => Navigator.of(this).pushReplacement(
      AnimateRoute(transition: Transition.cupertino, screen: page));
  void popFromScreen() => Navigator.pop(this);
}

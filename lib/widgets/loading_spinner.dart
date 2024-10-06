import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  final double size;
  final Color? color;
  LoadingSpinner({this.size = 30, this.color});
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SpinKitFadingCube(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }
}

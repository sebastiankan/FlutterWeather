import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    Key? key,
    required this.backgroundImage,
    required this.screenSize,
  }) : super(key: key);

  final String backgroundImage;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.77,
      child: Image.asset(
        backgroundImage,
        fit: BoxFit.fill,
        width: screenSize.width,
        height: screenSize.height,
      ),
    );
  }
}

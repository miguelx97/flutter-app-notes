import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

import '../global/colors.dart';

class ButtonCustom extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onPressed;
  final ButtonCustomSize size;

  const ButtonCustom(
      {super.key,
      required this.text,
      required this.icon,
      this.onPressed,
      this.size = ButtonCustomSize.medium});

  @override
  Widget build(BuildContext context) {
    late EdgeInsetsGeometry padding;
    late double fontSize;
    switch (size) {
      case ButtonCustomSize.small:
        padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 30);
        fontSize = 16;
        break;
      case ButtonCustomSize.medium:
        padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 40);
        fontSize = 18;
        break;
      case ButtonCustomSize.large:
        padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 50);
        fontSize = 20;
        break;
    }
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: ThemeColors.primary,
      disabledColor: Colors.black12,
      padding: padding,
      onPressed: onPressed,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
                color: Colors.white, letterSpacing: 2, fontSize: fontSize),
          ),
          SizedBox(width: 10),
          Icon(
            icon,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

enum ButtonCustomSize { small, medium, large }

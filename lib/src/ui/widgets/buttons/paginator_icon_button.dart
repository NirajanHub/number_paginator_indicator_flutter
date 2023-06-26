import 'package:flutter/material.dart';
import 'package:number_paginator_indicator_flutter/src/ui/widgets/buttons/paginator_button.dart';

/// A paginator button that has an [Icon] as a child, instead of text. The icon
/// scales with the available space, depending on the size of the button.
class PaginatorIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;

  const PaginatorIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginatorButton(
      onPressed: onPressed,
      // size icon depending on available height
      child: Container(
        color: Colors.amber,
        child: icon,
      ),
    );
  }
}

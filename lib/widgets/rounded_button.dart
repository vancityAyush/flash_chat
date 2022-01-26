import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RoundedButton extends StatefulWidget {
  final String text;
  final Color? color;
  final void Function()? onPressed;
  final RoundedLoadingButtonController? controller;

  RoundedButton(
      {Key? key,
      required this.text,
      this.color,
      this.onPressed,
      this.controller})
      : super(key: key);

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.text,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: RoundedLoadingButton(
          animateOnTap: widget.controller == null ? false : true,
          controller: widget.controller ?? RoundedLoadingButtonController(),
          onPressed: widget.onPressed,
          child: Text(widget.text),
          color: widget.color,
        ),
      ),
    );
  }
}

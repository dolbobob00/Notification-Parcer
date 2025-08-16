import 'package:flutter/material.dart';

class ConfirmationDialogue extends StatelessWidget {
  const ConfirmationDialogue({
    super.key,
    this.onConfirm,
    this.onCancel,
    this.titleWidget,
    this.cancelText,
    this.confirmText, this.message,
  });
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String? cancelText;
  final String? confirmText;
  final Widget? titleWidget;
  final Widget? message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          message ?? Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: onCancel,
                child: Text(cancelText ?? 'Cancel'),
              ),
              TextButton(
                onPressed: onConfirm,
                child: Text(confirmText ?? 'Confirm'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

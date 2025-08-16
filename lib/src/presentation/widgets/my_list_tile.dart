import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({super.key, this.onTap, this.leading, this.trailing, this.title, this.subtitle});

  final VoidCallback? onTap;

  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
       
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

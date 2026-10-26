import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(children: const [
      Flexible(child: Divider(indent: 24, endIndent: 16, height: 24)),
      Text('OR'),
      Flexible(child: Divider(indent: 16, endIndent: 24, height: 24)),
    ]);
  }
}

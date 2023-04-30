// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

/// Nav bar and spacing
class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          // 1/5 of screen width
          width: double.infinity,
          constraints: BoxConstraints(
            minWidth: 200,
            maxWidth: 300,
          ),
          child: Text('defaultTargetPlatform.toString()'),
        ),
        SizedBox(width: 10),
        VerticalDivider(thickness: 1, width: 1),
        SizedBox(width: 10),
      ],
    );
  }
}

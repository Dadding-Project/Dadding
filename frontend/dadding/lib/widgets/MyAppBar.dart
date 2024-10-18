import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyAppBar extends StatelessWidget {
  final VoidCallback onNotificationPressed;

  const MyAppBar({
    super.key,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'DADDING',
              style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xff3B6DFF),
      actions: [
        IconButton(
          //icon: const Icon(Icons.notifications),
          icon: SvgPicture.asset(
            'assets/icons/notification.svg',
            width: 18,
            height: 20.13,
          ),
          onPressed: onNotificationPressed,
          color: Colors.white,
        ),
      ],
    );
  }
}
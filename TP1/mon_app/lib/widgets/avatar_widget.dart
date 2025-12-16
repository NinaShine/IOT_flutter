import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: const CircleAvatar(
        radius: 60,
        backgroundImage: AssetImage("assets/images/profile.jpg"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Card"),
        centerTitle: true,
      ),

      body: Container(
        width: double.infinity,          // prend toute la largeur
        padding: const EdgeInsets.all(20),
        alignment: Alignment.topCenter,  // centre les widgets en haut
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Le card rose (en dessous)
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: ProfileCard(),
            ),

            // L'avatar rond (au-dessus)
            const AvatarWidget(),
          ],
        ),
      ),
    );
  }
}

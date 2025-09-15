import 'package:flutter/material.dart';
import '../../widgets/tabs/card_detail_video.dart';

class DetailVideo extends StatelessWidget {
  const DetailVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: const [
            CardDetailVideo(
              videoUrl: 'assets/videos/video1.mp4',
              title: "Rôle de l'Éducation Populaire et la Citoyenneté",
              author: "Saliou Diop",
              profession: "Éducateur Citoyen",
              avatarUrl: "assets/images/profile.png",
            ),
            CardDetailVideo(
              videoUrl: 'assets/videos/video2.mp4',
              title: "Rôle de l'Éducation Populaire et la Citoyenneté",
              author: "Khady Lô",
              profession: "Éducateur Citoyen",
              avatarUrl: "assets/images/profile.png",
            ),
            CardDetailVideo(
              videoUrl: 'assets/videos/video3.mp4',
              title: "Rôle de l'Éducation Populaire et la Citoyenneté",
              author: "Samba Ngom",
              profession: "Éducateur Citoyen",
              avatarUrl: "assets/images/profile.png",
            ),
          ],
        ),
      ),
    );
  }
}
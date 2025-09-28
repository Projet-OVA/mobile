import 'package:flutter/material.dart';
import '../widgets/settings.dart';

class BannerProfile extends StatelessWidget {
  const BannerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Container(
      width: double.infinity,
      height: isTablet ? 280 : 250,
      decoration: const BoxDecoration(
        color: Color(0xFFFFC107),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(300),
          bottomRight: Radius.circular(300),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/cardProfile.png"),
                ),
                SizedBox(height: 10),
                Text(
                  "Saliou Diop",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF322F35),
                  ),
                ),
                Text(
                  "Badge : Ndort",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF322F35),
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
              child: const Icon(
                Icons.settings_outlined,
                color: Color(0xFF322F35),
                size: 22,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String duration;
  final String imageUrl;
  final String description;
  final Color backgroundColor;

  const CustomCard({
    super.key,
    required this.duration,
    required this.imageUrl,
    required this.description,
    this.backgroundColor = const Color(0xFFFCF1E1),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            // Navigation vers une page de détails
            // Navigator.push(
              //  context
              // MaterialPageRoute(
              // builder: (context) => DetailPage(
              //  title: description,
              // imageUrl: imageUrl,
              //  duration: duration,
              //  ),
              //  ),
            // );
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Durée + Favori
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Durée + icône à gauche
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 8,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              duration,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bouton favoris à droite
                      GestureDetector(
                        onTap: () {
                          // Logique future pour favoris
                        },
                        child: const Icon(
                          Icons.bookmarks_outlined,
                          size: 14,
                          color: Color(0x33322F35),
                        ),
                      ),
                    ],
                  ),
                ),
                //const SizedBox(height: 1),
                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF1C1C1C),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  child: Image.asset(
                    imageUrl,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.15,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

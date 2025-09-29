import 'package:SIRA/widgets/tabs/main_layout_community.dart';
import 'package:flutter/material.dart';
import 'package:SIRA/widgets/custom_button.dart';

class PopulaireCommunity extends StatefulWidget {
  const PopulaireCommunity({super.key});

  @override
  State<PopulaireCommunity> createState() => _PopulaireCommunityState();
}

class _PopulaireCommunityState extends State<PopulaireCommunity> {
  int selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return MainLayoutCommunity(
      onFilterSelected: (index) {
        setState(() {
          selectedFilter = index;
        });
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (selectedFilter) {
      case 0:
        return _buildPopulaires();
      case 1:
        return _buildMesPostes();
      case 2:
        return _buildForum();
      case 3:
        return _buildEnregistrer();
      default:
        return const Center(child: Text("Aucun contenu"));
    }
  }

  Widget _buildPopulaires() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: const [
              // Premier post
              PostCard(
                authorName: "Saliou Diop",
                authorSubtitle: "Éducateur Citoyen",
                timeAgo: "il y a 3 heures",
                content:
                "En Afrique, ce concept revêt une importance particulière en raison des défis complexes auxquels le continent fait face : gouvernance, justice sociale",
                category: "Environnement",
                likes: 734,
                comments: 200,
                hasImage: false,
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color: Color(0xFFEBEAEB),
                  thickness: 1,
                  height: 20,
                ),
              ),
              SizedBox(height: 20),
              // Deuxième post
              PostCard(
                authorName: "Saliou Diop",
                authorSubtitle: "Éducateur Citoyen",
                timeAgo: "il y a 3 heures",
                content: "En Afrique, ce concept revêt une importance particulière",
                category: "Environnement",
                likes: 734,
                comments: 200,
                hasImage: true,
                hasNewBadge: true,
              ),
            ],
          ),
        ),
        // Bouton en bas
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: CustomButton(
                text: 'Nouveau Poste',
                borderRadius: 24,
                icon: Icons.edit_note_outlined,
                onPressed: () async {},
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMesPostes() => const Center(child: Text("Mes postes"));
  Widget _buildForum() => const Center(child: Text("Forum"));
  Widget _buildEnregistrer() => const Center(child: Text("Enregistrer"));
}

/// ---- PostCard Widget ----
class PostCard extends StatelessWidget {
  final String authorName;
  final String authorSubtitle;
  final String timeAgo;
  final String content;
  final String category;
  final int likes;
  final int comments;
  final bool hasImage;
  final bool hasNewBadge;

  const PostCard({
    Key? key,
    required this.authorName,
    required this.authorSubtitle,
    required this.timeAgo,
    required this.content,
    required this.category,
    required this.likes,
    required this.comments,
    this.hasImage = false,
    this.hasNewBadge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage: const AssetImage(
                  "assets/images/cardProfile.png",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.42,
                        color: Color(0xFF322F35),
                      ),
                    ),
                    Text(
                      authorSubtitle,
                      style: TextStyle(
                        color: Color(0xFF322F35),
                        fontSize: 9.55,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.more_horiz, color: Color(0xFFABAAAC)),
                  const SizedBox(height: 4),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: Color(0xFF707988),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Content
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555257),
            ),
          ),

          const SizedBox(height: 12),

          /// Image
          if (hasImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                "assets/images/reboiser.png",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 12),

          /// Category
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFF7F8F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: Color(0xFF322F35),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Actions
          Row(
            children: [
              _ActionButton(
                icon: Icons.favorite_border,
                count: likes,
                onTap: () {},
              ),
              const SizedBox(width: 24),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                count: comments,
                onTap: () {},
              ),
              const SizedBox(width: 24),
              _ActionButton(
                icon: Icons.send,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ---- ActionButton ----
class _ActionButton extends StatelessWidget {
  final IconData? icon;
  final int? count;
  final VoidCallback? onTap;

  const _ActionButton({
    Key? key,
    this.icon,
    this.count,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, color: Color(0xFF322F35), size: 20),
            if (icon != null && count != null) const SizedBox(width: 6),
            if (count != null)
              Text(
                count.toString(),
                style: TextStyle(
                  color: Color(0xFF322F35),
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

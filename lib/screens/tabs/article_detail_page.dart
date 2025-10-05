import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/publication_service.dart';
import '../../data/models/publication_model.dart';
import '../../widgets/custom_button.dart';

class ArticleDetailPublication extends StatefulWidget {
  final String publicationId;

  const ArticleDetailPublication({
    super.key,
    required this.publicationId,
  });

  @override
  State<ArticleDetailPublication> createState() => _ArticleDetailPublicationState();
}

class _ArticleDetailPublicationState extends State<ArticleDetailPublication> {
  Publication? currentArticle;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadArticleDetail();
  }

  Future<void> _loadArticleDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final allPublications = await PublicationService.getPublications();

      final article = allPublications.firstWhere(
            (pub) => pub.id == widget.publicationId,
        orElse: () => throw Exception('Article non trouvé'),
      );

      setState(() {
        currentArticle = article;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF322F35)),
          ),
        ),
      );
    }

    if (errorMessage != null || currentArticle == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Erreur de chargement'),
              const SizedBox(height: 8),
              Text(errorMessage ?? 'Article introuvable'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF322F35),
                ),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: "Terminé",
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Barre de recherche
            _buildSearchBar(),

            // Menu de filtres
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildFilterBar(),
            ),

            const SizedBox(height: 8),

            // Contenu scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildBackButton(),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Article',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTitle(),
                    const SizedBox(height: 12),
                    _buildAuthorInfo(),
                    const SizedBox(height: 16),
                    _buildImage(),
                    const SizedBox(height: 16),
                    _buildContent(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                hintText: 'Rechercher...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bookmarks_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFilterItem(Icons.grid_view_outlined, 'Parcours', false),
        _buildFilterItem(Icons.play_circle_outline_outlined, 'Vidéo', false),
        _buildFilterItem(Icons.keyboard_voice_outlined, 'Podcast', false),
        _buildFilterItem(Icons.article_outlined, 'Articles', true),
      ],
    );
  }

  Widget _buildFilterItem(IconData icon, String label, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFC113) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => Navigator.pop(context),
      padding: EdgeInsets.zero,
      alignment: Alignment.centerLeft,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        const Text(
          "Article",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 48), // Balance l'icône de retour
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      currentArticle!.publicationContent,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  Widget _buildAuthorInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFF322F35),
          child: Text(
            currentArticle!.author.prenom[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentArticle!.author.getFullName(),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Text(
              "Éducateur Citoyen",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF979797),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            _formatDate(currentArticle!.publicationDate),
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF979797),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (currentArticle!.attachment?.mediaType == 'IMAGE' &&
        currentArticle!.attachment?.url != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: currentArticle!.attachment!.url,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF322F35)),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.image_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
        ),
      );
    }

    // Image placeholder si pas d'image
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Icon(
        Icons.article_outlined,
        size: 60,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildContent() {
    return Text(
      currentArticle!.publicationContent,
      style: const TextStyle(
        fontSize: 14,
        height: 1.6,
        color: Color(0xFF242327),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
      'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
    ];

    return '${date.day} ${months[date.month - 1]}';
  }
}
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CardDetailVideo extends StatefulWidget {
  final String videoUrl; // URL en ligne ou chemin local
  final String title;
  final String author;
  final String profession;
  final String avatarUrl;

  const CardDetailVideo({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.author,
    required this.profession,
    required this.avatarUrl,
  });

  @override
  State<CardDetailVideo> createState() => _CardDetailVideoState();
}

class _CardDetailVideoState extends State<CardDetailVideo> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    try {
      _controller = widget.videoUrl.startsWith('http')
          ? VideoPlayerController.network(widget.videoUrl)
          : VideoPlayerController.asset(widget.videoUrl);

      _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() => _isInitialized = true);
        _controller.setLooping(true);
        _controller.play(); // lecture auto
      }).catchError((e) {
        debugPrint("Erreur initialisation vidéo : $e");
        setState(() => _hasError = true);
      });
    } catch (e) {
      debugPrint("Erreur vidéo : $e");
      _hasError = true;
    }
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: Text(
            "Impossible de charger la vidéo",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vidéo avec layout sécurisé
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final aspect = _isInitialized ? _controller.value.aspectRatio : 16 / 9;
                final height = width / aspect;

                return SizedBox(
                  width: width,
                  height: height,
                  child: _isInitialized
                      ? VideoPlayer(_controller)
                      : const Center(child: CircularProgressIndicator()),
                );
              },
            ),

            const SizedBox(height: 12),

            // Scrollable pour le reste du contenu
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Auteur + profession
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: widget.avatarUrl.startsWith('http')
                              ? NetworkImage(widget.avatarUrl)
                              : AssetImage(widget.avatarUrl) as ImageProvider,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.author,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.profession,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Description
                    Text(
                      "Description de la vidéo, infos supplémentaires, etc. "
                          "Le contenu est scrollable si nécessaire.",
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

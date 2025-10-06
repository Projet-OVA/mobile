import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../services/publication_service.dart';
import '../../data/models/publication_model.dart';

class DetailPodcastPublication extends StatefulWidget {
  final String publicationId;

  const DetailPodcastPublication({
    super.key,
    required this.publicationId,
  });

  @override
  State<DetailPodcastPublication> createState() => _DetailPodcastPublicationState();
}

class _DetailPodcastPublicationState extends State<DetailPodcastPublication> {
  Publication? currentPodcast;
  bool isLoading = true;
  String? errorMessage;

  // Lecteur audio
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _loadPodcastDetail();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => position = p);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });
  }

  Future<void> _loadPodcastDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final allPublications = await PublicationService.getPublications();

      final podcast = allPublications.firstWhere(
            (pub) => pub.id == widget.publicationId,
        orElse: () => throw Exception('Podcast non trouvé'),
      );

      setState(() {
        currentPodcast = podcast;
        isLoading = false;
      });

      // Charger l'audio si disponible
      if (podcast.attachment?.url != null &&
          podcast.attachment!.url.isNotEmpty) {
        try {
          // Vérifier que c'est bien un fichier audio
          final url = podcast.attachment!.url;
          if (url.contains('.mp3') || url.contains('.wav') ||
              url.contains('.m4a') || url.contains('.aac')) {
            await _audioPlayer.setSourceUrl(url);
          } else {
            print('Format audio non supporté: $url');
          }
        } catch (e) {
          print('Erreur chargement audio: $e');
          // L'audio ne se chargera pas mais l'app ne crashera pas
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _togglePlayPause() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        // Si c'est la première lecture
        if (position == Duration.zero && currentPodcast?.attachment?.url != null) {
          await _audioPlayer.play(UrlSource(currentPodcast!.attachment!.url));
        } else {
          await _audioPlayer.resume();
        }
      }
    } catch (e) {
      print('Erreur lecture audio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible de lire ce podcast'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _seekBackward() async {
    final newPosition = position - const Duration(seconds: 5);
    await _audioPlayer.seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  Future<void> _seekForward() async {
    final newPosition = position + const Duration(seconds: 5);
    await _audioPlayer.seek(newPosition > duration ? duration : newPosition);
  }

  void _changePlaybackSpeed() {
    setState(() {
      if (playbackSpeed == 1.0) {
        playbackSpeed = 1.25;
      } else if (playbackSpeed == 1.25) {
        playbackSpeed = 1.5;
      } else if (playbackSpeed == 1.5) {
        playbackSpeed = 2.0;
      } else {
        playbackSpeed = 1.0;
      }
      _audioPlayer.setPlaybackRate(playbackSpeed);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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

    if (errorMessage != null || currentPodcast == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Erreur de chargement'),
              const SizedBox(height: 8),
              Text(errorMessage ?? 'Podcast introuvable'),
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
      appBar: AppBar(
        title: const Text('Podcast'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF585858),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // TODO: Partager le podcast
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildCoverImage(),
            const SizedBox(height: 24),
            _buildPodcastInfo(),
            const SizedBox(height: 32),
            _buildProgressBar(),
            const SizedBox(height: 8),
            _buildTimeLabels(),
            const SizedBox(height: 32),
            _buildControlButtons(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    if (currentPodcast!.attachment?.url != null) {
      String imageUrl = currentPodcast!.attachment!.url;

      // Convertir les vidéos en thumbnails
      if (currentPodcast!.attachment!.mediaType == 'VIDEO') {
        imageUrl = imageUrl
            .replaceAll('/video/upload/', '/video/upload/so_0,w_800,h_800,c_fill,q_auto/')
            .replaceAll('.mp4', '.jpg')
            .replaceAll('.mov', '.jpg')
            .replaceAll('.avi', '.jpg')
            .replaceAll('.webm', '.jpg');
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 340,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: 340,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF322F35)),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 340,
            decoration: BoxDecoration(
              color: const Color(0xFF322F35),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(
                Icons.podcasts,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 340,
      decoration: BoxDecoration(
        color: const Color(0xFF322F35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Icon(
          Icons.podcasts,
          size: 120,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPodcastInfo() {
    return Column(
      children: [
        Text(
          currentPodcast!.publicationContent,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF242327),
            height: 1.3,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          currentPodcast!.author.getFullName(),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF979797),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final maxValue = duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 100.0;
    final currentValue = position.inSeconds.toDouble().clamp(0.0, maxValue);

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        activeTrackColor: const Color(0xFFE6AE11),
        inactiveTrackColor: const Color(0xFFF2EFED),
        thumbColor: const Color(0xFFE6AE11),
        overlayColor: const Color(0xFFE6AE11).withOpacity(0.2),
      ),
      child: Slider(
        value: currentValue,
        max: maxValue,
        onChanged: currentPodcast?.attachment?.url != null
            ? (value) async {
          await _audioPlayer.seek(Duration(seconds: value.toInt()));
        }
            : null,
      ),
    );
  }

  Widget _buildTimeLabels() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _formatDuration(position),
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF979797),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            _formatDuration(duration),
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF979797),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Bouton vitesse
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _changePlaybackSpeed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF242327)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${playbackSpeed}x',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF242327),
                ),
              ),
            ),
          ),
        ),

        // Reculer 5s
        IconButton(
          icon: const Icon(Icons.replay_5),
          iconSize: 36,
          color: const Color(0xFF242327),
          onPressed: _seekBackward,
        ),

        // Play/Pause
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF242327),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            iconSize: 36,
            color: Colors.white,
            onPressed: currentPodcast?.attachment?.url != null
                ? _togglePlayPause
                : null,
          ),
        ),

        // Avancer 5s
        IconButton(
          icon: const Icon(Icons.forward_5),
          iconSize: 36,
          color: const Color(0xFF242327),
          onPressed: _seekForward,
        ),

        // Favoris
        IconButton(
          icon: const Icon(Icons.favorite_border),
          iconSize: 28,
          color: const Color(0xFF242327),
          onPressed: () {
            // TODO: Ajouter aux favoris
          },
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
// screens/tabs/detail_parcours.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/tabs/card_video.dart';
import '../../widgets/tabs/quiz/question.dart';
import '../../services/course_detail_service.dart';
import '../../data/models/course_detail_model.dart';
import '../../data/models/course_model.dart';

class DetailParcours extends StatefulWidget {
  final String courseId;

  const DetailParcours({
    super.key,
    required this.courseId,
  });

  @override
  State<DetailParcours> createState() => _DetailParcoursState();
}

class _DetailParcoursState extends State<DetailParcours> {
  CourseDetail? courseDetail;
  List<Course> relatedCourses = [];
  bool isLoading = true;
  String? errorMessage;
  
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _loadCourseDetail();
  }

  Future<void> _loadCourseDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final detail = await CourseDetailService.getCourseDetail(widget.courseId);
      final related = await CourseDetailService.getCoursesByCategory(
        detail.category,
        widget.courseId,
      );

      setState(() {
        courseDetail = detail;
        relatedCourses = related;
        isLoading = false;
      });

      // Initialiser la vidéo si nécessaire
      if (detail.attachment?.mediaType == 'VIDEO') {
        _initializeVideo(detail.attachment!.url);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _initializeVideo(String url) {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _chewieController = ChewieController(
              videoPlayerController: _videoController!,
              autoPlay: false,
              looping: false,
              showControls: true,
              materialProgressColors: ChewieProgressColors(
                playedColor: Color(0xFFFBBC04),
                handleColor: Color(0xFFFBBC04),
                backgroundColor: Colors.grey,
                bufferedColor: Colors.grey[300]!,
              ),
              placeholder: Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFBBC04),
                  ),
                ),
              ),
              autoInitialize: true,
              errorBuilder: (context, errorMessage) {
                return Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Erreur de lecture vidéo',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          });
        }
      }).catchError((error) {
        print('Erreur d\'initialisation vidéo: $error');
        if (mounted) {
          setState(() {
            // Afficher un message d'erreur
          });
        }
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF322F35)),
          ),
        ),
      );
    }

    if (errorMessage != null || courseDetail == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red),
              SizedBox(height: 16),
              Text('Erreur de chargement'),
              SizedBox(height: 8),
              Text(errorMessage ?? 'Cours introuvable'),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // En-tête avec média
            _buildMediaHeader(size),

            // Contenu défilable
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre
                      Text(
                        courseDetail!.nom,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Auteur
                      _buildAuthorInfo(),
                      const SizedBox(height: 12),

                      // Description
                      Text(
                        courseDetail!.description,
                        style: const TextStyle(
                          color: Color(0xAAABAAAC),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Catégorie
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF322F35),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          courseDetail!.getCategoryName(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Étapes du cours
                      if (courseDetail!.steps.isNotEmpty) ...[
                        const Text(
                          'Modules du parcours',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...courseDetail!.steps.map((step) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildStepCard(step),
                        )),
                      ],

                      // Cours similaires
                      if (relatedCourses.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Autres parcours ${courseDetail!.getCategoryName()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...relatedCourses.take(3).map((course) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildRelatedCourseCard(course),
                        )),
                      ],

                      const SizedBox(height: 24),

                      // Bouton Quiz
                      if (courseDetail!.hasQuizzes())
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: "Passez le Quiz",
                            onPressed: () async {
                              if (courseDetail!.quizzes.isNotEmpty) {
                                // Prendre le premier quiz
                                final firstQuiz = courseDetail!.quizzes.first;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizQuestionScreen(
                                      quizId: firstQuiz.id,
                                      quizTitle: firstQuiz.nom,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaHeader(Size size) {
    return Stack(
      children: [
        // Média (vidéo ou image)
        Container(
          width: double.infinity,
          height: size.height * 0.35,
          color: Colors.black,
          child: _buildMediaContent(),
        ),

        // Barre de navigation
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Flèche retour
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                ),

                // Icône Favoris
                IconButton(
                  onPressed: () {
                    // TODO: action favoris
                  },
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaContent() {
    if (courseDetail!.attachment == null) {
      return Container(
        color: Colors.grey[800],
        child: const Center(
          child: Icon(Icons.image_outlined, size: 80, color: Colors.grey),
        ),
      );
    }

    final attachment = courseDetail!.attachment!;

    if (attachment.mediaType == 'VIDEO') {
      if (_chewieController != null) {
        return Chewie(controller: _chewieController!);
      } else {
        return Container(
          color: Colors.black,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFFFBBC04),
                  strokeWidth: 3,
                ),
                SizedBox(height: 16),
                Text(
                  'Chargement de la vidéo...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else if (attachment.mediaType == 'IMAGE') {
      return CachedNetworkImage(
        imageUrl: attachment.url,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFBBC04),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[800],
          child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
        ),
      );
    }

    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Icon(Icons.insert_drive_file, size: 80, color: Colors.grey),
      ),
    );
  }

  Widget _buildAuthorInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFF322F35),
          child: Text(
            courseDetail!.creator.prenom[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courseDetail!.creator.getFullName(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            Text(
              'Éducateur Citoyen',
              style: const TextStyle(
                color: Color(0x8888868A),
                fontSize: 9.55,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepCard(CourseStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icône
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              step.attachment?.mediaType == 'VIDEO'
                  ? Icons.play_circle_outline
                  : Icons.article_outlined,
              color: Color(0xFF322F35),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.nom,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  step.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888888),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedCourseCard(Course course) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DetailParcours(courseId: course.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icône
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.school_outlined,
                color: Color(0xFF322F35),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.nom,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF888888),
            ),
          ],
        ),
      ),
    );
  }
}
// models/course_detail_model.dart

class CourseDetail {
  final String id;
  final String nom;
  final String description;
  final String category;
  final Creator creator;
  final Attachment? attachment;
  final List<CourseStep> steps;
  final List<Quiz> quizzes;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseDetail({
    required this.id,
    required this.nom,
    required this.description,
    required this.category,
    required this.creator,
    this.attachment,
    required this.steps,
    required this.quizzes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      creator: Creator.fromJson(json['creator'] ?? {}),
      attachment: json['attachment'] != null 
          ? Attachment.fromJson(json['attachment']) 
          : null,
      steps: (json['steps'] as List? ?? [])
          .map((step) => CourseStep.fromJson(step))
          .toList(),
      quizzes: (json['quizzes'] as List? ?? [])
          .map((quiz) => Quiz.fromJson(quiz))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  String getCategoryName() {
    switch (category) {
      case 'DROIT_DU_CITOYEN':
        return 'Droits du Citoyen';
      case 'DEVOIR_DU_CITOYEN':
        return 'Devoirs du Citoyen';
      case 'ENVIRONNEMENT':
        return 'Environnement';
      default:
        return 'Autre';
    }
  }

  bool hasQuizzes() => quizzes.isNotEmpty;
}

class CourseStep {
  final String id;
  final String nom;
  final String description;
  final int ordre;
  final Attachment? attachment;

  CourseStep({
    required this.id,
    required this.nom,
    required this.description,
    required this.ordre,
    this.attachment,
  });

  factory CourseStep.fromJson(Map<String, dynamic> json) {
    return CourseStep(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      ordre: json['ordre'] ?? 0,
      attachment: json['attachment'] != null 
          ? Attachment.fromJson(json['attachment']) 
          : null,
    );
  }
}

class Creator {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String? profileImage;

  Creator({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.profileImage,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  String getFullName() => '$prenom $nom';
}

class Attachment {
  final String id;
  final String name;
  final String url;
  final String extension;
  final String mediaType;

  Attachment({
    required this.id,
    required this.name,
    required this.url,
    required this.extension,
    required this.mediaType,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      extension: json['extension'] ?? '',
      mediaType: json['mediaType'] ?? '',
    );
  }
}

class Quiz {
  final String id;
  final String nom;
  final String description;
  final int score;

  Quiz({
    required this.id,
    required this.nom,
    required this.description,
    required this.score,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      score: json['score'] ?? 0,
    );
  }
}
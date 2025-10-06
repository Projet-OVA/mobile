
class CourseResponse {
  final List<Course> courses;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  CourseResponse({
    required this.courses,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    return CourseResponse(
      courses: (json['courses'] as List)
          .map((course) => Course.fromJson(course))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class Course {
  final String id;
  final String nom;
  final String description;
  final String category;
  final Creator creator;
  final Attachment? attachment;
  final List<Quiz> quizzes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    required this.id,
    required this.nom,
    required this.description,
    required this.category,
    required this.creator,
    this.attachment,
    required this.quizzes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      creator: Creator.fromJson(json['creator'] ?? {}),
      attachment: json['attachment'] != null
          ? Attachment.fromJson(json['attachment'])
          : null,
      quizzes: (json['quizzes'] as List? ?? [])
          .map((quiz) => Quiz.fromJson(quiz))
          .toList(),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Méthode pour obtenir le nom de la catégorie en français
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

  // Méthode pour obtenir l'URL de l'image ou une image par défaut
  String getImageUrl() {
    return attachment?.url ?? 'assets/images/default_course.png';
  }
}

class Creator {
  final String id;
  final String nom;
  final String prenom;
  final String email;

  Creator({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
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

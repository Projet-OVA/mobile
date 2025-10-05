class Publication {
  final String id;
  final DateTime publicationDate;
  final String publicationContent;
  final String status;
  final String publicationType; // MEDIA, TEXT, PODCAST
  final Author author;
  final PublicationAttachment? attachment;

  Publication({
    required this.id,
    required this.publicationDate,
    required this.publicationContent,
    required this.status,
    required this.publicationType,
    required this.author,
    this.attachment,
  });

  factory Publication.fromJson(Map<String, dynamic> json) {
    return Publication(
      id: json['id'] ?? '',
      publicationDate: DateTime.parse(json['publicationDate'] ?? DateTime.now().toIso8601String()),
      publicationContent: json['publicationContent'] ?? '',
      status: json['status'] ?? '',
      publicationType: json['publicationType'] ?? '',
      author: Author.fromJson(json['author'] ?? {}),
      attachment: json['attachment'] != null
          ? PublicationAttachment.fromJson(json['attachment'])
          : null,
    );
  }

  bool isVideo() => publicationType == 'MEDIA' && attachment?.mediaType == 'VIDEO';
  bool isImage() => attachment?.mediaType == 'IMAGE';
  bool isPodcast() => publicationType == 'PODCAST';
  bool isText() => publicationType == 'TEXT';
}

class Author {
  final String id;
  final String nom;
  final String prenom;
  final String username;

  Author({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.username,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      username: json['username'] ?? '',
    );
  }

  String getFullName() => '$prenom $nom';
}

class PublicationAttachment {
  final String id;
  final String name;
  final String url;
  final String extension;
  final String mediaType; // VIDEO, IMAGE
  final int bytes;
  final String folder;
  final DateTime createdAt;

  PublicationAttachment({
    required this.id,
    required this.name,
    required this.url,
    required this.extension,
    required this.mediaType,
    required this.bytes,
    required this.folder,
    required this.createdAt,
  });

  factory PublicationAttachment.fromJson(Map<String, dynamic> json) {
    return PublicationAttachment(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      extension: json['extension'] ?? '',
      mediaType: json['mediaType'] ?? '',
      bytes: json['bytes'] ?? 0,
      folder: json['folder'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
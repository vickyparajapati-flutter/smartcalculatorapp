import 'dart:convert';

class VaultPhoto {
  final String id;
  final String path;
  final DateTime dateAdded;
  final String? note;

  VaultPhoto({
    required this.id,
    required this.path,
    required this.dateAdded,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'dateAdded': dateAdded.toIso8601String(),
      'note': note,
    };
  }

  factory VaultPhoto.fromMap(Map<String, dynamic> map) {
    return VaultPhoto(
      id: map['id'] ?? '',
      path: map['path'] ?? '',
      dateAdded: DateTime.parse(map['dateAdded']),
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());
  factory VaultPhoto.fromJson(String source) => VaultPhoto.fromMap(json.decode(source));
}

class VaultNote {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;

  VaultNote({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory VaultNote.fromMap(Map<String, dynamic> map) {
    return VaultNote(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());
  factory VaultNote.fromJson(String source) => VaultNote.fromMap(json.decode(source));
}

class VaultContact {
  final String id;
  String name;
  String phone;
  String? note;

  VaultContact({
    required this.id,
    required this.name,
    required this.phone,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'note': note,
    };
  }

  factory VaultContact.fromMap(Map<String, dynamic> map) {
    return VaultContact(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());
  factory VaultContact.fromJson(String source) => VaultContact.fromMap(json.decode(source));
}


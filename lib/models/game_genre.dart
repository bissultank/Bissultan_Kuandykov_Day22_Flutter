import 'package:flutter/material.dart';

class GameGenre {
  final String id;
  final String name;
  final IconData icon;

  const GameGenre({
    required this.id,
    required this.name,
    required this.icon,
  });

  // Конвертация в JSON для сохранения
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': icon.codePoint,
    };
  }

  // Создание объекта из JSON
  factory GameGenre.fromJson(Map<String, dynamic> json) {
    return GameGenre(
      id: json['id'],
      name: json['name'],
      icon: IconData(json['iconCodePoint'], fontFamily: 'MaterialIcons'),
    );
  }

  // Список доступных жанров
  static List<GameGenre> getAllGenres() {
    return const [
      GameGenre(
        id: 'action',
        name: 'Экшен',
        icon: Icons.sports_martial_arts,
      ),
      GameGenre(
        id: 'rpg',
        name: 'RPG',
        icon: Icons.auto_awesome,
      ),
      GameGenre(
        id: 'strategy',
        name: 'Стратегии',
        icon: Icons.psychology,
      ),
      GameGenre(
        id: 'horror',
        name: 'Хорроры',
        icon: Icons.nightlight_round,
      ),
      GameGenre(
        id: 'shooter',
        name: 'Шутеры',
        icon: Icons.control_camera,
      ),
      GameGenre(
        id: 'indie',
        name: 'Инди',
        icon: Icons.favorite,
      ),
      GameGenre(
        id: 'simulator',
        name: 'Симуляторы',
        icon: Icons.flight,
      ),
      GameGenre(
        id: 'adventure',
        name: 'Приключения',
        icon: Icons.explore,
      ),
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameGenre && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_genre.dart';
import 'settings_screen.dart';
import 'top10_games_screen.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  static const String _selectedGenresKey = 'selectedGenres';
  late SharedPreferences _prefs;
  List<GameGenre> _allGenres = [];
  Set<String> _selectedGenreIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    _prefs = await SharedPreferences.getInstance();
    _allGenres = GameGenre.getAllGenres();
    await _loadSelectedGenres();
    setState(() {
      _isLoading = false;
    });
  }

  // Загрузка сохраненных жанров
  Future<void> _loadSelectedGenres() async {
    final String? savedData = _prefs.getString(_selectedGenresKey);
    if (savedData != null) {
      final List<dynamic> decoded = jsonDecode(savedData);
      _selectedGenreIds = decoded.map((id) => id.toString()).toSet();
    }
  }

  // Сохранение выбранных жанров
  Future<void> _saveSelectedGenres() async {
    final String encoded = jsonEncode(_selectedGenreIds.toList());
    await _prefs.setString(_selectedGenresKey, encoded);
  }

  // Переключение выбора жанра
  void _toggleGenre(String genreId) {
    setState(() {
      if (_selectedGenreIds.contains(genreId)) {
        _selectedGenreIds.remove(genreId);
      } else {
        _selectedGenreIds.add(genreId);
      }
    });
    _saveSelectedGenres();
  }

  // Проверка, выбран ли жанр
  bool _isSelected(String genreId) {
    return _selectedGenreIds.contains(genreId);
  }

  // TODO: Заглушка для будущего функционала "Топ-10 игр"
  void _showTop10Games(GameGenre genre) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Топ-10 игр жанра "${genre.name}" скоро будет доступен!'),
        duration: const Duration(seconds: 2),
      ),
    );
    // В будущем здесь будет:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Top10GamesScreen(genre: genre),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Selector'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Заголовок с описанием
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Выберите любимые жанры',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Выбрано: ${_selectedGenreIds.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Grid с жанрами
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: _allGenres.length,
              itemBuilder: (context, index) {
                final genre = _allGenres[index];
                final isSelected = _isSelected(genre.id);

                return _GenreCard(
                  genre: genre,
                  isSelected: isSelected,
                  onTap: () => _toggleGenre(genre.id),
                  onLongPress: () => _showTop10Games(genre),
                );
              },
            ),
          ),
          // Кнопка "Далее"
          if (_selectedGenreIds.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Top10GamesScreen(
                        selectedGenreIds: _selectedGenreIds.toList(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: Text(
                  'Показать топ-10 игр (${_selectedGenreIds.length} ${_getGenreWord(_selectedGenreIds.length)})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getGenreWord(int count) {
    if (count == 1) return 'жанр';
    if (count >= 2 && count <= 4) return 'жанра';
    return 'жанров';
  }
}

// Виджет карточки жанра
class _GenreCard extends StatelessWidget {
  final GameGenre genre;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _GenreCard({
    required this.genre,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: isSelected ? 8 : 2,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(
                    color: colorScheme.primary,
                    width: 3,
                  )
                : null,
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.secondaryContainer,
                    ],
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                genre.icon,
                size: 48,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                genre.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              if (isSelected) ...[
                const SizedBox(height: 4),
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

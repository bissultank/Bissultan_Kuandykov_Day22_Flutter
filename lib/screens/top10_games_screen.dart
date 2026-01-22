import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/game_genre.dart';

class Top10GamesScreen extends StatelessWidget {
  final List<String> selectedGenreIds;

  const Top10GamesScreen({
    super.key,
    required this.selectedGenreIds,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Получаем игры для всех выбранных жанров
    final gamesByGenre = Game.getTop10ForGenres(selectedGenreIds);
    final allGenres = GameGenre.getAllGenres();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Топ-10 игр'),
      ),
      body: selectedGenreIds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.games,
                    size: 100,
                    color: colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Вы не выбрали ни одного жанра',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Вернитесь назад и выберите жанры',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: selectedGenreIds.length,
              itemBuilder: (context, index) {
                final genreId = selectedGenreIds[index];
                final genre = allGenres.firstWhere((g) => g.id == genreId);
                final games = gamesByGenre[genreId] ?? [];

                return _GenreSection(
                  genre: genre,
                  games: games,
                );
              },
            ),
    );
  }
}

class _GenreSection extends StatelessWidget {
  final GameGenre genre;
  final List<Game> games;

  const _GenreSection({
    required this.genre,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок жанра
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Icon(
                genre.icon,
                color: colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                genre.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        
        // Список игр
        ...games.asMap().entries.map((entry) {
          final index = entry.key;
          final game = entry.value;
          return _GameCard(
            game: game,
            rank: index + 1,
          );
        }),
        
        const SizedBox(height: 24),
        Divider(color: colorScheme.outlineVariant),
      ],
    );
  }
}

class _GameCard extends StatelessWidget {
  final Game game;
  final int rank;

  const _GameCard({
    required this.game,
    required this.rank,
  });

  Color _getRankColor(int rank, ColorScheme colorScheme) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey[400]!;
    if (rank == 3) return Colors.brown[300]!;
    return colorScheme.primaryContainer;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final rankColor = _getRankColor(rank, colorScheme);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // TODO: Открыть детали игры
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Детали "${game.title}" скоро будут доступны!'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Место в топе
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: rankColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: rank <= 3
                      ? [
                          BoxShadow(
                            color: rankColor.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: rank <= 3 ? Colors.white : colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Информация об игре
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название
                    Text(
                      game.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Рейтинг и год
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          game.rating.toString(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          game.year.toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Описание
                    Text(
                      game.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Платформа
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        game.platform,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

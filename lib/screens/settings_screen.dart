import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        children: [
          // Секция темы
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Внешний вид',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SwitchListTile(
              title: const Text('Темная тема'),
              subtitle: Text(
                themeProvider.isDarkMode
                    ? 'Включена темная тема'
                    : 'Включена светлая тема',
              ),
              secondary: Icon(
                themeProvider.isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          const SizedBox(height: 24),
          
          // Секция информации
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'О приложении',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Версия'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.gamepad),
                  title: const Text('Game Selector'),
                  subtitle: const Text('Выбирайте жанры и находите лучшие игры'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Подсказки
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.tips_and_updates,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Подсказки',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTip(
                      context,
                      'Нажмите на жанр для выбора',
                      Icons.touch_app,
                    ),
                    const SizedBox(height: 8),
                    _buildTip(
                      context,
                      'Долгое нажатие откроет топ-10 игр (скоро)',
                      Icons.list,
                    ),
                    const SizedBox(height: 8),
                    _buildTip(
                      context,
                      'Ваш выбор сохраняется автоматически',
                      Icons.save,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(BuildContext context, String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

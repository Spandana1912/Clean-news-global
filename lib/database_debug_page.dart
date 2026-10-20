import 'package:flutter/material.dart';

import 'models/article.dart';
import 'services/article_database.dart';

class DatabaseDebugPage extends StatefulWidget {
  const DatabaseDebugPage({super.key});

  @override
  State<DatabaseDebugPage> createState() => _DatabaseDebugPageState();
}

class _DatabaseDebugPageState extends State<DatabaseDebugPage> {
  final ArticleDatabase _database = ArticleDatabase.instance;

  List<Article> _articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    setState(() {
      _loading = true;
    });

    try {
      final articles = await _database.getSavedArticles();

      if (!mounted) return;

      setState(() {
        _articles = articles;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Database read failed: $e');

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not read database: $e')));
    }
  }

  Future<void> _deleteAll() async {
    if (_articles.isEmpty) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete local database data?'),
          content: const Text(
            'This will remove all locally saved articles '
            'from SQLite. Firestore data will not be deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _database.deleteAllArticles();

    if (!mounted) return;

    await _loadDatabase();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Local SQLite articles deleted.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Database'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loadDatabase,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ========================================================
                // DATABASE INFORMATION
                // ========================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Database',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'clean_news.db',
                            style: TextStyle(fontFamily: 'monospace'),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Saved articles: ${_articles.length}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ========================================================
                // EMPTY DATABASE
                // ========================================================
                if (_articles.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'SQLite database is empty.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                // ========================================================
                // DATABASE CONTENT
                // ========================================================
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _articles.length,
                      itemBuilder: (context, index) {
                        final article = _articles[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ROW ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                _DatabaseField(
                                  name: 'title',
                                  value: article.title,
                                ),

                                _DatabaseField(
                                  name: 'description',
                                  value: article.description,
                                ),

                                _DatabaseField(
                                  name: 'imageUrl',
                                  value: article.imageUrl,
                                ),

                                _DatabaseField(
                                  name: 'source',
                                  value: article.source,
                                ),

                                _DatabaseField(
                                  name: 'publishedAt',
                                  value: article.publishedAt,
                                ),

                                _DatabaseField(
                                  name: 'articleUrl',
                                  value: article.articleUrl,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // ========================================================
                // DELETE LOCAL DATA
                // ========================================================
                if (_articles.isNotEmpty)
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _deleteAll,
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete All Local SQLite Data'),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _DatabaseField extends StatelessWidget {
  final String name;
  final String value;

  const _DatabaseField({required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 3),
          SelectableText(
            value.isEmpty ? '(empty)' : value,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../app/theme/sagres_theme.dart';
import '../infrastructure/in_memory_news_repository.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = const InMemoryNewsRepository().load();
    return SafeArea(
      child: ListView.separated(
        key: const Key('news-screen'),
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
        itemCount: articles.length + 2,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: SagresColors.yellow.withValues(alpha: .3),
                  foregroundColor: SagresColors.red,
                  child: const Icon(Icons.newspaper),
                ),
                const SizedBox(width: 10),
                Text(
                  'Notícias',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            );
          }
          if (index == 1) {
            return const Text(
              'Conteúdo demonstrativo. A integração editorial fica fora desta POC.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            );
          }
          final article = articles[index - 2];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                Container(
                  width: 92,
                  height: 108,
                  color: index == 2 ? SagresColors.red : SagresColors.yellow,
                  child: Icon(
                    index == 2 ? Icons.radio : Icons.campaign,
                    color: index == 2 ? SagresColors.yellow : SagresColors.red,
                    size: 36,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.category.toUpperCase(),
                          style: const TextStyle(
                            color: SagresColors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          article.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          article.publishedLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

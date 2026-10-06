import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/state_views.dart';
import '../application/news_providers.dart';

class NewsListPage extends ConsumerWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Company News & Updates')),
      body: ResponsiveCenter(
        child: newsAsync.when(
          loading: () => const LoadingView(label: 'Loading news...'),
          error: (err, stack) => ErrorView(
            message: err.toString(),
            onRetry: () => ref.refresh(newsListProvider),
          ),
          data: (newsList) {
            if (newsList.isEmpty) {
              return const EmptyView(
                title: 'No News Published',
                message: 'Check back later for company announcements.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: newsList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = newsList[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${item.summary}\n${item.publishedAt.toString().split('.').first}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/home/news/${item.id}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class NewsDetailPage extends ConsumerWidget {
  const NewsDetailPage({required this.newsId, super.key});

  final String newsId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsDetailProvider(newsId));

    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: ResponsiveCenter(
        child: newsAsync.when(
          loading: () => const LoadingView(label: 'Loading article...'),
          error: (err, stack) => ErrorView(
            message: err.toString(),
            onRetry: () => ref.refresh(newsDetailProvider(newsId)),
          ),
          data: (item) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Published: ${item.publishedAt.toString().split('.').first}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.summary,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  const Divider(height: 32),
                  Text(
                    item.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

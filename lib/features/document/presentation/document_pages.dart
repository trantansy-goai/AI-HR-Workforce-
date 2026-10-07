import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/state_views.dart';
import '../application/document_providers.dart';
import '../domain/document_item.dart';

class DocumentListPage extends ConsumerWidget {
  const DocumentListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(documentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Knowledge Documents')),
      body: SafeArea(
        top: false,
        child: ResponsiveCenter(
          maxWidth: ContentConstraints.dashboard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: documentsAsync.when(
                  loading: () =>
                      const LoadingView(label: 'Loading documents...'),
                  error: (err, stack) => ErrorView(
                    message: err.toString(),
                    onRetry: () => ref.refresh(documentsProvider),
                  ),
                  data: (documents) {
                    if (documents.isEmpty) {
                      return const EmptyView(
                        title: 'No Documents Available',
                        message:
                            'No company documents have been published yet.',
                      );
                    }
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final isTablet = constraints.maxWidth >= 600;

                        if (!isTablet) {
                          return ListView.separated(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            itemCount: documents.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) =>
                                _DocumentCard(doc: documents[index]),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: AppSpacing.md,
                                mainAxisSpacing: AppSpacing.md,
                                mainAxisExtent: 96,
                              ),
                          itemCount: documents.length,
                          itemBuilder: (context, index) =>
                              _DocumentCard(doc: documents[index]),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.doc});

  final DocumentItem doc;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: ListTile(
          leading: CircleAvatar(child: Text(doc.fileType)),
          title: Text(
            doc.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            doc.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/home/documents/${doc.id}'),
        ),
      ),
    );
  }
}

class DocumentDetailPage extends ConsumerWidget {
  const DocumentDetailPage({required this.documentId, super.key});

  final String documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentAsync = ref.watch(documentDetailProvider(documentId));

    return Scaffold(
      appBar: AppBar(title: const Text('Document Detail')),
      body: ResponsiveCenter(
        child: documentAsync.when(
          loading: () =>
              const LoadingView(label: 'Loading document details...'),
          error: (err, stack) => ErrorView(
            message: err.toString(),
            onRetry: () => ref.refresh(documentDetailProvider(documentId)),
          ),
          data: (doc) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(label: Text(doc.fileType)),
                      const SizedBox(width: 8),
                      Text(
                        doc.fileSizeFormatted,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    doc.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    doc.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: context.showComingSoon,
                      icon: const Icon(Icons.download),
                      label: const Text('Download Document'),
                    ),
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

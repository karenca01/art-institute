import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exhibitions_provider.dart';
import '../providers/artworks_provider.dart' show ProviderState;
import '../models/exhibition.dart';
import 'detail/exhibition_detail_screen.dart';

class ExhibitionsListScreen extends StatefulWidget {
  const ExhibitionsListScreen({super.key});

  @override
  State<ExhibitionsListScreen> createState() => _ExhibitionsListScreenState();
}

class _ExhibitionsListScreenState extends State<ExhibitionsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExhibitionsProvider>().fetchExhibitions();
    });
  }

  String _formatDateRange(Exhibition exhibition) {
    final start = exhibition.startDate;
    final end = exhibition.endDate;
    if (start == null && end == null) return 'Dates unavailable';
    if (start != null && end != null) return '$start – $end';
    return start ?? end!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exhibitions')),
      body: Consumer<ExhibitionsProvider>(
        builder: (context, provider, child) {
          if (provider.state == ProviderState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == ProviderState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${provider.errorMessage}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchExhibitions(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final exhibitions = provider.exhibitions;

          if (exhibitions.isEmpty) {
            return const Center(
              child: Text('No exhibitions found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchExhibitions(),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: exhibitions.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final exhibition = exhibitions[index];
                return _ExhibitionListTile(
                  exhibition: exhibition,
                  dateRange: _formatDateRange(exhibition),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ExhibitionDetailScreen(exhibitionId: exhibition.id),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ExhibitionListTile extends StatelessWidget {
  final Exhibition exhibition;
  final String dateRange;
  final VoidCallback onTap;

  const _ExhibitionListTile({
    required this.exhibition,
    required this.dateRange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        exhibition.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(dateRange),
      trailing: exhibition.isCurrent == true
          ? Chip(
              label: const Text('Current'),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 12,
              ),
            )
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

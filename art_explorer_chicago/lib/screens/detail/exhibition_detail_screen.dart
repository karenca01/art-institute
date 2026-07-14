import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/exhibitions_provider.dart';
import '../../providers/artworks_provider.dart' show ProviderState;
import '../../widgets/artwork_card.dart';

class ExhibitionDetailScreen extends StatefulWidget {
  final int exhibitionId;

  const ExhibitionDetailScreen({super.key, required this.exhibitionId});

  @override
  State<ExhibitionDetailScreen> createState() => _ExhibitionDetailScreenState();
}

class _ExhibitionDetailScreenState extends State<ExhibitionDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExhibitionsProvider>().fetchExhibition(widget.exhibitionId);
    });
  }

  String _formatDateRange(String? start, String? end) {
    if (start == null && end == null) return 'Dates unavailable';
    if (start != null && end != null) return '$start – $end';
    return start ?? end!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exhibition')),
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
                    onPressed: () => provider.fetchExhibition(widget.exhibitionId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final exhibition = provider.selectedExhibition;
          if (exhibition == null) {
            return const Center(child: Text('Exhibition not found'));
          }

          final artworks = provider.selectedExhibitionArtworks;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exhibition.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (exhibition.isCurrent == true)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Chip(
                                label: const Text('Current'),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primaryContainer,
                                labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              _formatDateRange(
                                  exhibition.startDate, exhibition.endDate),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      if (exhibition.description != null &&
                          exhibition.description!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          exhibition.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Associated Artworks',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (artworks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No associated artworks available for this exhibition.',
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: artworks.length,
                      itemBuilder: (context, index) {
                        return ArtworkCard(artwork: artworks[index]);
                      },
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

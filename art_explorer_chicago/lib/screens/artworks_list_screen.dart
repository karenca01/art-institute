import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/artworks_provider.dart';
import '../widgets/artwork_card.dart';

class ArtworksListScreen extends StatefulWidget {
  const ArtworksListScreen({super.key});

  @override
  State<ArtworksListScreen> createState() => _ArtworksListScreenState();
}

class _ArtworksListScreenState extends State<ArtworksListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _publicDomainOnly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArtworksProvider>().fetchArtworks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final provider = context.read<ArtworksProvider>();
    if (query.isEmpty) {
      provider.fetchArtworks();
    } else {
      provider.searchArtworks(query);
    }
  }

  void _togglePublicDomainFilter(bool? value) {
    setState(() {
      _publicDomainOnly = value ?? false;
    });
    final provider = context.read<ArtworksProvider>();
    if (_searchController.text.isNotEmpty) {
      provider.searchArtworks(_searchController.text);
    } else {
      provider.fetchArtworks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artworks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Consumer<ArtworksProvider>(
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
                          onPressed: () => provider.fetchArtworks(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final artworks = _publicDomainOnly
                    ? provider.artworks.where((a) => a.isPublicDomain == true).toList()
                    : provider.artworks;

                if (artworks.isEmpty) {
                  return const Center(
                    child: Text('No artworks found'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.fetchArtworks(),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search artworks...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Artworks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Public Domain Only'),
              value: _publicDomainOnly,
              onChanged: (value) {
                Navigator.pop(context);
                _togglePublicDomainFilter(value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

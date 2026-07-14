import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/artwork.dart';
import '../../utils/iiif_url_builder.dart';
import 'artist_detail_screen.dart';

class ArtworkDetailScreen extends StatelessWidget {
  final Artwork artwork;

  const ArtworkDetailScreen({super.key, required this.artwork});

  @override
  Widget build(BuildContext context) {
    final imageUrl = artwork.imageId != null
        ? IiifUrlBuilder.buildHighResUrl(artwork.imageId!)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          artwork.title,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              SizedBox(
                height: 400,
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.image_not_supported, size: 48),
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 48),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artwork.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (artwork.artistTitle != null)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtistDetailScreen(
                              artistId: artwork.artistId ?? 0,
                              artistName: artwork.artistTitle!,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        artwork.artistTitle!,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  _buildMetadataRow('Date', artwork.dateDisplay),
                  _buildMetadataRow('Medium', artwork.medium),
                  _buildMetadataRow('Dimensions', artwork.dimensions),
                  _buildMetadataRow('Department', artwork.departmentTitle),
                  _buildMetadataRow('Credit Line', artwork.creditLine),
                  _buildMetadataRow(
                    'Public Domain',
                    artwork.isPublicDomain == true ? 'Yes' : 'No',
                  ),
                  const SizedBox(height: 16),
                  if (artwork.description != null &&
                      artwork.description!.isNotEmpty) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      artwork.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

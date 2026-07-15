import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/museum_info_provider.dart';
import '../providers/artworks_provider.dart' show ProviderState;

class MuseumInfoScreen extends StatefulWidget {
  const MuseumInfoScreen({super.key});

  @override
  State<MuseumInfoScreen> createState() => _MuseumInfoScreenState();
}

class _MuseumInfoScreenState extends State<MuseumInfoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MuseumInfoProvider>().fetchMuseumInfo();
    });
  }

  Future<void> _launch(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open $url')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open link: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Museum Info')),
      body: Consumer<MuseumInfoProvider>(
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
                    onPressed: () => provider.fetchMuseumInfo(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final info = provider.museumInfo;
          if (info == null) {
            return const Center(child: Text('No museum information available'));
          }

          final mapsUrl =
              'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(info.address ?? info.name)}';
          final telUrl = info.phone != null
              ? 'tel:${info.phone!.replaceAll(RegExp(r'[^\d+]'), '')}'
              : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.name,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Hours'),
                if (info.hours != null)
                  Card(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: info.hours!.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final entry = info.hours!.entries.elementAt(index);
                        return ListTile(
                          title: Text(entry.key),
                          trailing: Text(entry.value),
                        );
                      },
                    ),
                  )
                else
                  const Text('Hours unavailable'),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Location'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (info.address != null)
                          Text(info.address!,
                              style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.map),
                          label: const Text('Open in Maps'),
                          onPressed: () => _launch(context, mapsUrl),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Contact'),
                Card(
                  child: Column(
                    children: [
                      if (telUrl != null)
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: Text(info.phone!),
                          onTap: () => _launch(context, telUrl),
                        ),
                      if (info.email != null)
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: Text(info.email!),
                          onTap: () =>
                              _launch(context, 'mailto:${info.email!}'),
                        ),
                      if (info.website != null)
                        ListTile(
                          leading: const Icon(Icons.language),
                          title: Text(info.website!),
                          onTap: () => _launch(context, info.website!),
                        ),
                    ],
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

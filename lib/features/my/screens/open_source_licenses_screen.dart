import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/theme/text_styles.dart';

class OpenSourceLicensesScreen extends StatefulWidget {
  const OpenSourceLicensesScreen({super.key});

  @override
  State<OpenSourceLicensesScreen> createState() => _OpenSourceLicensesScreenState();
}

class _OpenSourceLicensesScreenState extends State<OpenSourceLicensesScreen> {
  final Map<String, List<LicenseEntry>> _licenses = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLicenses();
  }

  Future<void> _loadLicenses() async {
    final Map<String, List<LicenseEntry>> packages = {};
    
    await for (final license in LicenseRegistry.licenses) {
      for (final package in license.packages) {
        if (!packages.containsKey(package)) {
          packages[package] = [];
        }
        packages[package]!.add(license);
      }
    }

    final sortedKeys = packages.keys.toList()..sort();
    final sortedPackages = {for (var k in sortedKeys) k: packages[k]!};

    if (mounted) {
      setState(() {
        _licenses.addAll(sortedPackages);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.openSourceLicense,
          style: AppTextStyles.titleH1.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _licenses.keys.length,
              separatorBuilder: (context, index) => Divider(
                height: 1, 
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
              itemBuilder: (context, index) {
                final packageName = _licenses.keys.elementAt(index);
                final entries = _licenses[packageName]!;
                
                return _LicenseItem(
                  packageName: packageName,
                  entries: entries,
                );
              },
            ),
    );
  }
}

class _LicenseItem extends StatelessWidget {
  final String packageName;
  final List<LicenseEntry> entries;

  const _LicenseItem({
    required this.packageName,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _LicenseDetailScreen(
              packageName: packageName,
              entries: entries,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                packageName,
                style: AppTextStyles.bodyM.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _LicenseDetailScreen extends StatelessWidget {
  final String packageName;
  final List<LicenseEntry> entries;

  const _LicenseDetailScreen({
    required this.packageName,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          packageName,
          style: AppTextStyles.titleH1.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          final paragraphs = entry.paragraphs.map((p) => p.text).join('\n\n');
          return Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Text(
              paragraphs,
              style: AppTextStyles.bodyM.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          );
        },
      ),
    );
  }
}

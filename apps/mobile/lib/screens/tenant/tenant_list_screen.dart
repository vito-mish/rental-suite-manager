import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/tenant.dart';
import '../../services/tenant_service.dart';
import '../../widgets/tenant_card.dart';
import 'tenant_form_screen.dart';
import 'tenant_detail_screen.dart';

class TenantListScreen extends StatefulWidget {
  const TenantListScreen({super.key});

  @override
  State<TenantListScreen> createState() => TenantListScreenState();
}

class TenantListScreenState extends State<TenantListScreen> {
  void refresh() => _loadTenants();
  List<Tenant> _tenants = [];
  bool _loading = true;
  bool _initialized = false;
  String? _error;
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadTenants();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _loadTenants();
    });
  }

  Future<void> _loadTenants() async {
    if (!_initialized) {
      setState(() { _loading = true; _error = null; });
    }
    try {
      final search = _searchController.text.trim();
      final result = await TenantService.list(
        search: search.isNotEmpty ? search : null,
      );
      setState(() {
        _tenants = result.data;
        _loading = false;
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        if (!_initialized) _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _deleteTenant(Tenant tenant) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.confirmDeleteContent(tenant.name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await TenantService.delete(tenant.id);
      _loadTenants();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'tenant_fab',
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const TenantFormScreen()),
          );
          if (result == true) _loadTenants();
        },
        child: const Icon(Icons.person_add),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: l10n.searchTenantHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadTenants();
                        },
                      )
                    : null,
              ),
            ),
          ),
          // Tenant list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_error!, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 8),
                            TextButton(onPressed: _loadTenants, child: Text(l10n.retry)),
                          ],
                        ),
                      )
                    : _tenants.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                                const SizedBox(height: 16),
                                Text(l10n.noTenants, style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                                const SizedBox(height: 8),
                                Text(l10n.addTenantHint),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadTenants,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 80),
                              itemCount: _tenants.length,
                              itemBuilder: (context, index) {
                                final tenant = _tenants[index];
                                return TenantCard(
                                  tenant: tenant,
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TenantDetailScreen(tenantId: tenant.id),
                                      ),
                                    );
                                    _loadTenants();
                                  },
                                  onEdit: () async {
                                    final result = await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TenantFormScreen(tenant: tenant),
                                      ),
                                    );
                                    if (result == true) _loadTenants();
                                  },
                                  onDelete: () => _deleteTenant(tenant),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

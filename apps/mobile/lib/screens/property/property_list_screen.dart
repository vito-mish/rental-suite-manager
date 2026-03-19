import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';
import '../../widgets/property_card.dart';
import 'property_form_screen.dart';
import 'property_detail_screen.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => PropertyListScreenState();
}

class PropertyListScreenState extends State<PropertyListScreen> {
  void refresh() => _loadProperties();
  List<Property> _properties = [];
  bool _loading = true;
  bool _initialized = false;
  String? _error;
  PropertyStatus? _statusFilter;
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadProperties();
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
      _loadProperties();
    });
  }

  Future<void> _loadProperties() async {
    if (!_initialized) {
      setState(() { _loading = true; _error = null; });
    }
    try {
      final search = _searchController.text.trim();
      final result = await PropertyService.list(
        status: _statusFilter,
        search: search.isNotEmpty ? search : null,
      );
      setState(() {
        _properties = result.data;
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

  Future<void> _deleteProperty(Property property) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('確認刪除'),
        content: Text('確定要刪除「${property.name}」嗎？此操作無法復原。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('刪除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await PropertyService.delete(property.id);
      _loadProperties();
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'property_fab',
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const PropertyFormScreen()),
          );
          if (result == true) _loadProperties();
        },
        child: const Icon(Icons.add),
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
                hintText: '搜尋房號或租客姓名',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () { _searchController.clear(); _loadProperties(); },
                      )
                    : null,
              ),
            ),
          ),
          // Status filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterChip(
                  label: '全部',
                  selected: _statusFilter == null,
                  onSelected: () {
                    setState(() => _statusFilter = null);
                    _loadProperties();
                  },
                ),
                ...PropertyStatus.values.where((s) => s != PropertyStatus.archived).map((s) => _FilterChip(
                      label: s.label,
                      selected: _statusFilter == s,
                      onSelected: () {
                        setState(() => _statusFilter = s);
                        _loadProperties();
                      },
                    )),
              ],
            ),
          ),
          // Property list
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
                            TextButton(onPressed: _loadProperties, child: const Text('重試')),
                          ],
                        ),
                      )
                    : _properties.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.apartment, size: 64, color: Colors.grey[300]),
                                const SizedBox(height: 16),
                                Text('尚無房源', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                                const SizedBox(height: 8),
                                const Text('點擊右下角 + 新增房源'),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadProperties,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 80),
                              itemCount: _properties.length,
                              itemBuilder: (context, index) {
                                final property = _properties[index];
                                return PropertyCard(
                                  property: property,
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PropertyDetailScreen(propertyId: property.id),
                                      ),
                                    );
                                    _loadProperties();
                                  },
                                  onEdit: () async {
                                    final result = await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PropertyFormScreen(property: property),
                                      ),
                                    );
                                    if (result == true) _loadProperties();
                                  },
                                  onDelete: () => _deleteProperty(property),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}

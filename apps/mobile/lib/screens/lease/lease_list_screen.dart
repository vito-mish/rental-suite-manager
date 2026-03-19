import 'package:flutter/material.dart';
import '../../models/lease.dart';
import '../../services/lease_service.dart';

class LeaseListScreen extends StatefulWidget {
  const LeaseListScreen({super.key});

  @override
  State<LeaseListScreen> createState() => LeaseListScreenState();
}

class LeaseListScreenState extends State<LeaseListScreen> {
  void refresh() => _loadLeases();
  List<Lease> _leases = [];
  bool _loading = true;
  bool _initialized = false;
  String? _error;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    _loadLeases();
  }

  Future<void> _loadLeases() async {
    if (!_initialized) {
      setState(() { _loading = true; _error = null; });
    }
    try {
      final result = await LeaseService.list(status: _statusFilter);
      setState(() {
        _leases = result.data;
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

  Color _statusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return Colors.green;
      case 'EXPIRED':
        return Colors.orange;
      case 'TERMINATED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Status filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('全部', null),
                _buildFilterChip('進行中', 'ACTIVE'),
                _buildFilterChip('已到期', 'EXPIRED'),
                _buildFilterChip('已終止', 'TERMINATED'),
              ],
            ),
          ),
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
                            TextButton(onPressed: _loadLeases, child: const Text('重試')),
                          ],
                        ),
                      )
                    : _leases.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.description_outlined, size: 64, color: Colors.grey[300]),
                                const SizedBox(height: 16),
                                Text('尚無租約', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                                const SizedBox(height: 8),
                                const Text('請從租客詳情頁辦理入住'),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadLeases,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount: _leases.length,
                              itemBuilder: (context, index) {
                                final lease = _leases[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${lease.property.floor}F ${lease.property.roomNumber}',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: _statusColor(lease.status).withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                lease.statusLabel,
                                                style: TextStyle(
                                                  color: _statusColor(lease.status),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.person, size: 16, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(lease.tenant.name),
                                            const SizedBox(width: 16),
                                            const Icon(Icons.phone, size: 16, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(lease.tenant.phone),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${lease.startDate.toString().substring(0, 10)} ~ ${lease.endDate.toString().substring(0, 10)}',
                                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text('NT\$ ${lease.monthlyRent}/月'),
                                            if (lease.isActive) ...[
                                              const Spacer(),
                                              Text(
                                                '剩餘 ${lease.remainingDays} 天',
                                                style: TextStyle(
                                                  color: lease.remainingDays <= 30 ? Colors.orange : Colors.grey[600],
                                                  fontSize: 13,
                                                  fontWeight: lease.remainingDays <= 30 ? FontWeight.bold : FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? status) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _statusFilter == status,
        onSelected: (_) {
          setState(() => _statusFilter = status);
          _loadLeases();
        },
      ),
    );
  }
}

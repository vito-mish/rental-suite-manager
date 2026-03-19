import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/payment.dart';
import '../../services/payment_service.dart';

class PaymentListScreen extends StatefulWidget {
  const PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => PaymentListScreenState();
}

class PaymentListScreenState extends State<PaymentListScreen> {
  List<Payment> _payments = [];
  bool _loading = true;
  bool _initialized = false;
  String? _error;
  String? _statusFilter;
  String? _currentMonth;
  final _searchController = TextEditingController();
  Timer? _debounce;

  void refresh() => _loadPayments();

  @override
  void initState() {
    super.initState();
    _loadPayments();
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
      _loadPayments();
    });
  }

  Future<void> _loadPayments() async {
    if (!_initialized) {
      setState(() { _loading = true; _error = null; });
    }
    try {
      final search = _searchController.text.trim();
      final result = await PaymentService.list(
        status: _statusFilter,
        search: search.isNotEmpty ? search : null,
        month: _currentMonth,
      );

      setState(() {
        _payments = result.data;
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

  Future<void> _markPaid(Payment payment) async {
    final method = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text('${payment.lease.property.roomNumber} — 繳費方式'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'CASH'),
            child: const ListTile(leading: Icon(Icons.money), title: Text('現金')),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'TRANSFER'),
            child: const ListTile(leading: Icon(Icons.account_balance), title: Text('轉帳')),
          ),
        ],
      ),
    );
    if (method == null) return;

    try {
      await PaymentService.markPaid(payment.id, method: method);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已標記繳費'), backgroundColor: Colors.green),
        );
        _loadPayments();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  bool get _showMonthSelector => _statusFilter == 'PAID';

  void _changeMonth(int delta) {
    if (_currentMonth == null) return;
    final parts = _currentMonth!.split('-').map(int.parse).toList();
    final d = DateTime(parts[0], parts[1] + delta, 1);
    setState(() {
      _currentMonth = '${d.year}-${d.month.toString().padLeft(2, '0')}';
      _initialized = false;
    });
    _loadPayments();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PAID':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'OVERDUE':
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
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: '搜尋租客姓名或房號',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadPayments();
                        },
                      )
                    : null,
              ),
            ),
          ),
          // Month selector (only for PAID filter)
          if (_showMonthSelector)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _changeMonth(-1),
                  ),
                  Text(
                    _currentMonth ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              ),
            ),
          // Status filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('全部', null),
                _buildFilterChip('待繳', 'PENDING'),
                _buildFilterChip('已繳', 'PAID'),
                _buildFilterChip('逾期', 'OVERDUE'),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Payment list
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
                            TextButton(onPressed: _loadPayments, child: const Text('重試')),
                          ],
                        ),
                      )
                    : _payments.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[300]),
                                const SizedBox(height: 16),
                                Text('本月尚無帳單', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                                const SizedBox(height: 8),
                                const Text('帳單會在辦理入住時自動產生'),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadPayments,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 80),
                              itemCount: _payments.length,
                              itemBuilder: (context, index) {
                                final p = _payments[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  child: InkWell(
                                    onTap: p.status != 'PAID' ? () => _markPaid(p) : null,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${p.lease.property.floor}F ${p.lease.property.roomNumber}',
                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: _statusColor(p.status).withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  p.statusLabel,
                                                  style: TextStyle(
                                                    color: _statusColor(p.status),
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
                                              Text(p.lease.tenant.name),
                                              const Spacer(),
                                              Text(
                                                'NT\$ ${p.amount}',
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Text(
                                                '到期: ${p.dueDate.toString().substring(0, 10)}',
                                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                              ),
                                              if (p.status == 'PAID') ...[
                                                const Spacer(),
                                                Icon(Icons.check_circle, size: 16, color: Colors.green[400]),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${p.methodLabel} ${p.paidDate?.toString().substring(0, 10) ?? ''}',
                                                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                                ),
                                              ],
                                              if (p.status != 'PAID') ...[
                                                const Spacer(),
                                                Text(
                                                  '點擊標記繳費',
                                                  style: TextStyle(color: Colors.blue[400], fontSize: 12),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
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
          setState(() {
            _statusFilter = status;
            if (status == 'PAID') {
              final now = DateTime.now();
              _currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
            } else {
              _currentMonth = null;
            }
            _initialized = false;
          });
          _loadPayments();
        },
      ),
    );
  }
}

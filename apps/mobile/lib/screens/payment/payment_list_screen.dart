import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_helper.dart';
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

  Future<void> _showPayDialog(Payment payment) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _PayBottomSheet(payment: payment, l10n: l10n),
    );
    if (result == true && mounted) {
      _loadPayments();
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
    final l10n = AppLocalizations.of(context)!;

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
                hintText: l10n.searchPaymentHint,
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
                _buildFilterChip(l10n.all, null),
                _buildFilterChip(l10n.paymentPending, 'PENDING'),
                _buildFilterChip(l10n.paymentPaid, 'PAID'),
                _buildFilterChip(l10n.paymentOverdue, 'OVERDUE'),
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
                            TextButton(onPressed: _loadPayments, child: Text(l10n.retry)),
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
                                Text(l10n.noInvoices, style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                                const SizedBox(height: 8),
                                Text(l10n.autoInvoiceHint),
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
                                    onTap: p.status != 'PAID' ? () => _showPayDialog(p) : null,
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
                                                  localizePaymentStatus(l10n, p.status),
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
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'NT\$ ${p.amount - p.discount}',
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                  ),
                                                  if (p.discount > 0)
                                                    Text(
                                                      '-NT\$ ${p.discount}',
                                                      style: TextStyle(color: Colors.green[600], fontSize: 12),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Text(
                                                l10n.duePrefix(p.dueDate.toString().substring(0, 10)),
                                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                              ),
                                              if (p.status == 'PAID') ...[
                                                const Spacer(),
                                                Icon(Icons.check_circle, size: 16, color: Colors.green[400]),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${localizePaymentMethod(l10n, p.method)} ${p.paidDate?.toString().substring(0, 10) ?? ''}',
                                                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                                ),
                                              ],
                                              if (p.status != 'PAID') ...[
                                                const Spacer(),
                                                Text(
                                                  l10n.clickToMarkPaid,
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

class _PayBottomSheet extends StatefulWidget {
  final Payment payment;
  final AppLocalizations l10n;

  const _PayBottomSheet({required this.payment, required this.l10n});

  @override
  State<_PayBottomSheet> createState() => _PayBottomSheetState();
}

class _PayBottomSheetState extends State<_PayBottomSheet> {
  int _months = 1;
  final _discountController = TextEditingController(text: '0');
  String? _method;
  bool _loading = false;

  int get _monthlyRent => widget.payment.amount;
  int get _discount => int.tryParse(_discountController.text) ?? 0;
  int get _total => _monthlyRent * _months - _discount;

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_method == null) return;
    setState(() => _loading = true);

    try {
      if (_months == 1 && _discount == 0) {
        await PaymentService.markPaid(widget.payment.id, method: _method!);
      } else {
        await PaymentService.batchPay(
          leaseId: widget.payment.leaseId,
          months: _months,
          discount: _discount,
          method: _method!,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_months > 1
                ? widget.l10n.bulkPaySuccess(_months)
                : widget.l10n.markedAsPaid),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final p = widget.payment;

    return Padding(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${p.lease.property.floor}F ${p.lease.property.roomNumber} — ${p.lease.tenant.name}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Month selector
          Text(l10n.payMonths, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [1, 3, 6, 12].map((m) {
              return ChoiceChip(
                label: Text(l10n.monthsCount(m)),
                selected: _months == m,
                onSelected: (_) => setState(() => _months = m),
              );
            }).toList(),
          ),

          // Discount (only when months > 1)
          if (_months > 1) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _discountController,
              decoration: InputDecoration(
                labelText: l10n.discountAmount,
                border: const OutlineInputBorder(),
                prefixText: 'NT\$ ',
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
          ],

          const SizedBox(height: 16),
          // Summary
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.originalAmount),
                      Text('NT\$ ${_monthlyRent * _months}'),
                    ],
                  ),
                  if (_months > 1 && _discount > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.discountAmount),
                        Text('-NT\$ $_discount', style: TextStyle(color: Colors.green[600])),
                      ],
                    ),
                  ],
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.finalAmount, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('NT\$ $_total',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          // Payment method
          Row(
            children: [
              Expanded(
                child: _MethodButton(
                  icon: Icons.money,
                  label: l10n.methodCash,
                  selected: _method == 'CASH',
                  onTap: () => setState(() => _method = 'CASH'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MethodButton(
                  icon: Icons.account_balance,
                  label: l10n.methodTransfer,
                  selected: _method == 'TRANSFER',
                  onTap: () => setState(() => _method = 'TRANSFER'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          FilledButton(
            onPressed: _method != null && !_loading && _total > 0 ? _submit : null,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: _loading
                ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(_months > 1 ? l10n.bulkPay : l10n.markedAsPaid),
          ),
        ],
      ),
    );
  }
}

class _MethodButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MethodButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(
          color: selected ? Theme.of(context).colorScheme.primary : Colors.grey[300]!,
          width: selected ? 2 : 1,
        ),
        backgroundColor: selected
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
            : null,
      ),
    );
  }
}

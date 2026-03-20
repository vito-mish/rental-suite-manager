import 'dart:io';
import 'package:csv/csv.dart' show CsvEncoder;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_helper.dart';
import '../../models/payment.dart';
import '../../services/payment_service.dart';

class PaymentReportScreen extends StatefulWidget {
  const PaymentReportScreen({super.key});

  @override
  State<PaymentReportScreen> createState() => _PaymentReportScreenState();
}

class _PaymentReportScreenState extends State<PaymentReportScreen> {
  PaymentReport? _report;
  bool _loading = true;
  String? _error;
  late String _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() { _loading = true; _error = null; });
    try {
      final report = await PaymentService.report(month: _currentMonth);
      setState(() { _report = report; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _exportCsv() async {
    final l10n = AppLocalizations.of(context)!;
    if (_report == null || _report!.payments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportNoData)),
      );
      return;
    }

    final rows = <List<String>>[
      [l10n.floor, l10n.roomNumber, l10n.nameLabel, l10n.monthlyRent, l10n.discountAmount, l10n.finalAmount, l10n.statusLabel, l10n.paymentMethodLabel, l10n.paidDateLabel],
      ..._report!.payments.map((p) => [
        p.lease.property.floor.toString(),
        p.lease.property.roomNumber,
        p.lease.tenant.name,
        p.amount.toString(),
        p.discount.toString(),
        (p.amount - p.discount).toString(),
        localizePaymentStatus(l10n, p.status),
        localizePaymentMethod(l10n, p.method),
        p.paidDate?.toString().substring(0, 10) ?? '',
      ]),
    ];

    final csvContent = CsvEncoder(addBom: true).convert(rows);
    final fileName = 'payment_report_$_currentMonth.csv';

    final downloadsDir = '${Platform.environment['HOME']}/Downloads';
    final path = await FilePicker.platform.saveFile(
      dialogTitle: l10n.exportCsv,
      fileName: fileName,
      initialDirectory: downloadsDir,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (path == null) return;

    await File(path).writeAsString(csvContent);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportSuccess(path)), backgroundColor: Colors.green),
      );
    }
  }

  void _changeMonth(int delta) {
    final parts = _currentMonth.split('-').map(int.parse).toList();
    final d = DateTime(parts[0], parts[1] + delta, 1);
    setState(() {
      _currentMonth = '${d.year}-${d.month.toString().padLeft(2, '0')}';
    });
    _loadReport();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.monthlyReport),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: l10n.exportCsv,
            onPressed: _exportCsv,
          ),
        ],
      ),
      body: Column(
        children: [
          // Month selector
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => _changeMonth(-1)),
                Text(_currentMonth, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _changeMonth(1)),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Summary cards
                            Row(
                              children: [
                                _SummaryCard(label: l10n.expected, amount: _report!.summary.totalExpected, color: Colors.blue),
                                const SizedBox(width: 8),
                                _SummaryCard(label: l10n.received, amount: _report!.summary.totalPaid, color: Colors.green),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _SummaryCard(label: l10n.paymentPending, amount: _report!.summary.totalPending, color: Colors.orange),
                                const SizedBox(width: 8),
                                _SummaryCard(label: l10n.paymentOverdue, amount: _report!.summary.totalOverdue, color: Colors.red),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(l10n.roomDetails, style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: 8),
                            if (_report!.payments.isEmpty)
                              Center(child: Text(l10n.noInvoicesThisMonth, style: TextStyle(color: Colors.grey[500])))
                            else
                              ..._report!.payments.map((p) => Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: p.status == 'PAID'
                                            ? Colors.green.withValues(alpha: 0.1)
                                            : p.status == 'OVERDUE'
                                                ? Colors.red.withValues(alpha: 0.1)
                                                : Colors.orange.withValues(alpha: 0.1),
                                        child: Icon(
                                          p.status == 'PAID' ? Icons.check : p.status == 'OVERDUE' ? Icons.warning : Icons.schedule,
                                          color: p.status == 'PAID' ? Colors.green : p.status == 'OVERDUE' ? Colors.red : Colors.orange,
                                          size: 20,
                                        ),
                                      ),
                                      title: Text('${p.lease.property.floor}F ${p.lease.property.roomNumber}'),
                                      subtitle: Text(p.lease.tenant.name),
                                      trailing: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'NT\$ ${p.amount - p.discount}',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          if (p.discount > 0)
                                            Text(
                                              '-NT\$ ${p.discount}',
                                              style: TextStyle(color: Colors.green[600], fontSize: 12),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final int amount;
  final Color color;

  const _SummaryCard({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                'NT\$ $amount',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

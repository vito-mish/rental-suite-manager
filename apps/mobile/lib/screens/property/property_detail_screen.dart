import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_helper.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';
import 'property_form_screen.dart';

class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;

  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  PropertyDetail? _property;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final detail = await PropertyService.getDetail(widget.propertyId);
      setState(() {
        _property = detail;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Color _statusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.vacant:
        return Colors.green;
      case PropertyStatus.occupied:
        return Colors.blue;
      case PropertyStatus.maintenance:
        return Colors.orange;
    }
  }

  String _fmtDate(DateTime d) => '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  Widget _buildLeaseSection(ActiveLease lease) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(icon: Icons.person, label: l10n.tenant, value: lease.tenant.name),
                _InfoRow(icon: Icons.phone, label: l10n.phoneLabel, value: lease.tenant.phone),
                if (lease.tenant.email != null)
                  _InfoRow(icon: Icons.email, label: 'Email', value: lease.tenant.email!),
                _InfoRow(
                  icon: Icons.calendar_today,
                  label: l10n.leasePeriod,
                  value: '${_fmtDate(lease.startDate)} ~ ${_fmtDate(lease.endDate)}',
                ),
                _InfoRow(icon: Icons.attach_money, label: l10n.monthlyRentShort, value: 'NT\$ ${lease.monthlyRent}'),
                _InfoRow(
                  icon: Icons.timer,
                  label: l10n.validUntilLabel,
                  value: _fmtDate(lease.validUntil),
                ),
              ],
            ),
          ),
        ),
        // Validity warning
        if (lease.isExpired)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.validityExpiredWarning,
                  style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        // Payment history
        const SizedBox(height: 24),
        Text(l10n.paymentHistoryCount(lease.paidCount, lease.payments.length), style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        ...lease.payments.map((p) => Card(
              margin: const EdgeInsets.only(bottom: 4),
              child: ListTile(
                dense: true,
                leading: Icon(
                  p.status == 'PAID' ? Icons.check_circle : p.status == 'OVERDUE' ? Icons.error : Icons.schedule,
                  color: p.status == 'PAID' ? Colors.green : p.status == 'OVERDUE' ? Colors.red : Colors.orange,
                  size: 20,
                ),
                title: Text('NT\$ ${p.amount}'),
                subtitle: Text(l10n.dueDate(_fmtDate(p.dueDate))),
                trailing: Text(
                  p.status == 'PAID'
                      ? '${localizePaymentStatus(l10n, p.status)} ${_fmtDate(p.paidDate!)}'
                      : localizePaymentStatus(l10n, p.status),
                  style: TextStyle(
                    color: p.status == 'PAID' ? Colors.green : p.status == 'OVERDUE' ? Colors.red : Colors.orange,
                    fontSize: 12,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_property?.roomNumber ?? l10n.propertyDetail),
        actions: [
          if (_property != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PropertyFormScreen(property: _property!),
                  ),
                );
                if (result == true) _loadDetail();
              },
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                      TextButton(onPressed: _loadDetail, child: Text(l10n.retry)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _statusColor(_property!.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          localizePropertyStatus(l10n, _property!.status.value),
                          style: TextStyle(
                            color: _statusColor(_property!.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Info card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _InfoRow(icon: Icons.layers, label: l10n.floor, value: '${_property!.floor}F'),
                              _InfoRow(icon: Icons.meeting_room, label: l10n.roomNumber, value: _property!.roomNumber),
                              _InfoRow(icon: Icons.square_foot, label: l10n.area, value: l10n.areaWithUnit('${_property!.area}')),
                            ],
                          ),
                        ),
                      ),

                      // Facilities
                      if (_property!.facilities.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(l10n.facilities, style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _property!.facilities.map((f) => Chip(label: Text(localizeFacility(l10n, f)))).toList(),
                        ),
                      ],

                      // Rental status
                      const SizedBox(height: 24),
                      Text(l10n.leaseStatusTitle, style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      _property!.activeLeaseDetail != null
                          ? _buildLeaseSection(_property!.activeLeaseDetail!)
                          : Card(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.home_outlined, size: 48, color: Colors.grey[400]),
                                      const SizedBox(height: 8),
                                      Text(l10n.currentlyVacant, style: TextStyle(color: Colors.grey[500])),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          SizedBox(width: 60, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

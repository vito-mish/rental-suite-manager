import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_helper.dart';
import '../../models/tenant.dart';
import '../../services/tenant_service.dart';
import '../../services/lease_service.dart';
import 'tenant_form_screen.dart';
import 'move_in_screen.dart';

class TenantDetailScreen extends StatefulWidget {
  final String tenantId;

  const TenantDetailScreen({super.key, required this.tenantId});

  @override
  State<TenantDetailScreen> createState() => _TenantDetailScreenState();
}

class _TenantDetailScreenState extends State<TenantDetailScreen> {
  TenantDetail? _tenant;
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
      final detail = await TenantService.getDetail(widget.tenantId);
      setState(() {
        _tenant = detail;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Color _leaseStatusColor(String status) {
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

  /// Find the active lease if any
  LeaseHistory? get _activeLease {
    if (_tenant == null) return null;
    try {
      return _tenant!.leases.firstWhere((l) => l.status == 'ACTIVE');
    } catch (_) {
      return null;
    }
  }

  Widget _buildLeaseAction() {
    final l10n = AppLocalizations.of(context)!;
    final active = _activeLease;
    if (active != null) {
      final location = '${active.floor}F ${active.roomNumber}';
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _handleMoveOut(active),
          icon: const Icon(Icons.logout, color: Colors.red),
          label: Text(l10n.moveOutWithLocation(location),
              style: const TextStyle(color: Colors.red)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () async {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => MoveInScreen(
                  tenantId: widget.tenantId,
                  tenantName: _tenant!.name,
                ),
              ),
            );
            if (result == true) _loadDetail();
          },
          icon: const Icon(Icons.login),
          label: Text(l10n.moveIn),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      );
    }
  }

  Future<void> _handleMoveOut(LeaseHistory lease) async {
    final l10n = AppLocalizations.of(context)!;
    final location = '${lease.floor}F ${lease.roomNumber}';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmMoveOutTitle),
        content: Text(l10n.confirmMoveOutContent(_tenant!.name, location)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirmMoveOutTitle, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await LeaseService.moveOut(lease.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.moveOutSuccess), backgroundColor: Colors.green),
        );
        _loadDetail();
      }
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
      appBar: AppBar(
        title: Text(_tenant?.name ?? l10n.tenantDetail),
        actions: [
          if (_tenant != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TenantFormScreen(tenant: _tenant!),
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
              : RefreshIndicator(
                  onRefresh: _loadDetail,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Contact info card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _InfoRow(icon: Icons.person, label: l10n.nameLabel, value: _tenant!.name),
                                _InfoRow(icon: Icons.phone, label: l10n.mobileLabel, value: _tenant!.phone),
                                if (_tenant!.email != null && _tenant!.email!.isNotEmpty)
                                  _InfoRow(icon: Icons.email, label: 'Email', value: _tenant!.email!),
                                if (_tenant!.idNumber != null && _tenant!.idNumber!.isNotEmpty)
                                  _InfoRow(icon: Icons.badge, label: l10n.idCardLabel, value: _tenant!.idNumber!),
                                if (_tenant!.moveInDate != null)
                                  _InfoRow(
                                    icon: Icons.login,
                                    label: l10n.moveInDateLabel,
                                    value: _tenant!.moveInDate!.toString().substring(0, 10),
                                  ),
                                if (_tenant!.moveOutDate != null)
                                  _InfoRow(
                                    icon: Icons.logout,
                                    label: l10n.moveOutDateLabel,
                                    value: _tenant!.moveOutDate!.toString().substring(0, 10),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Move-in / Move-out action (T-22)
                        const SizedBox(height: 16),
                        _buildLeaseAction(),

                        // Lease history (T-24)
                        const SizedBox(height: 24),
                        Text(l10n.leaseHistory, style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        if (_tenant!.leases.isEmpty)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.description_outlined, size: 48, color: Colors.grey[400]),
                                    const SizedBox(height: 8),
                                    Text(l10n.noLeaseHistory, style: TextStyle(color: Colors.grey[500])),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          ...(_tenant!.leases.map((lease) => Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${lease.floor}F ${lease.roomNumber}',
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: _leaseStatusColor(lease.status).withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              localizeLeaseStatus(l10n, lease.status),
                                              style: TextStyle(
                                                color: _leaseStatusColor(lease.status),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      _InfoRow(
                                        icon: Icons.calendar_today,
                                        label: l10n.leasePeriod,
                                        value:
                                            '${lease.startDate.toString().substring(0, 10)} ~ ${lease.endDate.toString().substring(0, 10)}',
                                      ),
                                      _InfoRow(
                                        icon: Icons.attach_money,
                                        label: l10n.monthlyRentShort,
                                        value: 'NT\$ ${lease.monthlyRent}',
                                      ),
                                      _InfoRow(
                                        icon: Icons.account_balance_wallet,
                                        label: l10n.deposit,
                                        value: 'NT\$ ${lease.deposit}',
                                      ),
                                    ],
                                  ),
                                ),
                              ))),

                        // Documents (T-23)
                        const SizedBox(height: 24),
                        Text(l10n.documents, style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        if (_tenant!.documents.isEmpty)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.folder_open, size: 48, color: Colors.grey[400]),
                                    const SizedBox(height: 8),
                                    Text(l10n.noDocuments, style: TextStyle(color: Colors.grey[500])),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          ...(_tenant!.documents.map((doc) => Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: const Icon(Icons.insert_drive_file),
                                  title: Text(doc.name),
                                  subtitle: Text(localizeDocType(l10n, doc.type)),
                                  trailing: Text(
                                    doc.createdAt.toString().substring(0, 10),
                                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                  ),
                                ),
                              ))),
                      ],
                    ),
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

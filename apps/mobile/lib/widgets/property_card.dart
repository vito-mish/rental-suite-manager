import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n_helper.dart';
import '../models/property.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  Color _statusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.vacant:
        return Colors.green;
      case PropertyStatus.occupied:
        return Colors.blue;
      case PropertyStatus.maintenance:
        return Colors.orange;
      case PropertyStatus.archived:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime d) => '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lease = property.activeLease;
    final isExpired = lease?.isExpired ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
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
                      property.roomNumber,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(property.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      localizePropertyStatus(l10n, property.status.value),
                      style: TextStyle(
                        color: _statusColor(property.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                          case 'delete':
                            onDelete?.call();
                        }
                      },
                      itemBuilder: (_) => [
                        if (onEdit != null)
                          PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                        if (onDelete != null)
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                          ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.layers, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${property.floor}F'),
                  const SizedBox(width: 16),
                  const Icon(Icons.square_foot, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(l10n.areaWithUnit('${property.area}')),
                  const SizedBox(width: 16),
                  const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(l10n.rentPerMonth(property.monthlyRent)),
                ],
              ),
              // Active lease info with validity
              if (lease != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(lease.tenant.name),
                    const SizedBox(width: 12),
                    const Icon(Icons.receipt, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(l10n.periodCount(lease.paidCount, lease.totalPayments)),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isExpired ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isExpired ? Icons.error_outline : Icons.check_circle_outline,
                        size: 16,
                        color: isExpired ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isExpired
                            ? l10n.overdueValidUntil(_formatDate(lease.validUntil))
                            : l10n.validUntilDate(_formatDate(lease.validUntil)),
                        style: TextStyle(
                          color: isExpired ? Colors.red : Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

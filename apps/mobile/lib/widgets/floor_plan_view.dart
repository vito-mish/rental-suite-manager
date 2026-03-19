import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/property.dart';

class FloorPlanView extends StatelessWidget {
  final List<Property> properties;
  final void Function(Property property) onPropertyTap;

  const FloorPlanView({
    super.key,
    required this.properties,
    required this.onPropertyTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Group by floor, sorted high to low
    final Map<int, List<Property>> byFloor = {};
    for (final p in properties) {
      byFloor.putIfAbsent(p.floor, () => []).add(p);
    }
    final floors = byFloor.keys.toList()..sort((a, b) => b.compareTo(a));

    if (floors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apartment, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(l10n.noProperties,
                style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80, top: 8),
      itemCount: floors.length,
      itemBuilder: (context, index) {
        final floor = floors[index];
        final rooms = byFloor[floor]!
          ..sort((a, b) => a.roomNumber.compareTo(b.roomNumber));
        return _FloorSection(
          floor: floor,
          floorLabel: l10n.floorLabel(floor),
          rooms: rooms,
          onPropertyTap: onPropertyTap,
        );
      },
    );
  }
}

class _FloorSection extends StatelessWidget {
  final int floor;
  final String floorLabel;
  final List<Property> rooms;
  final void Function(Property property) onPropertyTap;

  const _FloorSection({
    required this.floor,
    required this.floorLabel,
    required this.rooms,
    required this.onPropertyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 8),
            child: Text(
              floorLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: rooms
                .map((p) => _RoomTile(
                      property: p,
                      onTap: () => onPropertyTap(p),
                    ))
                .toList(),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;

  const _RoomTile({required this.property, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors(property.status);
    final isOverdue = property.status == PropertyStatus.occupied &&
        property.activeLease != null &&
        property.activeLease!.isExpired;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 70,
        decoration: BoxDecoration(
          color: colors.bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isOverdue ? Colors.red : colors.bg,
            width: isOverdue ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              property.roomNumber,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colors.text,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (property.activeLease != null) ...[
              const SizedBox(height: 2),
              Text(
                property.activeLease!.tenant.name,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusColors {
  final Color bg;
  final Color text;
  const _StatusColors(this.bg, this.text);
}

_StatusColors _statusColors(PropertyStatus status) {
  switch (status) {
    case PropertyStatus.vacant:
      return _StatusColors(
          Colors.green.withValues(alpha: 0.15), Colors.green[800]!);
    case PropertyStatus.occupied:
      return _StatusColors(
          Colors.blue.withValues(alpha: 0.15), Colors.blue[800]!);
    case PropertyStatus.maintenance:
      return _StatusColors(
          Colors.orange.withValues(alpha: 0.15), Colors.orange[800]!);
  }
}

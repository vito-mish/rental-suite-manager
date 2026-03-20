import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_helper.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';

class PropertyFormScreen extends StatefulWidget {
  final Property? property;

  const PropertyFormScreen({super.key, this.property});

  bool get isEditing => property != null;

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _floorController;
  late final TextEditingController _roomNumberController;
  late final TextEditingController _areaController;
  late final TextEditingController _rentController;
  bool _loading = false;

  late Set<String> _selectedFacilities;

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    _floorController = TextEditingController(text: p?.floor.toString() ?? '');
    _roomNumberController = TextEditingController(text: p?.roomNumber ?? '');
    _areaController = TextEditingController(text: p?.area.toString() ?? '');
    _rentController = TextEditingController(text: p != null && p.monthlyRent > 0 ? p.monthlyRent.toString() : '');
    _selectedFacilities = widget.isEditing
        ? Set.from(p?.facilities ?? [])
        : Set.from(defaultFacilities);
  }

  @override
  void dispose() {
    _floorController.dispose();
    _roomNumberController.dispose();
    _areaController.dispose();
    _rentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      if (widget.isEditing) {
        final roomNumber = _roomNumberController.text.trim();
        await PropertyService.update(widget.property!.id, {
          'name': roomNumber,
          'floor': int.parse(_floorController.text),
          'roomNumber': roomNumber,
          'area': double.parse(_areaController.text),
          'monthlyRent': _rentController.text.isNotEmpty ? int.parse(_rentController.text) : 0,
          'facilities': _selectedFacilities.toList(),
        });
      } else {
        final roomNumber = _roomNumberController.text.trim();
        await PropertyService.create(
          name: roomNumber,
          floor: int.parse(_floorController.text),
          roomNumber: roomNumber,
          area: double.parse(_areaController.text),
          monthlyRent: _rentController.text.isNotEmpty ? int.parse(_rentController.text) : 0,
          facilities: _selectedFacilities.toList(),
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? l10n.editProperty : l10n.addProperty),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _floorController,
                        decoration: InputDecoration(
                          labelText: l10n.floor,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.enterFloor;
                          if (int.tryParse(v) == null) return l10n.enterInteger;
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _roomNumberController,
                        decoration: InputDecoration(
                          labelText: l10n.roomNumber,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? l10n.enterRoomNumber : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _areaController,
                  decoration: InputDecoration(
                    labelText: l10n.area,
                    border: const OutlineInputBorder(),
                    suffixText: l10n.areaSuffix,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  validator: (v) {
                    if (v == null || v.isEmpty) return l10n.enterArea;
                    final n = double.tryParse(v);
                    if (n == null || n <= 0) return l10n.enterValidNumber;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _rentController,
                  decoration: InputDecoration(
                    labelText: l10n.monthlyRent,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.attach_money),
                    suffixText: l10n.currencySuffix,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return l10n.enterMonthlyRent;
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return l10n.enterValidAmount;
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text(l10n.facilities, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: facilityDbKeys.map((dbKey) {
                    final selected = _selectedFacilities.contains(dbKey);
                    return FilterChip(
                      label: Text(localizeFacility(l10n, dbKey)),
                      selected: selected,
                      onSelected: (v) {
                        setState(() {
                          if (v) {
                            _selectedFacilities.add(dbKey);
                          } else {
                            _selectedFacilities.remove(dbKey);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _loading ? null : _save,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(widget.isEditing ? l10n.save : l10n.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

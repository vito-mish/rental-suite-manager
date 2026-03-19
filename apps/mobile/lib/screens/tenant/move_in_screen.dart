import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';
import '../../services/lease_service.dart';

class MoveInScreen extends StatefulWidget {
  final String tenantId;
  final String tenantName;

  const MoveInScreen({
    super.key,
    required this.tenantId,
    required this.tenantName,
  });

  @override
  State<MoveInScreen> createState() => _MoveInScreenState();
}

class _MoveInScreenState extends State<MoveInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rentController = TextEditingController();
  final _termsController = TextEditingController();

  List<Property> _vacantProperties = [];
  Property? _selectedProperty;
  DateTime _startDate = DateTime.now();
  int _leaseMonths = 12;
  bool _loadingProperties = true;
  bool _saving = false;

  static const _leaseOptions = [6, 12, 24, 36];

  DateTime get _endDate => DateTime(_startDate.year, _startDate.month + _leaseMonths, _startDate.day);

  @override
  void initState() {
    super.initState();
    _rentController.addListener(() => setState(() {}));
    _loadVacantProperties();
  }

  @override
  void dispose() {
    _rentController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  Future<void> _loadVacantProperties() async {
    try {
      final result = await PropertyService.list(status: PropertyStatus.vacant, limit: 100);
      setState(() {
        _vacantProperties = result.data;
        _loadingProperties = false;
      });
    } catch (e) {
      setState(() => _loadingProperties = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.loadPropertyFailed(e.toString())), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProperty == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectProperty), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await LeaseService.moveIn(
        tenantId: widget.tenantId,
        propertyId: _selectedProperty!.id,
        startDate: _startDate.toUtc().toIso8601String(),
        endDate: _endDate.toUtc().toIso8601String(),
        monthlyRent: int.parse(_rentController.text),
        deposit: int.parse(_rentController.text) * 2,
        terms: _termsController.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _formatDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _leaseLabel(AppLocalizations l10n, int months) {
    final base = l10n.leaseMonths(months);
    if (months == 12) return '$base${l10n.oneYear}';
    if (months == 24) return '$base${l10n.twoYears}';
    if (months == 36) return '$base${l10n.threeYears}';
    return base;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moveInTitle(widget.tenantName))),
      body: _loadingProperties
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Property picker
                      Text(l10n.selectPropertyLabel, style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      if (_vacantProperties.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Text(l10n.noVacantUnits, style: TextStyle(color: Colors.grey[500])),
                            ),
                          ),
                        )
                      else
                        DropdownButtonFormField<Property>(
                          initialValue: _selectedProperty,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: l10n.selectVacantUnit,
                            prefixIcon: const Icon(Icons.apartment),
                          ),
                          items: _vacantProperties.map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(l10n.propertyDropdownItem(p.floor, p.roomNumber, '${p.area}')),
                          )).toList(),
                          onChanged: (v) {
                            setState(() => _selectedProperty = v);
                            if (v != null && v.monthlyRent > 0) {
                              _rentController.text = v.monthlyRent.toString();
                            }
                          },
                          validator: (v) => v == null ? l10n.selectProperty : null,
                        ),

                      const SizedBox(height: 24),
                      Text(l10n.leaseInfo, style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),

                      // Start date
                      InkWell(
                        onTap: _pickStartDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: l10n.startDate,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          child: Text(_formatDate(_startDate)),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Lease duration
                      DropdownButtonFormField<int>(
                        initialValue: _leaseMonths,
                        decoration: InputDecoration(
                          labelText: l10n.leaseDuration,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.timer),
                        ),
                        items: _leaseOptions.map((m) => DropdownMenuItem(
                          value: m,
                          child: Text(_leaseLabel(l10n, m)),
                        )).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _leaseMonths = v);
                        },
                      ),

                      const SizedBox(height: 16),

                      // End date (computed, read-only)
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.endDateAuto,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.event),
                        ),
                        child: Text(_formatDate(_endDate)),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
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
                                if (int.tryParse(v) == null) return l10n.enterInteger;
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: l10n.depositRentMultiple,
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.account_balance_wallet),
                                suffixText: l10n.currencySuffix,
                              ),
                              child: Text(
                                _rentController.text.isNotEmpty
                                    ? '${(int.tryParse(_rentController.text) ?? 0) * 2}'
                                    : '0',
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _termsController,
                        decoration: InputDecoration(
                          labelText: l10n.specialTerms,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.description),
                        ),
                        maxLines: 3,
                      ),

                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: _saving ? null : _submit,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(l10n.confirmMoveIn),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

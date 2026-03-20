import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../models/tenant.dart';
import '../../services/tenant_service.dart';

class TenantFormScreen extends StatefulWidget {
  final Tenant? tenant;

  const TenantFormScreen({super.key, this.tenant});

  bool get isEditing => tenant != null;

  @override
  State<TenantFormScreen> createState() => _TenantFormScreenState();
}

class _TenantFormScreenState extends State<TenantFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _idNumberController;
  late final TextEditingController _lineIdController;
  bool _loading = false;

  final List<_EmergencyContactEntry> _emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    final t = widget.tenant;
    _nameController = TextEditingController(text: t?.name ?? '');
    _phoneController = TextEditingController(text: _formatPhone(t?.phone ?? ''));
    _emailController = TextEditingController(text: t?.email ?? '');
    _idNumberController = TextEditingController(text: t?.idNumber ?? '');
    _lineIdController = TextEditingController(text: t?.lineId ?? '');

    if (widget.isEditing) {
      _loadExistingContacts();
    }
  }

  Future<void> _loadExistingContacts() async {
    try {
      final detail = await TenantService.getDetail(widget.tenant!.id);
      if (mounted) {
        setState(() {
          for (final c in detail.emergencyContacts) {
            _emergencyContacts.add(_EmergencyContactEntry(
              nameController: TextEditingController(text: c.name),
              phoneController: TextEditingController(text: _formatPhone(c.phone)),
              isCoResident: c.isCoResident,
            ));
          }
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _idNumberController.dispose();
    _lineIdController.dispose();
    for (final c in _emergencyContacts) {
      c.nameController.dispose();
      c.phoneController.dispose();
    }
    super.dispose();
  }

  static String _formatPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 10) return phone;
    return '${digits.substring(0, 4)}-${digits.substring(4, 7)}-${digits.substring(7)}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final contacts = _emergencyContacts
          .where((c) => c.nameController.text.trim().isNotEmpty)
          .map((c) => EmergencyContact(
                name: c.nameController.text.trim(),
                phone: c.phoneController.text.trim(),
                isCoResident: c.isCoResident,
              ))
          .toList();

      if (widget.isEditing) {
        await TenantService.update(widget.tenant!.id, {
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'idNumber': _idNumberController.text.trim(),
          'lineId': _lineIdController.text.trim(),
          'emergencyContacts': contacts.map((c) => c.toJson()).toList(),
        });
      } else {
        await TenantService.create(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          idNumber: _idNumberController.text.trim(),
          lineId: _lineIdController.text.trim(),
          emergencyContacts: contacts,
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
        title: Text(widget.isEditing ? l10n.editTenant : l10n.addTenant),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.nameLabel,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? l10n.enterName : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: l10n.phoneNumber,
                    hintText: '0933-221-389',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_PhoneFormatter()],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l10n.enterPhone;
                    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
                    if (digits.length != 10) return l10n.phoneDigits;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: l10n.emailOptional,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _idNumberController,
                  decoration: InputDecoration(
                    labelText: l10n.idNumberOptional,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.badge),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _lineIdController,
                        decoration: InputDecoration(
                          labelText: l10n.lineIdOptional,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.chat),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: TextButton(
                        onPressed: () {
                          final phone = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
                          if (phone.isNotEmpty) {
                            _lineIdController.text = phone;
                          }
                        },
                        child: Text(l10n.lineIdSameAsPhone),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(l10n.emergencyContacts, style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _emergencyContacts.add(_EmergencyContactEntry(
                            nameController: TextEditingController(),
                            phoneController: TextEditingController(),
                          ));
                        });
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.addEmergencyContact),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._emergencyContacts.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final contact = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: contact.nameController,
                                    decoration: InputDecoration(
                                      labelText: l10n.contactName,
                                      border: const OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    controller: contact.phoneController,
                                    decoration: InputDecoration(
                                      labelText: l10n.contactPhone,
                                      border: const OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [_PhoneFormatter()],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      contact.nameController.dispose();
                                      contact.phoneController.dispose();
                                      _emergencyContacts.removeAt(idx);
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Checkbox(
                                  value: contact.isCoResident,
                                  onChanged: (v) {
                                    setState(() => contact.isCoResident = v ?? false);
                                  },
                                ),
                                Text(l10n.isCoResident),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
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

class _EmergencyContactEntry {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  bool isCoResident;

  _EmergencyContactEntry({
    required this.nameController,
    required this.phoneController,
    this.isCoResident = false,
  });
}

/// Auto-formats phone input: 0933221389 -> 0933-221-389
class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 10) {
      return oldValue;
    }

    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 4 || i == 7) buf.write('-');
      buf.write(digits[i]);
    }

    final formatted = buf.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

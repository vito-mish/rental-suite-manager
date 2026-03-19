import 'package:flutter/material.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('載入房源失敗: $e'), backgroundColor: Colors.red),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請選擇房源'), backgroundColor: Colors.red),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.tenantName} — 入住')),
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
                      Text('選擇房源', style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      if (_vacantProperties.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Text('目前沒有空房', style: TextStyle(color: Colors.grey[500])),
                            ),
                          ),
                        )
                      else
                        DropdownButtonFormField<Property>(
                          initialValue: _selectedProperty,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '選擇空房',
                            prefixIcon: Icon(Icons.apartment),
                          ),
                          items: _vacantProperties.map((p) => DropdownMenuItem(
                            value: p,
                            child: Text('${p.floor}F ${p.roomNumber}（${p.area} 坪）'),
                          )).toList(),
                          onChanged: (v) {
                            setState(() => _selectedProperty = v);
                            if (v != null && v.monthlyRent > 0) {
                              _rentController.text = v.monthlyRent.toString();
                            }
                          },
                          validator: (v) => v == null ? '請選擇房源' : null,
                        ),

                      const SizedBox(height: 24),
                      Text('租約資訊', style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),

                      // Start date
                      InkWell(
                        onTap: _pickStartDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: '起租日',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(_formatDate(_startDate)),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Lease duration
                      DropdownButtonFormField<int>(
                        initialValue: _leaseMonths,
                        decoration: const InputDecoration(
                          labelText: '租約長度',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.timer),
                        ),
                        items: _leaseOptions.map((m) => DropdownMenuItem(
                          value: m,
                          child: Text('$m 個月${m == 12 ? '（一年）' : m == 24 ? '（二年）' : m == 36 ? '（三年）' : ''}'),
                        )).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _leaseMonths = v);
                        },
                      ),

                      const SizedBox(height: 16),

                      // End date (computed, read-only)
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '到期日（自動計算）',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.event),
                        ),
                        child: Text(_formatDate(_endDate)),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _rentController,
                              decoration: const InputDecoration(
                                labelText: '月租金',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.attach_money),
                                suffixText: '元',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.isEmpty) return '請輸入月租金';
                                if (int.tryParse(v) == null) return '請輸入整數';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: '押金（月租 x 2）',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.account_balance_wallet),
                                suffixText: '元',
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
                        decoration: const InputDecoration(
                          labelText: '特殊條款（選填）',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
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
                            : const Text('確認入住'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

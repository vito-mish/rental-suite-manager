import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static const _allFacilities = [
    'WiFi', '冷氣', '冰箱', '洗衣機', '熱水器', '電視', '衣櫃', '書桌', '床',
  ];
  late Set<String> _selectedFacilities;

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    _floorController = TextEditingController(text: p?.floor.toString() ?? '');
    _roomNumberController = TextEditingController(text: p?.roomNumber ?? '');
    _areaController = TextEditingController(text: p?.area.toString() ?? '');
    _rentController = TextEditingController(text: p != null && p.monthlyRent > 0 ? p.monthlyRent.toString() : '');
    _selectedFacilities = Set.from(p?.facilities ?? []);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? '編輯房源' : '新增房源'),
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
                        decoration: const InputDecoration(
                          labelText: '樓層',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return '請輸入樓層';
                          if (int.tryParse(v) == null) return '請輸入整數';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _roomNumberController,
                        decoration: const InputDecoration(
                          labelText: '房號',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? '請輸入房號' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _areaController,
                  decoration: const InputDecoration(
                    labelText: '坪數',
                    border: OutlineInputBorder(),
                    suffixText: '坪',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  validator: (v) {
                    if (v == null || v.isEmpty) return '請輸入坪數';
                    final n = double.tryParse(v);
                    if (n == null || n <= 0) return '請輸入有效數字';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
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
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return '請輸入有效金額';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text('設施', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _allFacilities.map((f) {
                    final selected = _selectedFacilities.contains(f);
                    return FilterChip(
                      label: Text(f),
                      selected: selected,
                      onSelected: (v) {
                        setState(() {
                          if (v) {
                            _selectedFacilities.add(f);
                          } else {
                            _selectedFacilities.remove(f);
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
                      : Text(widget.isEditing ? '儲存' : '新增'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

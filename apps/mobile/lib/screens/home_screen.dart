import 'package:flutter/material.dart';
import '../main.dart';
import 'property/property_list_screen.dart';
import 'tenant/tenant_list_screen.dart';
import 'lease/lease_list_screen.dart';
import 'payment/payment_list_screen.dart';
import 'payment/payment_report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _propertyKey = GlobalKey<PropertyListScreenState>();
  final _tenantKey = GlobalKey<TenantListScreenState>();
  final _leaseKey = GlobalKey<LeaseListScreenState>();
  final _paymentKey = GlobalKey<PaymentListScreenState>();

  late final List<Widget> _screens;

  static const _titles = ['房源管理', '租客管理', '租約管理', '收租管理'];

  @override
  void initState() {
    super.initState();
    _screens = [
      PropertyListScreen(key: _propertyKey),
      TenantListScreen(key: _tenantKey),
      LeaseListScreen(key: _leaseKey),
      PaymentListScreen(key: _paymentKey),
    ];
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        _propertyKey.currentState?.refresh();
      case 1:
        _tenantKey.currentState?.refresh();
      case 2:
        _leaseKey.currentState?.refresh();
      case 3:
        _paymentKey.currentState?.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          if (_currentIndex == 3)
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentReportScreen()),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabChanged,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.apartment_outlined),
            selectedIcon: Icon(Icons.apartment),
            label: '房源',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people),
            label: '租客',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description),
            label: '租約',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments),
            label: '收租',
          ),
        ],
      ),
    );
  }
}

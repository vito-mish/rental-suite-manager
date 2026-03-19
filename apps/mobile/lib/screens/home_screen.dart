import 'package:flutter/material.dart';
import '../main.dart';
import 'property/property_list_screen.dart';
import 'tenant/tenant_list_screen.dart';
import 'lease/lease_list_screen.dart';

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

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      PropertyListScreen(key: _propertyKey),
      TenantListScreen(key: _tenantKey),
      LeaseListScreen(key: _leaseKey),
    ];
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
    // Refresh the target tab
    switch (index) {
      case 0:
        _propertyKey.currentState?.refresh();
      case 1:
        _tenantKey.currentState?.refresh();
      case 2:
        _leaseKey.currentState?.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(['房源管理', '租客管理', '租約管理'][_currentIndex]),
        actions: [
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
        ],
      ),
    );
  }
}

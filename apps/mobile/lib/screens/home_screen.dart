import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
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

  List<String> _titles(AppLocalizations l10n) => [
        l10n.titlePropertyManagement,
        l10n.titleTenantManagement,
        l10n.titleLeaseManagement,
        l10n.titlePaymentManagement,
      ];

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles(l10n)[_currentIndex]),
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
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              MyApp.of(context)?.toggleLocale();
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
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.apartment_outlined),
            selectedIcon: const Icon(Icons.apartment),
            label: l10n.tabProperties,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outlined),
            selectedIcon: const Icon(Icons.people),
            label: l10n.tabTenants,
          ),
          NavigationDestination(
            icon: const Icon(Icons.description_outlined),
            selectedIcon: const Icon(Icons.description),
            label: l10n.tabLeases,
          ),
          NavigationDestination(
            icon: const Icon(Icons.payments_outlined),
            selectedIcon: const Icon(Icons.payments),
            label: l10n.tabPayments,
          ),
        ],
      ),
    );
  }
}

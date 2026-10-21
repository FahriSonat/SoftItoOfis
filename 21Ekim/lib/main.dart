import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'providers/finance_provider.dart';
import 'screens/home/home_dashboard_screen.dart';
import 'screens/transactions/transactions_list_screen.dart';
import 'screens/budget/budget_screen.dart';
import 'screens/debts_bills/debts_bills_screen.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/simulation/simulation_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const PersonalFinanceApp());
}

class PersonalFinanceApp extends StatelessWidget {
  final FinanceProvider? provider;
  const PersonalFinanceApp({super.key, this.provider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => provider ?? (FinanceProvider()..init()),
      child: MaterialApp(
        title: 'Para Takip',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainNavigationShell(),
      ),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeDashboardScreen(onNavigateTab: _navigateToTab),
      const TransactionsListScreen(),
      const BudgetScreen(),
      const DebtsBillsScreen(),
      const ReportsScreen(),
    ];

    return Scaffold(
      drawer: _buildDrawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateToTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Özet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'İşlemler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Bütçe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Borç/Fatura',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Raporlar',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.surfaceRaised,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.wallet, color: AppColors.indicatorBlue, size: 36),
                SizedBox(height: 8),
                Text(
                  'Kişisel Para Takip',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Bütçe, Gelir-Gider ve Borç Yönetimi',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: AppColors.indicatorBlue),
            title: const Text('Bütçe Özeti'),
            selected: _currentIndex == 0,
            onTap: () {
              Navigator.pop(context);
              _navigateToTab(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long, color: AppColors.indicatorBlue),
            title: const Text('İşlem Detayları & Geçmiş'),
            selected: _currentIndex == 1,
            onTap: () {
              Navigator.pop(context);
              _navigateToTab(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart, color: AppColors.indicatorBlue),
            title: const Text('Zarf / Kategori Bütçeleri'),
            selected: _currentIndex == 2,
            onTap: () {
              Navigator.pop(context);
              _navigateToTab(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet, color: AppColors.indicatorBlue),
            title: const Text('Borçlar ve Faturalar'),
            selected: _currentIndex == 3,
            onTap: () {
              Navigator.pop(context);
              _navigateToTab(3);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart, color: AppColors.indicatorBlue),
            title: const Text('Harcama Raporları & Excel'),
            selected: _currentIndex == 4,
            onTap: () {
              Navigator.pop(context);
              _navigateToTab(4);
            },
          ),
          const Divider(color: AppColors.border),
          ListTile(
            leading: const Icon(Icons.auto_graph_rounded, color: AppColors.warningBackground),
            title: const Text('Gelecek Ay Simülasyonu'),
            subtitle: const Text('Dönem projeksiyonu ve varlık senaryoları', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SimulationScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
            title: const Text('Ayarlar ve Tercihler'),
            subtitle: const Text('Maaş günü, limitler ve bildirimler', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

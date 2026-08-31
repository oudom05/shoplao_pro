import 'package:flutter/material.dart';
import 'views/dashboard_view.dart'; 
import 'views/inventory_view.dart';
import 'views/order_view.dart';
import 'views/all_orders_view.dart';
import 'views/analytics_view.dart';
import 'views/store_setting.dart';
void main() {
  runApp(const SalesManagementApp());
}

class SalesManagementApp extends StatelessWidget {
  const SalesManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ຄຸ້ມຄອງການຂາຍ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Saysettha OT', // ຕັ້ງຄ່າຟອນພາສາລາວ (ຖ້າເພີ່ມ font ໄວ້ໃນ pubspec.yaml)
      ),
      // ກຳນົດໃຫ້ໜ້າແລກທີ່ເປີດຂຶ້ນມາແມ່ນ DashboardView
      home: const MainNavigationView(),
    );
  }
}

// ==========================================
// Widget ສຳລັບຈັດການ Bottom Navigation Bar 
// ==========================================
class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 2; // ຕັ້ງຄ່າໃຫ້ເລີ່ມຕົ້ນຢູ່ທີ່ແທັບ ແດັດບອດ (Index 2)

  // ລາຍຊື່ໜ້າຈໍທັງໝົດໃນແອັບ (ຕອນນີ້ເຮົາມີ DashboardView ແລ້ວ)
  final List<Widget> _screens = [
    const InventoryView(),
    const OrderView(), // ໜ້າຈັດການອໍເດີ້ (OrderView)
    const DashboardView(), // ໜ້າແດັດບອດທີ່ເຮົາเพิ่งສ້າງ
    const AnalyticsView(),
    const StoreSettingView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ສະແດງໜ້າຈໍຕາມ Index ທີ່ຖືກເລືອກ
      body: _screens[_currentIndex],
      
      // ແຖບເມນູດ້ານລຸ່ມ (Bottom Navigation Bar) 5 ປຸ່ມ
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6366F1), // ສີຂອງປຸ່ມທີ່ຖືກເລືອກ (ສີມ່ວງ)
        unselectedItemColor: Colors.grey,          // ສີຂອງປຸ່ມປົກກະຕິ
        onTap: (index) {
          setState(() {
            _currentIndex = index; // ປ່ຽນ Index ເມື່ອກົດປຸ່ມເມນູ
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'ຄັງສິນຄ້າ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'ອໍເດີ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'ແດັດບອດ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'ວິເຄາະ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'ຕັ້ງຄ່າ',
          ),
        ],
      ),
    );
  }
}
// Dashboard Controller - Manages dashboard state and logic
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../services/data_service.dart';

class DashboardController extends ChangeNotifier {
  final DataService _dataService = DataService();

  int get totalOrders => _dataService.getTotalOrders();
  int get totalProducts => _dataService.getTotalProducts();
  double get totalRevenue => _dataService.getTotalRevenue();
  
  List<Order> get recentOrders => _dataService.orders.take(5).toList();
  List<Product> get lowStockProducts => 
    _dataService.products.where((p) => p.stockQuantity < 10).toList();

  void refreshData() {
    notifyListeners();
  }
}

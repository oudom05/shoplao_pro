// Data Service - Handles data operations
import '../models/order_model.dart';
import '../models/product_model.dart';

class DataService {
  // Singleton pattern
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Mock data storage (will be replaced with database later)
  final List<Order> _orders = [];
  final List<Product> _products = [];

  // Order methods
  List<Order> get orders => List.unmodifiable(_orders);
  
  void addOrder(Order order) {
    _orders.add(order);
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  void updateOrder(Order order) {
    final index = _orders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _orders[index] = order;
    }
  }

  void deleteOrder(String id) {
    _orders.removeWhere((order) => order.id == id);
  }

  // Product methods
  List<Product> get products => List.unmodifiable(_products);
  
  void addProduct(Product product) {
    _products.add(product);
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);
  }

  // Statistics
  int getTotalOrders() => _orders.length;
  int getTotalProducts() => _products.length;
  
  double getTotalRevenue() {
    return _orders.fold(0.0, (sum, order) => sum + order.total);
  }
}

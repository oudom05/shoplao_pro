class Product {
  final String id;
  final String name;
  final String category;
  final String unit;
  final double costPrice;
  final double sellingPrice;
  final String status; // 'ພ້ອມສົ່ງ' ຫຼື 'ພຣີອໍເດີ້'
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.costPrice,
    required this.sellingPrice,
    required this.status,
    this.imageUrl,
  });
}
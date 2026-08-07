class OrderItem {
  final String customerName;
  final String whatsappNumber;
  final String productName;
  final String paymentType; // 'ຈ່າຍກ່ອນ 30%', 'ຈ່າຍເຕັມ' ຯลຯ
  final String status; // 'ຈ່າຍແລ້ວ', 'ລໍຖ້າຈ່າຍ', 'ຍົກເລີກ'
  final double depositAmount;

  OrderItem({
    required this.customerName,
    required this.whatsappNumber,
    required this.productName,
    required this.paymentType,
    required this.status,
    required this.depositAmount,
  });
}
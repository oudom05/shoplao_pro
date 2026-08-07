import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'all_orders_view.dart';

// ==============================================================================
// 🟢 [HEAD] ຫົວຂໍ້: OrderView Widget (ໜ້າຈັດການອໍເດີ້, ບັນທຶກ ແລະ ກັ່ນຕອງລັອດອັດຕະໂນມັດ)
// ==============================================================================
class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  // 🟢 [CONTROLLERS] ຕົວແປສຳລັບຄວບຄຸມ ແລະ ຮັບຄ່າຈາກ TextField ໃນຟອມ
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _searchOrderController = TextEditingController();

  // 🟢 [STATE VARIABLES] ຕົວແປເກັບສະຖານະຕ່າງໆພາຍໃນໜ້າ
  String _orderType = 'ready'; // 'ready' = ພ້ອມສົ່ງ, 'preorder' = Pre-order
  String _paymentMode = '30%'; // ໂໝດການຈ່າຍເງິນມັດຈຳ (30%, 50%, 100%)
  Map<String, dynamic>? _selectedProduct; // ເກັບຂໍ້ມູນສິນຄ້າທີ່ຖືກເລືອກຈາກຄັງ
  String? _phoneErrorText; // ເກັບຂໍ້ຄວາມແຈ້ງເຕືອນເມື່ອເບີໂທບໍ່ຖືກຕ້ອງ
  DateTime _selectedCloseDate = DateTime.now(); // ວັນທີປິດຮັບອໍເດີ້ສຳລັບສ້າງລັອດໃໝ່

  // 🟢 [LOTS DATA] ລາຍການລັອດ Pre-order ທັງໝົດໃນລະບົບ
  final List<Map<String, String>> _lots = [
    {'name': 'ລັອດປະຈຳວັນທີ 05', 'date': '05/08/2026'}, // ວັນນີ້ (ຄົບກຳນົດມື້ນີ້)
    {'name': 'ລັອດປະຈຳວັນທີ 10', 'date': '10/08/2026'}, // ຍັງບໍ່ທັນໝົດອາຍຸ
  ];
  String? _selectedLot; // ລັອດທີ່ຜູ້ໃຊ້ເລືອກໃນ Dropdown

  // 🟢 [MOCKUP INVENTORY] ຂໍ້ມູນສິນຄ້າຕົວຢ່າງທີ່ມີຢູ່ໃນຄັງສິນຄ້າ
  final List<Map<String, dynamic>> _inventoryProducts = [
    {'name': 'ເສື້ອຍືດຄໍກົມ ສີພື້ນ', 'price': '45,000 ₭', 'stock': 50},
    {'name': 'ກະຕຸກນ້ຳເກັບຄວາມເຢັນ 1L', 'price': '120,000 ₭', 'stock': 15},
    {'name': 'ກາງເກງຍີນຂາຍາວ', 'price': '95,000 ₭', 'stock': 20},
  ];

  // 🟢 [ORDERS DATA] ລາຍການອໍເດີ້ທີ່ມີໃນລະບົບ (ສາມາດເພີ່ມໃໝ່ໄດ້ແບບ Real-time)
  final List<Map<String, dynamic>> _existingOrders = [
    {
      'orderId': '#ORD-001',
      'customerName': 'ທ້າວ ສົມຊາຍ',
      'phone': '20 55112233',
      'productName': 'ເສື້ອຍືດຄໍກົມ ສີພື້ນ',
      'price': '45,000 ₭',
      'type': 'ພ້ອມສົ່ງ',
      'status': 'ລໍຖ້າຈ່າຍ',
    },
  ];

  // ==============================================================================
  // ⚙️ [LOGIC: LOT FILTERING] ລະບົບກັ່ນຕອງລັອດ (ເຊື່ອງລັອດທີ່ໝົດອາຍຸ/ກາຍວັນທີແລ້ວ)
  // ==============================================================================
  
  // 1. ຟັງຊັນຊ່ວຍແປງ String ວັນທີ (ຮູບແບບ 'DD/MM/YYYY') ໃຫ້ເປັນ Object DateTime
  DateTime? _parseLotDate(String dateStr) {
    try {
      List<String> parts = dateStr.split('/');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // ຈັດການຂໍ້ຜິດພາດກໍລະນີ Format ວັນທີຜິດ
    }
    return null;
  }

  // 2. ຟັງຊັນກັ່ນຕອງເອົາສະເພາະລັອດທີ່ວັນທີປິດຮັບ ຍັງບໍ່ທັນກາຍ (ວັນນີ້ ຫຼື ມື້ອື່ນໆທີ່ຍັງເຫຼືອ)
  List<Map<String, String>> get _activeLots {
    DateTime today = DateTime.now();
    DateTime currentDate = DateTime(today.year, today.month, today.day); // ເອົາສະເພາະ ວັນ/ເືອນ/ປີ ປັດຈຸບັນ

    return _lots.where((lot) {
      DateTime? closeDate = _parseLotDate(lot['date'] ?? '');
      if (closeDate == null) return true; // ຖ້າແປງວັນທີບໍ່ໄດ້ ໃຫ້ສະແດງໄວ້ກ່ອນກັນຜິດພາດ
      
      // เงื่อนไข: ວັນທີປິດຮັບ ຕ້ອງເທົ່າກັບ ຫຼີ ຫຼາຍກວ່າ ມື້ນີ້ (ຍັງບໍ່ທັນໝົດອາຍຸ)
      return closeDate.isAtSameMomentAs(currentDate) || closeDate.isAfter(currentDate);
    }).toList();
  }

  // ==============================================================================
  // 💰 [LOGIC: PAYMENT] ຟັງຊັນຄຳນວນຍອດເງິນມັດຈຳຕາມເປີເຊັນທີ່ເລືອກ
  // ==============================================================================
  String _calculatePaymentAmount() {
    if (_selectedProduct == null) return '0 ₭';
    
    String cleanPrice = _selectedProduct!['price'].replaceAll(RegExp(r'[^0-9]'), '');
    double price = double.tryParse(cleanPrice) ?? 0.0;
    
    double calculated = 0.0;
    if (_paymentMode == '30%') {
      calculated = price * 0.30;
    } else if (_paymentMode == '50%') {
      calculated = price * 0.50;
    } else {
      calculated = price; // 100%
    }
    
    return '${calculated.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₭';
  }

  // ==============================================================================
  // 📱 [UI DIALOG: CREATE LOT] Popup ສຳລັບສ້າງລັອດ Pre-order ໃໝ່ພ້ອມ CupertinoDatePicker
  // ==============================================================================
  void _showCreateLotDialog() {
    final TextEditingController lotNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('ສ້າງລັອດ Pre-order ໃໝ່', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ຊື່ລັອດ / ລະຫັດລັອດ *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
              const SizedBox(height: 6),
              TextField(
                controller: lotNameController,
                decoration: InputDecoration(
                  hintText: 'ເຊັ່ນ: ລັອດປະຈຳວັນທີ 15',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('ວັນທີປິດຮັບອໍເດີ້ *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
              const SizedBox(height: 6),
              
              // ປຸ່ມກົດເປີດລໍ້ໝຸນເລືອກວັນທີ (CupertinoDatePicker)
              GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 250,
                        padding: const EdgeInsets.only(top: 6.0),
                        color: CupertinoColors.systemBackground.resolveFrom(context),
                        child: SafeArea(
                          top: false,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CupertinoButton(
                                    child: const Text('ຕົກລົງ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  initialDateTime: _selectedCloseDate,
                                  minimumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                  maximumDate: DateTime.now().add(const Duration(days: 365)),
                                  onDateTimeChanged: (DateTime newDate) {
                                    setState(() {
                                      _selectedCloseDate = newDate;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedCloseDate.day.toString().padLeft(2, '0')}/${_selectedCloseDate.month.toString().padLeft(2, '0')}/${_selectedCloseDate.year}',
                        style: const TextStyle(color: Color(0xFF1E1B4B), fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.unfold_more, color: Color(0xFFD97706), size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ຍົກເລີກ', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (lotNameController.text.trim().isNotEmpty) {
                  String formattedDate = '${_selectedCloseDate.day.toString().padLeft(2, '0')}/${_selectedCloseDate.month.toString().padLeft(2, '0')}/${_selectedCloseDate.year}';
                  setState(() {
                    _lots.add({
                      'name': lotNameController.text.trim(),
                      'date': formattedDate,
                    });
                    _selectedLot = lotNameController.text.trim(); // ເລືອກລັອດໃໝ່ນີ້ອັດຕະໂນມັດ
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ສ້າງລັອດສຳເລັດ!'), backgroundColor: Colors.green),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ກະລຸນາໃສ່ຊື່ລັອດກ່ອນ!'), backgroundColor: Colors.red),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706)),
              child: const Text('ບັນທຶກລັອດ', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ==============================================================================
  // 🛍️ [UI SHEET: PRODUCT PICKER] Modal ລຸ່ມໜ້າຈໍສຳລັບເລືອກສິນຄ້າຈາກຄັງ
  // ==============================================================================
  void _showProductSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ເລືອກສິນຄ້າຈາກຄັງ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: 'ຄົ້ນຫາຊື່ສິນຄ້າ...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: _inventoryProducts.length,
                  itemBuilder: (context, index) {
                    final prod = _inventoryProducts[index];
                    return ListTile(
                      leading: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.image, color: Colors.grey, size: 20),
                      ),
                      title: Text(prod['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('ລາຄາຂາຍ: ${prod['price']}'),
                      trailing: Text('ເຫຼືອ: ${prod['stock']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      onTap: () {
                        setState(() {
                          _selectedProduct = prod;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==============================================================================
  // ✅ [LOGIC: SUBMIT ORDER] ກວດສອບຄວາມຖືກຕ້ອງ ແລະ ບັນທຶກອໍເດີ້ລົງ List
  // ==============================================================================
  void _submitOrder() {
    setState(() {
      String phone = _phoneController.text.trim();
      if (phone.isEmpty) {
        _phoneErrorText = 'ກະລຸນາປ້ອນເບີ WhatsApp';
        return;
      } else if (phone.length < 8) {
        _phoneErrorText = 'ເບີໂທບໍ່ຖືກຕ້ອງ (ຕ້ອງມີຢ່າງໜ້ອຍ 8 ຫຼັກ)';
        return;
      } else {
        _phoneErrorText = null;
      }

      if (_selectedProduct == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ກະລຸນາເລືອກສິນຄ້າຈາກຄັງກ່ອນ!'), backgroundColor: Colors.red),
        );
        return;
      }

      // 🔍 ກວດສອບຖ້າເລືອກ Pre-order ຕ້ອງກວດວ່າໄດ້ເລືອກລັອດແລ້ວ ຫຼື ບໍ່
      if (_orderType == 'preorder' && (_selectedLot == null || _selectedLot!.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ກະລຸນາເລືອກລັອດ'), backgroundColor: Colors.red),
        );
        return;
      }

      // ສ້າງ Object ອໍເດີ້ໃໝ່
      final newOrder = {
        'orderId': '#ORD-00${_existingOrders.length + 1}',
        'customerName': _customerNameController.text.isEmpty ? 'ລູກຄ້າທົ່ວໄປ' : _customerNameController.text,
        'phone': phone,
        'productName': _selectedProduct!['name'],
        'price': _selectedProduct!['price'],
        'type': _orderType == 'ready' ? 'ພ້ອມສົ່ງ' : 'Pre-order',
        'status': _orderType == 'ready' ? 'ລໍຖ້າຈ່າຍ' : 'ມັດຈຳແລ້ວ ($_paymentMode)',
        'lot': _orderType == 'preorder' ? _selectedLot : '-',
      };

      // ບັນທຶກເຂົ້າ List ແລະ ລ້າງຟອມ
      _existingOrders.insert(0, newOrder);
      _customerNameController.clear();
      _phoneController.clear();
      _selectedProduct = null;
      _selectedLot = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ບັນທຶກອໍເດີ້ສຳເລັດ!'), backgroundColor: Colors.green),
      );
    });
  }

  // ==============================================================================
  // 🖥️ [BUILD METHOD] ສ່ວນສະແດງຜົນ UI ຫຼັກຂອງໜ້າແອັບ
  // ==============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            
            // 📌 [SECTION 1] ສ່ວນຫົວຂໍ້ໜ້າແອັບ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ໜ້າຈັດການອໍເດີ້',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'ບັນທຶກ ແລະ ຕິດຕາມລາຍການສັ່ງຊື້ທັງໝົດ',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 📌 [SECTION 2] ສ່ວນຟອມປ້ອນຂໍ້ມູນສ້າງອໍເດີ້ໃໝ່
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.shade100),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.shopping_cart_outlined, color: Color(0xFF4338CA), size: 20),
                      SizedBox(width: 8),
                      Text('ສ້າງອໍເດີ້ໃໝ່', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ປຸ່ມກົດປ່ຽນປະເພດອໍເດີ້ (ພ້ອມສົ່ງ VS Pre-order)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _orderType = 'ready'),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _orderType == 'ready' ? const Color(0xFF4338CA) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('ອໍເດີ້ພ້ອມສົ່ງ', style: TextStyle(color: _orderType == 'ready' ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _orderType = 'preorder'),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _orderType == 'preorder' ? const Color(0xFFD97706) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Pre-order', style: TextStyle(color: _orderType == 'preorder' ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ຊ່ອງປ້ອນຊື່ລູກຄ້າ
                  const Text('ຊື່ລູກຄ້າ *', style: TextStyle(color: Color(0xFF4338CA), fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _customerNameController,
                    decoration: InputDecoration(
                      hintText: 'ປ້ອນຊື່ລູກຄ້າ',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ຊ່ອງປ້ອນເບີ WhatsApp
                  const Text('ເບີ WhatsApp ລູກຄ້າ *', style: TextStyle(color: Color(0xFF4338CA), fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '20 5X XXX XXX',
                      errorText: _phoneErrorText,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ຊ່ອງເລືອກສິນຄ້າ
                  const Text('ເລືອກສິນຄ້າ *', style: TextStyle(color: Color(0xFF4338CA), fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _showProductSearchSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedProduct == null ? 'ກົດເລືອກສິນຄ້າຈາກຄັງ...' : _selectedProduct!['name'],
                            style: TextStyle(
                              color: _selectedProduct == null ? Colors.grey : const Color(0xFF1E1B4B),
                              fontWeight: _selectedProduct == null ? FontWeight.normal : FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  // ສະແດງລາຄາສິນຄ້າເມື່ອເລືອກແລ້ວ
                  if (_selectedProduct != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ລາຄາຂາຍຕາມຄັງສິນຄ້າ:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            _selectedProduct!['price'],
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF4338CA)),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // 📌 [SECTION 2.1] ສະແດງສະເພາະຕອນເລືອກ Pre-order (ໃຊ້ _activeLots ກັ່ນຕອງລັອດທີ່ໝົດອາຍຸອອກ)
                  if (_orderType == 'preorder') ...[
                    const SizedBox(height: 14),
                    const Text('ເລືອກລັອດ Pre-order *', style: TextStyle(color: Color(0xFFD97706), fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedLot,
                            hint: const Text('ກະລຸນາເລືອກລັອດ', style: TextStyle(fontSize: 11)),
                            isDense: true,
                            // 🟢 ໃຊ້ _activeLots ແທນ _lots ເພື່ອໃຫ້ລັອດທີ່ຮອດວັນທີແລ້ວຫາຍໄປອັດຕະໂນມັດ;
                            items: _activeLots.map((lot) {
                              return DropdownMenuItem(
                                value: lot['name'],
                                child: Text('${lot['name']} (ປິດຮັບ: ${lot['date']})', style: const TextStyle(fontSize: 12)),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedLot = val),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.amber.shade50,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.amber.shade400)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.amber.shade400)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // ປຸ່ມກົດເປີດ Dialog ສ້າງລັອດໃໝ່
                        ElevatedButton.icon(
                          onPressed: _showCreateLotDialog,
                          icon: const Icon(Icons.add, color: Colors.white, size: 16),
                          label: const Text('ສ້າງລັອດ', style: TextStyle(color: Colors.white, fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD97706),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text('ຮູບແບບການຈ່າຍເງິນ *', style: TextStyle(color: Color(0xFFD97706), fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('ມັດຈຳ 30%', style: TextStyle(fontSize: 11)),
                            value: '30%',
                            groupValue: _paymentMode,
                            activeColor: const Color(0xFFD97706),
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) => setState(() => _paymentMode = value!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('ມັດຈຳ 50%', style: TextStyle(fontSize: 11)),
                            value: '50%',
                            groupValue: _paymentMode,
                            activeColor: const Color(0xFFD97706),
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) => setState(() => _paymentMode = value!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('ຈ່າຍເຕັມ 100%', style: TextStyle(fontSize: 11)),
                            value: '100%',
                            groupValue: _paymentMode,
                            activeColor: const Color(0xFFD97706),
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) => setState(() => _paymentMode = value!),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    // ສະແດງຍອດເງິນທີ່ຕ້ອງຈ່າຍມັດຈຳ
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _paymentMode == '100%' ? 'ຍອດເງິນທີ່ຕ້ອງຈ່າຍທັງໝົດ:' : 'ຍອດເງິນມັດຈຳ (${_paymentMode}):',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF92400E)),
                          ),
                          Text(
                            _calculatePaymentAmount(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // ປຸ່ມກົດບັນທຶກອໍເດີ້
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _submitOrder,
                      icon: const Icon(Icons.save_alt, color: Colors.white, size: 18),
                      label: const Text('ບັນທຶກອໍເດີ້', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4338CA),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 📌 [SECTION 3] ສ່ວນສະແດງລາຍການອໍເດີ້ຫຼ້າສຸດ ພ້ອມປຸ່ມກົດໄປເບິ່ງທັງໝົດ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ລາຍການອໍເດີ້ຫຼ້າສຸດ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B)),
                ),
                // ປຸ່ມກົດໄປໜ້າ AllOrdersView (ເບິ່ງລາຍການອໍເດີ້ທັງໝົດ)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllOrdersView(orders: _existingOrders),
                      ),
                    );
                  },
                  child: const Text('ເບິ່ງທັງໝົດ >', style: TextStyle(color: Color(0xFF4338CA), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ຊ່ອງຄົ້ນຫາອໍເດີ້
            TextField(
              controller: _searchOrderController,
              decoration: InputDecoration(
                hintText: 'ຄົ້ນຫາຊື່ລູກຄ້າ ຫຼື ລະຫັດອໍເດີ້...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(height: 12),

            // ລາຍການ List ຂອງອໍເດີ້ຫຼ້າສຸດ (ສະແດງສູງສຸດ 3 ລາຍການ)
            ListView.builder(
              itemCount: _existingOrders.length > 3 ? 3 : _existingOrders.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final order = _existingOrders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(order['orderId'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4338CA), fontSize: 13)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: order['type'] == 'Pre-order' ? Colors.amber.shade100 : Colors.indigo.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(order['type'], style: TextStyle(fontSize: 10, color: order['type'] == 'Pre-order' ? Colors.amber.shade800 : Colors.indigo.shade800, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('ລູກຄ້າ: ${order['customerName']} (${order['phone']})', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                          const SizedBox(height: 2),
                          Text('ສິນຄ້າ: ${order['productName']} - ${order['price']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          if (order['type'] == 'Pre-order') ...[
                            const SizedBox(height: 2),
                            Text('ລັອດ: ${order['lot']}', style: const TextStyle(fontSize: 12, color: Color(0xFFD97706), fontWeight: FontWeight.w600)),
                          ],
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(order['status'], style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
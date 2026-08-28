import 'package:flutter/material.dart';

class AllOrdersView extends StatefulWidget {
  final List<Map<String, dynamic>> orders;

  const AllOrdersView({super.key, required this.orders});

  @override
  State<AllOrdersView> createState() => _AllOrdersViewState();
}

class _AllOrdersViewState extends State<AllOrdersView> {
  String _filterType = 'ready'; // 'ready', 'preorder'
  String _paymentFilter = '30%'; // '30%', '50%', '100%'
  String _searchQuery = '';

  // 🟢 ຟັງຊັນຊ່ວຍສ້າງ Radio Button ສຳລັບມັດຈຳ Pre-order
  Widget _buildRadioOption(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: _paymentFilter,
          activeColor: const Color(0xFF4338CA),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: (val) {
            setState(() {
              _paymentFilter = val!;
            });
          },
        ),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(width: 4),
      ],
    );
  }

  // 🟢 ຟັງຊັນແຈ້ງເຕືອນເມື່ອລົບສຳເລັດ
  void _showDeleteDialog(int index, List filteredList) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ຢືນຢັນການລົບ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text('ທ່ານຕ້ອງການລົບອໍເດ້ນີ້ແທ້ບໍ?', style: TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ຍົກເລີກ', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                widget.orders.remove(filteredList[index]);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ລົບສຳເລັດແລ້ວ'), backgroundColor: Colors.red),
              );
            },
            child: const Text('ລົບ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // 🟢 ຟັງຊັນ Popup ແກ້ໄຂຂໍ້ມູນຕາມປະເພດອໍເດີ້
  void _showEditDialog(Map<String, dynamic> order) {
    final TextEditingController customerController = TextEditingController(text: order['customerName']);
    final TextEditingController phoneController = TextEditingController(text: order['phone']);
    final TextEditingController productController = TextEditingController(text: order['productName']);
    final TextEditingController priceController = TextEditingController(text: order['price']);
    
    String currentStatus = order['status'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ແກ້ໄຂອໍເດີ້: ${order['orderId']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: customerController,
                decoration: const InputDecoration(labelText: 'ຊື່ລູກຄ້າ', isDense: true),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'ເບີໂທ', isDense: true),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: productController,
                decoration: const InputDecoration(labelText: 'ສິນຄ້າ', isDense: true),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'ລາຄາ', isDense: true),
              ),
              const SizedBox(height: 8),
              if (order['type'] == 'Pre-order') ...[
                DropdownButtonFormField<String>(
                  value: currentStatus.contains('30%') ? '30%' : (currentStatus.contains('50%') ? '50%' : '100%'),
                  items: const [
                    DropdownMenuItem(value: '30%', child: Text('ມັດຈຳ 30%')),
                    DropdownMenuItem(value: '50%', child: Text('ມັດຈຳ 50%')),
                    DropdownMenuItem(value: '100%', child: Text('ຈ່າຍເຕັມ 100%')),
                  ],
                  onChanged: (val) {
                    currentStatus = 'ມັດຈຳ $val';
                  },
                  decoration: const InputDecoration(labelText: 'ສະຖານະການຈ່າຍເງິນ', isDense: true),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ຍົກເລີກ', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4338CA)),
            onPressed: () {
              setState(() {
                order['customerName'] = customerController.text;
                order['phone'] = phoneController.text;
                order['productName'] = productController.text;
                order['price'] = priceController.text;
                if (order['type'] == 'Pre-order') {
                  order['status'] = currentStatus;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ແກ້ໄຂສຳເລັດແລ້ວ'), backgroundColor: Colors.green),
              );
            },
            child: const Text('ບັນທຶກ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalOrders = widget.orders.length;
    final int readyCount = widget.orders.where((o) => o['type'] == 'ພ້ອມສົ່ງ' || o['type'] == 'ready').length;
    final int preorderCount = widget.orders.where((o) => o['type'] == 'Pre-order' || o['type'] == 'preorder').length;
    
    final double readyRatio = totalOrders > 0 ? readyCount / totalOrders : 0.0;

    final filteredOrders = widget.orders.where((order) {
      final matchesType = (_filterType == 'ready' && (order['type'] == 'ພ້ອມສົ່ງ' || order['type'] == 'ready')) || 
          (_filterType == 'preorder' && (order['type'] == 'Pre-order' || order['type'] == 'preorder'));
      
      bool matchesPayment = true;
      if (_filterType == 'preorder') {
        matchesPayment = order['status'].toString().contains(_paymentFilter);
      }

      final matchesSearch = order['orderId'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order['customerName'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order['phone'].contains(_searchQuery);

      return matchesType && matchesPayment && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('ລາຍການອໍເດີ້ທັງໝົດ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E1B4B),
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🟢 Card ສະຫຼຸບຍອດອໍເດີ້
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                          child: const Icon(Icons.shopping_bag_outlined, color: Colors.green, size: 18),
                        ),
                        const SizedBox(height: 10),
                        const Text('ອໍເດີ້ທັງໝົດ', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        const SizedBox(height: 2),
                        Text('$totalOrders', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ສະຖານະສິນຄ້າ', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('ພ້ອມສົ່ງ', style: TextStyle(fontSize: 10, color: Color(0xFF4338CA), fontWeight: FontWeight.bold)),
                                Text('$readyCount ອໍເດີ້', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Pre-order', style: TextStyle(fontSize: 10, color: Color(0xFF92400E), fontWeight: FontWeight.bold)),
                                Text('$preorderCount ອໍເດີ້', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: readyRatio,
                            minHeight: 6,
                            backgroundColor: const Color(0xFF92400E),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4338CA)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 🟢 ToggleButtons & Search Bar
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ToggleButtons(
                  isSelected: [
                    _filterType == 'ready',
                    _filterType == 'preorder',
                  ],
                  onPressed: (index) {
                    setState(() {
                      if (index == 0) _filterType = 'ready';
                      if (index == 1) _filterType = 'preorder';
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: const Color(0xFF4338CA),
                  color: const Color(0xFF1E1B4B),
                  constraints: const BoxConstraints(minHeight: 36, minWidth: 80),
                  children: const [
                    Text('ພ້ອມສົ່ງ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('Pre-order', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),

                SizedBox(
                  width: 160,
                  height: 36,
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'ຄົ້ນຫາ...',
                      hintStyle: const TextStyle(fontSize: 11),
                      prefixIcon: const Icon(Icons.search, size: 16, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    ),
                  ),
                ),
              ],
            ),
            
            if (_filterType == 'preorder') ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('ມັດຈຳ:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
                  const SizedBox(width: 4),
                  _buildRadioOption('30%'),
                  _buildRadioOption('50%'),
                  _buildRadioOption('100%'),
                ],
              ),
            ],
            const SizedBox(height: 14),

            // 🟢 ປ່ຽນຈາກ DataTable ມາເປັນ ListView (Card List) ທີ່ເໝາະກັບໜ້າຈໍມືຖື ເຫັນຄົບທຸກຢ່າງ
            Expanded(
      child: filteredOrders.isEmpty
          ? const Center(child: Text('ບໍ່ມີຂໍ້ມູນ order', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                var order = filteredOrders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order['orderId'],
                            style: const TextStyle(color: Color(0xFF4338CA), fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: order['type'] == 'Pre-order' ? Colors.amber.shade100 : Colors.indigo.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  order['type'],
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: order['type'] == 'Pre-order' ? Colors.amber.shade800 : Colors.indigo.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => _showEditDialog(order),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.edit, size: 16, color: Colors.blue),
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () => _showDeleteDialog(index, filteredOrders),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.delete, size: 16, color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ລູກຄ້າ: ${order['customerName']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          Text('ເບີໂທ: ${order['phone']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ສິນຄ້າ: ${order['productName']}', style: const TextStyle(fontSize: 12)),
                          Text('${order['price']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(order['status'], style: TextStyle(fontSize: 10, color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    ),
          ],
        ),
      ),
    );
  }
}
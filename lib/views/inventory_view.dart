import 'package:flutter/material.dart';

// ==============================================================================
// 🟢 [HEAD] ຫົວຂໍ້: InventoryView Widget (ແບບ Popup / Bottom Sheet)
// ==============================================================================
class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();
  final TextEditingController _newUnitController = TextEditingController();
  final TextEditingController _sizeInputController = TextEditingController();
  final TextEditingController _colorInputController = TextEditingController();

  // Toggles & Lists
  bool _enableSize = false;
  bool _enableColor = false;
  final List<String> _tempSizes = [];
  final List<String> _tempColors = [];

  final List<String> _categories = ['ເສື້ອຜ້າ', 'ເຄື່ອງໃຊ້', 'ອິນເຕີເນັດ/ໄອທີ', 'ທົ່ວໄປ'];
  final List<String> _units = ['ຜືນ', 'ອັນ', 'ລິດ', 'ໂຕ', 'ກ່ອງ'];

  String _selectedStatus = 'ພ້ອມສົ່ງ';
  String _selectedCategory = 'ເສື້ອຜ້າ';
  String _selectedUnit = 'ຜືນ';

  String _filterMainTab = 'ພ້ອມສົ່ງ'; 
  String _searchQuery = '';

  // Mockup Data ລາຍການສິນຄ້າ
  final List<Map<String, dynamic>> _productList = [
    {
      'name': 'ເສື້ອຍືດຄໍກົມ ສີພື້ນ ຜ້າຝ້າຍແທ້',
      'category': 'ເສື້ອຜ້າ',
      'unit': 'ຜືນ',
      'sizes': ['S', 'M', 'L'],
      'colors': ['ດຳ', 'ຂາວ'],
      'stock': 8,
      'costPrice': '30,000 ₭',
      'price': '45,000 ₭',
      'statusText': 'ພ້ອມສົ່ງ',
    },
    {
      'name': 'ກະຕຸກນ້ຳເກັບຄວາມເຢັນ 1L',
      'category': 'ເຄື່ອງໃຊ້',
      'unit': 'ລິດ',
      'sizes': <String>[],
      'colors': ['ດຳ', 'ຟ້າ'],
      'stock': 0,
      'costPrice': '80,000 ₭',
      'price': '120,000 ₭',
      'statusText': 'Pre-order',
    },
  ];

  // --------------------------------------------------------------------------
  // Functions
  // --------------------------------------------------------------------------
  void _addNewProduct() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ກະລຸນາປ້ອນຊື່ສິນຄ້າກ່ອນ!')),
      );
      return;
    }

    int stockVal = 0;
    if (_selectedStatus == 'ພ້ອມສົ່ງ' && _stockController.text.isNotEmpty) {
      stockVal = int.tryParse(_stockController.text) ?? 0;
    }

    setState(() {
      _productList.insert(0, {
        'name': _nameController.text,
        'category': _selectedCategory,
        'unit': _selectedUnit,
        'sizes': _enableSize ? List<String>.from(_tempSizes) : <String>[],
        'colors': _enableColor ? List<String>.from(_tempColors) : <String>[],
        'stock': stockVal,
        'costPrice': '${_costController.text.isEmpty ? "0" : _costController.text} ₭',
        'price': '${_priceController.text.isEmpty ? "0" : _priceController.text} ₭',
        'statusText': _selectedStatus,
      });
    });

    // Reset & Close Popup
    _clearForm();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ເພີ່ມສິນຄ້າສຳເລັດແລ້ວ!')),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _costController.clear();
    _priceController.clear();
    _stockController.clear();
    _sizeInputController.clear();
    _colorInputController.clear();
    _tempSizes.clear();
    _tempColors.clear();
    _enableSize = false;
    _enableColor = false;
    _selectedStatus = 'ພ້ອມສົ່ງ';
  }

  // --------------------------------------------------------------------------
  // UI Popup Form (Layout ທີ່ຈັດໃໝ່ໃຫ້ງາມ ແລະ ເປັນລະບຽບ)
  // --------------------------------------------------------------------------
  void _showAddProductPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Header bar ຂອງ Popup
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ເພີ່ມສິນຄ້າໃໝ່', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Body Form (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ຮູບຖ່າຍສິນຄ້າ (จัด Layout ໃຫ້ເບິ່ງງ່າຍ ສະອາດຕາ)
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.indigo.shade100),
                          ),
                          child: const Icon(Icons.add_a_photo_outlined, color: Color(0xFF6366F1), size: 30),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ຊື່ສິນຄ້າ
                      const Text('ຊື່ສິນຄ້າ', style: TextStyle(color: Color(0xFF4338CA), fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'ປ້ອນຊື່ສິນຄ້າ',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ປະເພດ & ໜ່ວຍນັບ
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('ປະເພດ', style: TextStyle(color: Color(0xFF4338CA), fontSize: 13, fontWeight: FontWeight.bold)),
                                      GestureDetector(
                                        onTap: () {
                                          // ຟັງຊັນເພີ່ມປະເພດ
                                        },
                                        child: const Text('+ ເພີ່ມໃໝ່', style: TextStyle(color: Color(0xFF6366F1), fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCategory,
                                      isExpanded: true,
                                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                                      onChanged: (val) => setModalState(() => _selectedCategory = val!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('ໜ່ວຍນັບ', style: TextStyle(color: Color(0xFF4338CA), fontSize: 13, fontWeight: FontWeight.bold)),
                                      GestureDetector(
                                        onTap: () {},
                                        child: const Text('+ ເພີ່ມໃໝ່', style: TextStyle(color: Color(0xFF6366F1), fontSize: 11, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedUnit,
                                      isExpanded: true,
                                      items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 13)))).toList(),
                                      onChanged: (val) => setModalState(() => _selectedUnit = val!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ລາຄາຕົ້ນທຶນ & ລາຄາຂາຍ
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('ລາຄາຕົ້ນທຶນ', style: TextStyle(color: Color(0xFF4338CA), fontSize: 13, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _costController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '0', 
                                    suffixText: '₭', 
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), 
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('ລາຄາຂາຍ', style: TextStyle(color: Color(0xFF4338CA), fontSize: 13, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '0', 
                                    suffixText: '₭', 
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), 
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ສະຖານະ (ພ້ອມສົ່ງ / Pre-order)
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModalState(() => _selectedStatus = 'ພ້ອມສົ່ງ'),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _selectedStatus == 'ພ້ອມສົ່ງ' ? const Color(0xFF047857) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('ພ້ອມສົ່ງ', style: TextStyle(color: _selectedStatus == 'ພ້ອມສົ່ງ' ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModalState(() => _selectedStatus = 'Pre-order'),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _selectedStatus == 'Pre-order' ? const Color(0xFFD97706) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('Pre-order', style: TextStyle(color: _selectedStatus == 'Pre-order' ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (_selectedStatus == 'ພ້ອມສົ່ງ') ...[
                        const Text('ຈຳນວນສະຕັອກໃນຄັງ', style: TextStyle(color: Color(0xFF4338CA), fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'ປ້ອນຈຳນວນ (ຕົວຢ່າງ: 50)', 
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), 
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Size & Color Options Checkbox
                      // 📌 ຢາຍສ່ວນນີ້ໄປທຽບໃສ່ໃນຟັງຊັນ _showAddProductPopup ຂອງເຈົ້າ

// 1. ຈັດລຽງ Checkbox ໃຫ້ລຽງຊິດກັນຈາກຊ້າຍມື
Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    SizedBox(
      width: 110,
      child: CheckboxListTile(
        title: const Text('Size', style: TextStyle(fontSize: 13)),
        value: _enableSize,
        onChanged: (val) => setModalState(() => _enableSize = val ?? false),
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
      ),
    ),
    const SizedBox(width: 20),
    SizedBox(
      width: 100,
      child: CheckboxListTile(
        title: const Text('ສີ', style: TextStyle(fontSize: 13)),
        value: _enableColor,
        onChanged: (val) => setModalState(() => _enableColor = val ?? false),
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
      ),
    ),
  ],
),
const SizedBox(height: 10),

// 2. ສະແດງຊ່ອງປ້ອນ Size ເມື່ອກົດຕິກ
if (_enableSize) ...[
  Row(
    children: [
      Expanded(
        child: TextField(
          controller: _sizeInputController,
          decoration: InputDecoration(
            hintText: 'ລະບຸ Size (ເຊັ່ນ: S, M, L)',
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      const SizedBox(width: 8),
      ElevatedButton(
        onPressed: () {
          if (_sizeInputController.text.isNotEmpty) {
            setModalState(() {
              _tempSizes.add(_sizeInputController.text.trim());
              _sizeInputController.clear();
            });
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
        child: const Text('ເພີ່ມ', style: TextStyle(color: Colors.white)),
      ),
    ],
  ),
  const SizedBox(height: 6),
  if (_tempSizes.isNotEmpty)
    Wrap(
      spacing: 6,
      children: _tempSizes.map((s) => Chip(
            label: Text(s),
            onDeleted: () => setModalState(() => _tempSizes.remove(s)),
          )).toList(),
    ),
  const SizedBox(height: 10),
],

// 3. ສະແດງຊ່ອງປ້ອນ ສີ ເມື່ອກົດຕິກ
if (_enableColor) ...[
  Row(
    children: [
      Expanded(
        child: TextField(
          controller: _colorInputController,
          decoration: InputDecoration(
            hintText: 'ລະບຸສີ (ເຊັ່ນ: ດຳ, ຂາວ)',
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      const SizedBox(width: 8),
      ElevatedButton(
        onPressed: () {
          if (_colorInputController.text.isNotEmpty) {
            setModalState(() {
              _tempColors.add(_colorInputController.text.trim());
              _colorInputController.clear();
            });
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
        child: const Text('ເພີ່ມ', style: TextStyle(color: Colors.white)),
      ),
    ],
  ),
  const SizedBox(height: 6),
  if (_tempColors.isNotEmpty)
    Wrap(
      spacing: 6,
      children: _tempColors.map((c) => Chip(
            label: Text(c),
            onDeleted: () => setModalState(() => _tempColors.remove(c)),
          )).toList(),
    ),
  const SizedBox(height: 10),
],
                      const SizedBox(height: 10),

                      // ປຸ່ມບັນທຶກດ້ານລຸ່ມสุดໃນ Popup
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _addNewProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF047857), 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('ບັນທຶກສິນຄ້າ', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalProducts = _productList.length;
    int readyStockCount = _productList.where((p) => p['statusText'] == 'ພ້ອມສົ່ງ').length;
    int preOrderCount = _productList.where((p) => p['statusText'] == 'Pre-order').length;

    List filteredList = _productList.where((item) {
      bool matchesTab = item['statusText'] == _filterMainTab;
      bool matchesSearch = item['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesTab && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // 🟢 ມີປຸ່ມເພີ່ມສິນຄ້າລອຍຢູ່ມຸມຂວາລຸ່ມ (Floating Action Button)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductPopup(context),
        backgroundColor: const Color(0xFF047857),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('ເພີ່ມສິນຄ້າ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFF6366F1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.store, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'ຄຸ້ມຄອງການຂາຍ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B)),
                      ),
                    ],
                  ),
                  
                ],
              ),
              const SizedBox(height: 16),

              // 2 ບ໋ອກສະຫຼຸບຂໍ້ມູນ (ຮູບທີ່ 2 ທີ່ຍ້າຍມາໄວ້ເທິງລາຍການສິນຄ້າ)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.indigo.shade100),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                                child: const Icon(Icons.shopping_bag_outlined, color: Colors.green, size: 18),
                              ),
                              const SizedBox(width: 8),
                              const Text('ສິນຄ້າທັງໝົດ', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('$totalProducts', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.indigo.shade100),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ສະຖານະສິນຄ້າ', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ພ້ອມສົ່ງ: $readyStockCount', style: const TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.bold, fontSize: 11)),
                              Text('Pre-order: $preOrderCount', style: const TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: totalProducts == 0 ? 0 : readyStockCount / totalProducts,
                              backgroundColor: Colors.orange.shade100,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF047857)),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ລາຍການສິນຄ້າ ແລະ ຕົວກອງ
              const Text('ລາຍການສິນຄ້າທັງໝົດ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
              const SizedBox(height: 10),

              // Filter Tab
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.indigo.shade100)),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _filterMainTab = 'ພ້ອມສົ່ງ'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: _filterMainTab == 'ພ້ອມສົ່ງ' ? const Color(0xFF6366F1) : Colors.transparent, borderRadius: BorderRadius.circular(14)),
                          child: Text('ພ້ອມສົ່ງ', style: TextStyle(color: _filterMainTab == 'ພ້ອມສົ່ງ' ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _filterMainTab = 'Pre-order'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: _filterMainTab == 'Pre-order' ? const Color(0xFF6366F1) : Colors.transparent, borderRadius: BorderRadius.circular(14)),
                          child: Text('Pre-order', style: TextStyle(color: _filterMainTab == 'Pre-order' ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Search bar
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'ຄົ້ນຫາຊື່ສິນຄ້າ...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.indigo.shade100)),
                ),
              ),
              const SizedBox(height: 12),

              // ListView
              filteredList.isEmpty
                  ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('ບໍ່ພົບລາຍການສິນຄ້າ', style: TextStyle(color: Colors.grey))))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.indigo.shade100),
                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                                child: const Icon(Icons.image, color: Colors.grey),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(item['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: item['statusText'] == 'ພ້ອມສົ່ງ' ? const Color(0xFF047857) : const Color(0xFFD97706),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(item['statusText'], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text('${item['category']}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item['statusText'] == 'ພ້ອມສົ່ງ' ? '📦 ${item['stock']} ${item['unit']}' : '🔥 Pre-order', style: TextStyle(color: Colors.grey.shade700, fontSize: 11)),
                                        Text('ຂາຍ: ${item['price']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF4338CA))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
// ==============================================================================
// 🔴 [TAIL] ສິ້ນສຸດ: InventoryView Widget
// ==============================================================================
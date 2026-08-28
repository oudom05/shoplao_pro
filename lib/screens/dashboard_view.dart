import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // ສີພື້ນຫຼັງຂອງໜ້າຈໍ
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. ສ່ວນຫົວຂອງໜ້າ (Header Section)
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // ຮູບໂປຣໄຟລ໌ຂອງຜູ້ໃຊ້
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
                        ),
                      ),
                      const SizedBox(width: 12),
                      // ຊື່ຮ້ານ ຫຼື ຊື່ຫົວຂໍ້ລະບົບ
                      const Text(
                        'ຄຸ້ມຄອງການຂາຍ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                    ],
                  ),
                  // ປຸ່ມແຈ້ງເຕືອນ (Notification Bell)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined, size: 26),
                    color: Colors.black54,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ==========================================
              // 2. ສ່ວນຊ່ອງຄົ້ນຫາ ແລະ ປຸ່ມ Filter (Search & Filter Section)
              // ==========================================
              Row(
                children: [
                  // ຊ່ອງປ້ອນຄຳຄົ້ນຫາຊື່ລູກຄ້າ ຫຼື ສິນຄ້າ
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'ຄົ້ນຫາຊື່ລູກຄ້າ ຫຼື ສິນຄ້າ...',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          icon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // ປຸ່ມກອງຂໍ້ມູນຂັ້ນສູງ (Filter Button)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.tune, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ==========================================
              // 3. ສ່ວນປຸ່ມກອງປະເພດດ່ວນ (Quick Filter Chips)
              // ==========================================
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('ປະເພດ', Icons.category_outlined, true),
                    const SizedBox(width: 8),
                    _buildFilterChip('ຫົວໜ່ວຍ', Icons.inventory_2_outlined, false),
                    const SizedBox(width: 8),
                    _buildFilterChip('ມັດຈຳ', Icons.payments_outlined, false),
                    const SizedBox(width: 8),
                    _buildFilterChip('ວັນທີ', Icons.calendar_today_outlined, false),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ==========================================
              // 4. ສ່ວນສະແດງລາຍການອໍເດີ (Order Items List Cards)
              // ==========================================
              // ລາຍການທີ 1: ສະຖານະ "ຈ່າຍແລ້ວ"
              _buildOrderCard(
                productName: 'ສິນຄ້າ: ໄອໂຟນ 15 Pro',
                customerName: 'ລູກຄ້າ: ທ. ສົມສະຫວັດ',
                category: 'ເອເລັກໂຕຣນິກ',
                unit: '1 ເຄື່ອງ',
                depositText: '5,000,000 ₭',
                statusText: 'ຈ່າຍແລ້ວ',
                statusColor: Colors.green,
                statusBgColor: Colors.green.shade50,
                showEditDeleteButtons: true,
              ),
              const SizedBox(height: 16),

              // ລາຍການທີ 2: ສະຖານະ "ລໍຖ້າຈ່າຍ"
              _buildOrderCard(
                productName: 'ສິນຄ້າ: ໂນດບຸກ Dell XPS',
                customerName: 'ລູກຄ້າ: ນ. ມະນີວັນ',
                category: 'ຄອມພິວເຕີ',
                unit: '2 ເຄື່ອງ',
                depositText: '12,000,000 ₭ (ຍັງເຫຼືອ)',
                statusText: 'ລໍຖ້າຈ່າຍ',
                statusColor: Colors.orange.shade800,
                statusBgColor: Colors.orange.shade50,
                isPending: true,
              ),
              const SizedBox(height: 16),

              // ລາຍການທີ 3: ສະຖານະ "ຍົກເລີກ"
              _buildOrderCard(
                productName: 'ສິນຄ້າ: ໂຕະເຣັດວຽກ ໄມ້ແທ້',
                customerName: 'ລູກຄ້າ: ບໍລິສັດ ເອັກຊີ',
                category: 'เฟີນິເຈີ',
                unit: '5 ຊຸດ',
                depositText: '0 ₭ (ສົ່ງຄືນແລ້ວ)',
                statusText: 'ຍົກເລີກ',
                statusColor: Colors.red,
                statusBgColor: Colors.red.shade50,
                showEditDeleteButtons: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget ຍ່ອຍສຳລັບປຸ່ມ Filter Chip ---
  Widget _buildFilterChip(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : Colors.black54,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget ຍ່ອຍສຳລັບ Card ສະແດງຂໍ້ມູນອໍເດີແຕ່ລະລາຍການ ---
  Widget _buildOrderCard({
    required String productName,
    required String customerName,
    required String category,
    required String unit,
    required String depositText,
    required String statusText,
    required Color statusColor,
    required Color statusBgColor,
    bool showEditDeleteButtons = false,
    bool isPending = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ຫົວຂໍ້ສິນຄ້າ ແລະ ສະຖານະ (Status Badge)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                productName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1B4B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // ຊື່ລູກຄ້າ
          Text(
            customerName,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 12),

          // กล่องສະແດງປະເພດ ແລະ ຫົວໜ່ວຍ (Category & Unit Boxes)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ປະເພດ', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      Text(category, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ຫົວໜ່ວຍ', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      Text(unit, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // ສ່ວນສະແດງມັດຈຳ ແລະ ປຸ່ມຈັດການ (Actions: Edit/Delete)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ມັດຈຳ', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  Text(
                    depositText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF4338CA),
                    ),
                  ),
                ],
              ),
              // ປຸ່ມແກ້ໄຂ ຫຼື ລຶບ ຕາມເງື່ອນໄຂຂອງແຕ່ລະອໍເດີ
              if (showEditDeleteButtons)
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined, color: Color(0xFF4338CA), size: 20),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    ),
                  ],
                )
              else if (isPending)
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 14),
                  label: const Text('ແກ້ໄຂ'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4338CA),
                    side: const BorderSide(color: Color(0xFF4338CA)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
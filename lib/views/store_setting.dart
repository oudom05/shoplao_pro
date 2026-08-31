import 'package:flutter/material.dart';

class StoreSettingView extends StatefulWidget {
  const StoreSettingView({Key? key}) : super(key: key);

  @override
  State<StoreSettingView> createState() => _StoreSettingViewState();
}

class _StoreSettingViewState extends State<StoreSettingView> {
  late final TextEditingController _shopNameController;
  late final TextEditingController _whatsappController;

  @override
  void initState() {
    super.initState();
    _shopNameController = TextEditingController(text: 'ຮ້ານຄ້າຍຸກໃໝ່ 2024');
    _whatsappController = TextEditingController(text: '+856 20 5555 9999');
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF3525cd);
    final Color onPrimary = const Color(0xFFffffff);
    final Color surfaceColor = const Color(0xFFf8f9ff);
    final Color surfaceContainerLowest = const Color(0xFFffffff);
    final Color surfaceContainer = const Color(0xFFe5eeff);
    final Color surfaceVariant = const Color(0xFFd3e4fe);
    final Color onSurface = const Color(0xFF0b1c30);
    final Color onSurfaceVariant = const Color(0xFF464555);
    final Color outlineVariant = const Color(0xFFc7c4d8);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: surfaceContainerLowest,
        elevation: 0,
        toolbarHeight: 64,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: surfaceVariant,
              border: Border.all(color: outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDZjbd0wZXZG9mmmw1dXWVXjJaGal9F7vP2cd34-ckjvxfx99lYpbT1b1uf2OtihtjXT2elLu7gj57Np6eGOPuZ3umCNntyWrqMDMG6CKLHmwmv6PV3JxDMtthev62-fPiTWR_SR-Ev8ltcE7KG6HHB71DaBUMQrWdKaDSNz8zDYgBAHK79c_kiOfwNThvhCHXq1Uy-3j7wYuzz0CQMKHl-tnmvpW5vvnbxMUF9cHZYC7fVVB_IooZniA',
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          'ຄຸ້ມຄອງການຂາຍ',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined, color: onSurfaceVariant),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        // ເພີ່ມ padding ດ້ານລຸ່ມ ເພື່ອບໍ່ໃຫ້เนื้อหาຖືກ Navigaton ຫຼັກบัง
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 100.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ໜ້າຕັ້ງຄ່າ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ຈັດການຂໍ້ມູນ ແລະ ການຕັ້ງຄ່າຮ້ານຂອງທ່ານ',
                  style: TextStyle(fontSize: 14, color: onSurfaceVariant),
                ),
                const SizedBox(height: 24),

                // Profile Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9999),
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBypNRb2R8BIodTsz2DsQQcXk8QEyHR7XrHmGD7B6SYBwh54vJbnW0h4XybENct2BGLS0lW5HlVE7zZZoZjNCVz7WUEmOPJR4e5kJVsOpgLve9HfJtTQs8bR8k4StunX3zgI4mWcK8PkP3lMewuWhtOaG2O_IrZkCEsAEFwyiE2Vs1urqDj-khTfu8wpNIMHfGyOw0tsXiMwK75nOnr-qFRe7kiDntB_45eQoHVcoW8Tr6ZjVRavhX6Bw',
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: surfaceContainerLowest,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ຮ້ານຄ້າຍຸກໃໝ່ 2024',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ID: SH-892401',
                              style: TextStyle(
                                fontSize: 14,
                                color: onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Update Form Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      label: 'ຊື່ຮ້ານ',
                      controller: _shopNameController,
                      icon: Icons.storefront,
                      primaryColor: primaryColor,
                      surfaceContainerLowest: surfaceContainerLowest,
                      outlineVariant: outlineVariant,
                      onSurface: onSurface,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'ເບີ WhatsApp ຂອງຮ້ານ',
                      controller: _whatsappController,
                      icon: Icons.phone_in_talk,
                      keyboardType: TextInputType.phone,
                      primaryColor: primaryColor,
                      surfaceContainerLowest: surfaceContainerLowest,
                      outlineVariant: outlineVariant,
                      onSurface: onSurface,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Settings List
                Container(
                  decoration: BoxDecoration(
                    color: surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: outlineVariant.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.payments,
                        title: 'ຊ່ອງທາງການຈ່າຍເງິນ',
                        surfaceContainer: surfaceContainer,
                        primaryColor: primaryColor,
                        onSurface: onSurface,
                        outlineVariant: outlineVariant,
                        showBorder: true,
                        onTap: () {},
                      ),
                      _buildSettingsTile(
                        icon: Icons.local_shipping,
                        title: 'ຕັ້ງຄ່າການຈັດສົ່ງ',
                        surfaceContainer: surfaceContainer,
                        primaryColor: primaryColor,
                        onSurface: onSurface,
                        outlineVariant: outlineVariant,
                        showBorder: true,
                        onTap: () {},
                      ),
                      _buildSettingsTile(
                        icon: Icons.help,
                        title: 'ຊ່ວຍເຫຼືອ ແລະ ຕິດຕໍ່',
                        surfaceContainer: surfaceContainer,
                        primaryColor: primaryColor,
                        onSurface: onSurface,
                        outlineVariant: outlineVariant,
                        showBorder: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Save Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.save, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'ບັນທຶກ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // ➔ ໄດ້ລຶບ bottomNavigationBar ອອກຈາກບ່ອນນີ້ແລ້ວ ເພື່ອບໍ່ໃຫ້ມັນຊ້ອນກັນ
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required Color primaryColor,
    required Color surfaceContainerLowest,
    required Color outlineVariant,
    required Color onSurface,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 16, color: onSurface),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: outlineVariant),
            filled: true,
            fillColor: surfaceContainerLowest,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Color surfaceContainer,
    required Color primaryColor,
    required Color onSurface,
    required Color outlineVariant,
    required bool showBorder,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(bottom: BorderSide(color: outlineVariant.withOpacity(0.3)))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: onSurface,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: outlineVariant),
          ],
        ),
      ),
    );
  }
}
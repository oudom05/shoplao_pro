import 'package:flutter/material.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // กำหนดสีตาม Tailwind config ທີ່ໃຫ້ມາ
    final Color primaryColor = const Color(0xFF3525cd);
    final Color primaryContainer = const Color(0xFF4f46e5);
    final Color primaryFixedDim = const Color(0xFFc3c0ff);
    final Color secondaryColor = const Color(0xFF006c49);
    final Color secondaryContainer = const Color(0xFF6cf8bb);
    final Color tertiaryColor = const Color(0xFF684000);
    final Color surfaceColor = const Color(0xFFf8f9ff);
    final Color surfaceContainerLowest = const Color(0xFFffffff);
    final Color surfaceContainer = const Color(0xFFe5eeff);
    final Color onSurface = const Color(0xFF0b1c30);
    final Color onSurfaceVariant = const Color(0xFF464555);
    final Color outlineVariant = const Color(0xFFc7c4d8);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        toolbarHeight: 64,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9999),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAI2eTLYucfk5wByxrontcNMsewXmgG0p5USBp1oDoOBMu4vHGJWWyODneBBQtGAgP9Rm11aLqvVYxppXBNGJ385ccOR1ulEUnxHGFoFwvHPq_Y3WyahzOICBi93wOUsJIxZPzrGq9ClJWeCLxh1r_ZLZDNSnOZJTIAY4PLQpQ71ugA2hcyAjmuyvkMATamXNwKQeqWL1kxyzjgcORcsaJ8QUf-0mpc-NQfRhTcUnc8CWMl8TB2tlkp2g',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'ຄຸ້ມຄອງການຂາຍ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Title & Date Filter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ໜ້າວິເຄາະ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: onSurface,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(color: outlineVariant),
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
                          Icon(Icons.calendar_today, size: 16, color: onSurface),
                          const SizedBox(width: 8),
                          Text(
                            'ເດືອນນີ້',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: onSurface,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, size: 18, color: onSurface),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Summary Cards (Bento Grid Style)
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isDesktop = constraints.maxWidth >= 768;
                    if (isDesktop) {
                      return Row(
                        children: [
                          Expanded(flex: 2,child: _buildTotalRevenueCard(surfaceContainerLowest, outlineVariant, onSurfaceVariant, primaryColor, secondaryColor)),
                          const SizedBox(width: 16),
                          Expanded(flex: 1,child: _buildTotalOrdersCard(surfaceContainerLowest, outlineVariant, secondaryContainer, onSurfaceVariant, onSurface)),
                          const SizedBox(width: 16),
                          Expanded(flex: 1,child: _buildProductStatusCard(surfaceContainerLowest, outlineVariant, onSurfaceVariant, primaryColor, tertiaryColor)),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildTotalRevenueCard(surfaceContainerLowest, outlineVariant, onSurfaceVariant, primaryColor, secondaryColor),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildTotalOrdersCard(surfaceContainerLowest, outlineVariant, secondaryContainer, onSurfaceVariant, onSurface)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildProductStatusCard(surfaceContainerLowest, outlineVariant, onSurfaceVariant, primaryColor, tertiaryColor)),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Key Highlights & Image Section
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isDesktop = constraints.maxWidth >= 768;
                    if (isDesktop) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 8,
                            child: _buildKeyHighlightsCard(surfaceContainerLowest, outlineVariant, onSurface, onSurfaceVariant, surfaceContainer, primaryColor, secondaryColor, secondaryContainer),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 4,
                            child: _buildDecorativeImageCard(outlineVariant),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildKeyHighlightsCard(surfaceContainerLowest, outlineVariant, onSurface, onSurfaceVariant, surfaceContainer, primaryColor, secondaryColor, secondaryContainer),
                          const SizedBox(height: 16),
                          _buildDecorativeImageCard(outlineVariant),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 80), // Space for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget: Total Revenue Card
  Widget _buildTotalRevenueCard(Color bg, Color outline, Color variantColor, Color primary, Color secondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: outline.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ລາຍຮັບທັງໝົດ', style: TextStyle(fontSize: 15, color: variantColor)),
                  const SizedBox(height: 4),
                  Text('₭ 45,000,000', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primary)),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: primary.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.payments, color: primary),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.trending_up, size: 16, color: secondary),
              const SizedBox(width: 6),
              Text('+15% ຈາກເດືອນກ່ອນ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: secondary)),
            ],
          ),
        ],
      ),
    );
  }

  // Widget: Total Orders Card
  Widget _buildTotalOrdersCard(Color bg, Color outline, Color secContainer, Color variantColor, Color onSurface) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: outline.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: secContainer.withOpacity(0.3), shape: BoxShape.circle),
            child: const Icon(Icons.local_mall, size: 16, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Text('ອໍເດີ້ທັງໝົດ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: variantColor)),
          const SizedBox(height: 4),
          Text('342', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: onSurface)),
        ],
      ),
    );
  }

  // Widget: Product Status Card (Pre-order vs Ready)
  Widget _buildProductStatusCard(Color bg, Color outline, Color variantColor, Color primary, Color tertiary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: outline.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('ສະຖານະສິນຄ້າ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: variantColor)),
          const SizedBox(height: 12),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ພ້ອມສົ່ງ (70%)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: primary)),
                  Text('Pre-order (30%)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: tertiary)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: Row(
                  children: [
                    Expanded(flex: 7, child: Container(height: 8, color: primary)),
                    Expanded(flex: 3, child: Container(height: 8, color: tertiary)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget: Key Highlights Card
  Widget _buildKeyHighlightsCard(Color bg, Color outline, Color onSurface, Color variantColor, Color surfaceContainer, Color primary, Color secondary, Color secContainer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: outline.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ຍອດຂາຍທັງໝົດ ແລະ ຍອດກຳໄລຫັກຕົ້ນທືນແລ້ວ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: onSurface)),
          const SizedBox(height: 24),
          // Sales Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ຍອດຂາຍທັງໝົດ (Total Sales)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: variantColor)),
                      const SizedBox(height: 4),
                      Text('₭ 45,000,000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: onSurface)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: secContainer.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                    child: Text('ເປົ້າໝາຍ: ₭ 50M', style: TextStyle(fontSize: 12, color: secondary)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: Container(
                  height: 12,
                  color: surfaceContainer,
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Container(
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Profit Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ຍອດກຳໄລ (Net Profit)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: variantColor)),
                      const SizedBox(height: 4),
                      Text('₭ 18,500,000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: secondary)),
                    ],
                  ),
                  Text('41% Margin', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: variantColor)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: Container(
                  height: 12,
                  color: surfaceContainer,
                  child: FractionallySizedBox(
                    widthFactor: 0.41,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: secondary,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget: Decorative Image Card
  Widget _buildDecorativeImageCard(Color outline) {
    return Container(
      constraints: const BoxConstraints(minHeight: 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: outline.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDjdb2h89bAwjcKRLVuToM38QX7qg8ubX6dqHSBF8Rfsk3rqm5jKxnUEzI4fs5ivKLDiNPBDn0f60t-rwlZfkSzfbanFEE0rZSuDHzHXBhINaiU19-sCzLm7a3viOuqdNm3pfMXI6Pkd4DMrDdwU-wq2l74vxZoVWiPQoIY41SFIuFwe9XQCL530rU2NhPoO1n-IxyG5fgvxkWtukaI_Vlb7QvvL7WgKZOwIOcv4WCZ2KA0ETh7qjxrxA',
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF213145).withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ສະຫຼຸບປະຈຳເດືອນ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ການເຕີບໂຕຂອງທຸລະກິດຢູ່ໃນເກນດີຫຼາຍ. ຮັກສາລະດັບການຂາຍນີ້ໄວ້.',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
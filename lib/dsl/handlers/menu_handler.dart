import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../models/dsl_handler.dart';
import '../models/dsl_message.dart';
import '../models/dsl_render_result.dart';

class MenuDSLHandler extends DSLHandler {
  @override
  String get type => 'menu';

  @override
  int get version => 1;

  @override
  DSLRenderResult render(Event event, DSLMessage msg) {
    final title = msg.get<String>('title') ?? 'Menu';
    final items = msg.get<List>('items') ?? [];
    return DSLRenderResult(
      widget: MenuWidget(title: title, items: items),
    );
  }
}

// ---------------------------------------------------------------------------
// Menu widget — with cart
// ---------------------------------------------------------------------------

class MenuWidget extends StatefulWidget {
  final String title;
  final List items;
  final void Function(Map<String, int> cart)? onOrder;

  const MenuWidget({
    required this.title,
    required this.items,
    this.onOrder,
  });

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final Map<String, int> _cart = {};

  int get _totalItems => _cart.values.fold(0, (a, b) => a + b);

  int _totalPrice() {
    int total = 0;
    for (final item in widget.items) {
      final name = item['name']?.toString() ?? '';
      final price = int.tryParse(item['price']?.toString() ?? '0') ?? 0;
      total += (_cart[name] ?? 0) * price;
    }
    return total;
  }

  void _increment(String name) =>
      setState(() => _cart[name] = (_cart[name] ?? 0) + 1);

  void _decrement(String name) => setState(() {
        if ((_cart[name] ?? 0) > 0) {
          _cart[name] = _cart[name]! - 1;
          if (_cart[name] == 0) _cart.remove(name);
        }
      });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = const Color(0xFFD85A30);
    final bgCard = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final bgHeader = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFFAF7F5);
    final bgThumb = isDark ? const Color(0xFF3A2A20) : const Color(0xFFFEF3EE);
    final textPri = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSec = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6B6B6B);
    final divColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F2);

    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.07),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ───────────────────────────────────────────────
          Container(
            color: bgHeader,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: bgThumb,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('🍽️', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textPri,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.items.length} items available',
                        style: TextStyle(fontSize: 12, color: textSec),
                      ),
                    ],
                  ),
                ),
                // ── Cart badge ────────────────────────────────────
                if (_totalItems > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shopping_cart_outlined,
                            size: 13, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '$_totalItems',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          Divider(height: 1, thickness: 1, color: divColor),

          // ── Item list ─────────────────────────────────────────────
          ...widget.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final name = item['name']?.toString() ?? '';
            final price = item['price']?.toString() ?? '';
            final image = item['image']?.toString();
            final isLast = index == widget.items.length - 1;
            final qty = _cart[name] ?? 0;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10,
                  ),
                  child: Row(
                    children: [
                      // ── Thumbnail ──────────────────────────────
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 52, height: 52,
                          child: image != null && image.isNotEmpty
                              ? Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _Thumb(bg: bgThumb),
                                )
                              : _Thumb(bg: bgThumb),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // ── Name + Price ───────────────────────────
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textPri,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rs $price',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Quantity controls ──────────────────────
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (qty > 0) ...[
                            _QtyButton(
                              icon: Icons.remove,
                              onTap: () => _decrement(name),
                              accent: accent,
                              isDark: isDark,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$qty',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textPri,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          _QtyButton(
                            icon: Icons.add,
                            onTap: () => _increment(name),
                            accent: accent,
                            isDark: isDark,
                            filled: qty == 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1, thickness: 1,
                    color: divColor,
                    indent: 80, endIndent: 16,
                  ),
              ],
            );
          }),

          // ── Cart summary + Place Order ────────────────────────────
          if (_totalItems > 0) ...[
            Divider(height: 1, thickness: 1, color: divColor),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── Order summary ──────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_totalItems item${_totalItems > 1 ? 's' : ''}',
                        style: TextStyle(fontSize: 13, color: textSec),
                      ),
                      Text(
                        'Rs ${_totalPrice()}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Place Order button ─────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.onOrder != null) {
                           widget.onOrder!(_cart);  
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Place Order • Rs ${_totalPrice()}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quantity button
// ---------------------------------------------------------------------------

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;
  final bool isDark;
  final bool filled;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.accent,
    required this.isDark,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: filled ? accent : accent.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled ? Colors.white : accent,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Thumbnail placeholder
// ---------------------------------------------------------------------------

class _Thumb extends StatelessWidget {
  final Color bg;
  const _Thumb({required this.bg});

  @override
  Widget build(BuildContext context) => Container(
        color: bg,
        child: const Center(
          child: Text('🍴', style: TextStyle(fontSize: 20)),
        ),
      );
}


import 'package:flutter/cupertino.dart';
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
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),

          ...items.map((item) {
            final name = item['name'] ?? '';
            final price = item['price'] ?? '';
            final image = item['image'];

            return GestureDetector(
              onTap: () {
                // interaction handled via action layer later
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Row(
                  children: [
                    if (image != null)
                      Image.network(image, width: 50, height: 50),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name),
                          Text('Rs $price'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
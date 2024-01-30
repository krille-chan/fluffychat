import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import '../../../../widgets/avatar.dart';

class NoTracksPublishedTile extends StatelessWidget {
  final double? height;
  final User user;
  final Client client;

  const NoTracksPublishedTile({
    super.key,
    this.height,
    required this.user,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(
          4.0,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Avatar(
            mxContent: user.avatarUrl,
            name: user.displayName ?? '',
            size: 80,
            fontSize: 48,
            client: client,
          ),
          Positioned(
            left: 4.0,
            bottom: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(
                    Icons.mic_off,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    user.displayName.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
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

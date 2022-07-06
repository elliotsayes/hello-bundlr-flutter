import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class GenerateWalletLoading extends StatelessWidget {
  const GenerateWalletLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          const Text('Generating wallet...\r\n(may take several seconds)'),
          Expanded(
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoadingBouncingGrid.circle(
                  backgroundColor: Colors.cyan,
                  inverted: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

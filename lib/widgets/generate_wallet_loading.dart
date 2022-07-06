import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class GenerateWalletLoading extends StatelessWidget {
  final String durationEstimate = kIsWeb
      ? 'may take up to a minute on web'
      : 'should only take a few seconds';

  const GenerateWalletLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          Text('Generating wallet...\r\n($durationEstimate)'),
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

import 'package:flutter/material.dart';

import '../widgets/wallet_selector.dart';

class WalletSelectScreen extends StatelessWidget {
  const WalletSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Bundlr Demo'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Select wallet',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              const Expanded(
                child: WalletSelector(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

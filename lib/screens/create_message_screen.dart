import 'package:arweave/arweave.dart';
import 'package:flutter/material.dart';

class CreateMessageScreen extends StatelessWidget {
  final Wallet wallet;

  const CreateMessageScreen({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Bundlr Demo'),
      ),
      body: SafeArea(
        child: Center(
          child: Text('wallet: ${wallet.toString()}'),
        ),
      ),
    );
  }
}

import 'package:arweave/arweave.dart';
import 'package:flutter/material.dart';
import 'package:hello_bundlr/widgets/bundlr_form.dart';
import 'package:hello_bundlr/widgets/wallet_info.dart';

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: WalletInfo(wallet: wallet),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 40,
                ),
                child: BundlrForm(wallet: wallet),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

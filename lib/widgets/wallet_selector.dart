import 'dart:convert';
import 'dart:io';

import 'package:arweave/arweave.dart';
import 'package:arweave/utils.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hello_bundlr/widgets/generate_wallet_loading.dart';

import '../screens/create_message_screen.dart';

class WalletSelector extends StatefulWidget {
  const WalletSelector({
    Key? key,
  }) : super(key: key);

  @override
  State<WalletSelector> createState() => _WalletSelectorState();
}

class _WalletSelectorState extends State<WalletSelector> {
  late Future<Wallet?> walletFuture;

  @override
  void initState() {
    walletFuture = Future.value(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: walletFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const GenerateWalletLoading();
        } else {
          return Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: MaterialButton(
                  color: Theme.of(context).buttonTheme.colorScheme?.background,
                  onPressed: handleGenerateWallet,
                  child: const Text('Generate new wallet'),
                ),
              ),
              Center(
                child: MaterialButton(
                  color: Theme.of(context).buttonTheme.colorScheme?.background,
                  onPressed: handleSelectWallet,
                  child: const Text('Load wallet from file'),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Future<void> handleSelectWallet() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final String walletJson;
      if (kIsWeb) {
        walletJson = utf8.decode(result.files.single.bytes!);
      } else {
        final file = File(result.files.single.path!);
        walletJson = await file.readAsString();
      }

      final wallet = Wallet.fromJwk(json.decode(walletJson));
      navigateWithWallet(wallet);
    } else {
      // User canceled the picker
    }
  }

  Future<void> handleGenerateWallet() async {
    setState(() {
      if (kIsWeb) {
        walletFuture = RSA
            .generate(keyLength)
            .then((kp) => RSA.convertPrivateKeyToJWK(kp.privateKey))
            .then((jwk) => Wallet.fromJwk(jwk));
      } else {
        walletFuture = compute((_) async => Wallet.generate(), null);
      }
    });

    walletFuture.then((wallet) => navigateWithWallet(wallet!));
  }

  void navigateWithWallet(Wallet wallet) {
    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CreateMessageScreen(
          wallet: wallet,
        ),
      ));
    }
  }
}

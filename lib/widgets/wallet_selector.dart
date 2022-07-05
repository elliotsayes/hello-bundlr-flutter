import 'dart:convert';
import 'dart:io';

import 'package:arweave/arweave.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
          return const Padding(
            padding: EdgeInsets.all(50),
            child: FittedBox(
              child: FlutterLogo(),
            ),
          );
        } else {
          return Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: MaterialButton(
                  color: Theme.of(context).buttonTheme.colorScheme?.background,
                  onPressed: kIsWeb ? null : handleGenerateWallet,
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
      if (!kIsWeb) {
        walletFuture = compute((_) async => Wallet.generate(), null);
      } else {
        walletFuture = Wallet.generate();
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

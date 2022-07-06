import 'package:arweave/arweave.dart';
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';

class WalletInfo extends StatefulWidget {
  final Wallet wallet;

  const WalletInfo({Key? key, required this.wallet}) : super(key: key);

  @override
  State<WalletInfo> createState() => _WalletInfoState();
}

class _WalletInfoState extends State<WalletInfo> {
  late final Future<String> address;
  late final Future<String> owner;

  @override
  void initState() {
    address = widget.wallet.getAddress();
    owner = widget.wallet.getOwner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Wallet Info:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            loadingText('Address', address),
            loadingText('Owner', owner),
          ],
        ),
      ),
    );
  }

  Widget loadingText(String identifier, Future<String> valueFuture) {
    return FutureBuilder<String>(
      future: valueFuture,
      builder: (_, snap) {
        if (snap.hasData) {
          final val = (snap.data!.length > 100)
              ? snap.data!.characters.take(100) + '...'.characters
              : snap.data!;
          return Center(
            child: Text(
              '$identifier: $val',
            ),
          );
        } else {
          return Text('Loading $identifier...');
        }
      },
    );
  }
}

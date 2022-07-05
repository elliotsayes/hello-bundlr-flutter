import 'package:flutter/material.dart';
import 'package:hello_bundlr/screens/wallet_select_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bundlr Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WalletSelectScreen(),
    );
  }
}

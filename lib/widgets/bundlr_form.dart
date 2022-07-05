import 'dart:convert';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class BundlrForm extends StatefulWidget {
  final Arweave arweave = Arweave(useBundlr: true);
  final Wallet wallet;

  BundlrForm({Key? key, required this.wallet}) : super(key: key);

  @override
  State<BundlrForm> createState() => _BundlrFormState();
}

class _BundlrFormState extends State<BundlrForm> {
  final _formKey = GlobalKey<FormState>();
  var messageText = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: TextFormField(
              textAlignVertical: TextAlignVertical.top,
              onChanged: (value) => messageText = value,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: handleUpload,
              child: const Text('Upload to Bundlr'),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  void handleUpload() async {
    if (messageText.isEmpty) return;

    final dataItem = DataItem.withBlobData(
      owner: await widget.wallet.getOwner(),
      data: utf8.encode(
        messageText,
      ) as Uint8List,
    )
      ..addTag('App-Name', 'Hello-Bundlr-Flutter')
      ..addTag('Content-Type', 'text/plain');
    await dataItem.sign(widget.wallet);

    final blob = (await dataItem.asBinary()).toBytes();

    // await widget.arweave.transactions.post(dataItem);

    final resp = await widget.arweave.bundlr!.post(
      'tx/arweave',
      body: blob,
      headers: {"Content-Type": "application/octet-stream"},
    );
    print(resp.statusCode);
    print(resp.body);

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: RichText(
          text: TextSpan(children: [
            const TextSpan(text: 'Uploaded! Click to '),
            TextSpan(
              text: 'open on arweave.net',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(
                    Uri(
                      scheme: 'https',
                      host: 'arweave.net',
                      path: dataItem.id,
                    ),
                  );
                },
            )
          ]),
        ),
      ),
    );
  }
}

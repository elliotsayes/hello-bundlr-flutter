import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            textAlignVertical: TextAlignVertical.top,
            onChanged: (value) => messageText = value,
            maxLines: null,
            minLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: handleUpload,
              child: const Text('Upload to Bundlr'),
            ),
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  void handleUpload() async {
    if (messageText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Please enter some text to upload'),
        ),
      );
      return;
    }

    final rand = Random.secure();
    final dataItem = DataItem.withBlobData(
      owner: await widget.wallet.getOwner(),
      nonce: base64.encode(List<int>.generate(32, (i) => rand.nextInt(256))),
      data: utf8.encode(messageText) as Uint8List,
    )
      ..addTag('App-Name', 'Hello-Bundlr-Flutter')
      ..addTag('Content-Type', 'text/plain');
    await dataItem.sign(widget.wallet);

    final result =
        (await widget.arweave.transactions.upload(dataItem).toList()).last;

    if (result.isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: RichText(
            text: TextSpan(children: [
              const TextSpan(
                  text: 'Uploaded! Click to ',
                  style: TextStyle(color: Colors.white70)),
              TextSpan(
                text: 'open on arweave.net',
                style: TextStyle(color: Colors.blueGrey.shade200),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed...'),
        ),
      );
    }
  }
}

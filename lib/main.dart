import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Monitoramento',
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void getData() async {
    var headers = {
      'Content-Type': 'application/json',
      'Device-Token': '<TOKEN>'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.tago.io/data?variable=temperature&query=last_item'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(await response.stream.bytesToString());

      var temp = jsonResponse['result'][0]['value'];

      setState(() {
        _counter = temp;
      });
    } else {
      setState(() {
        _counter = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Temperatura atual',
            ),
            Text(
              '$_counter° C',
              style: Theme.of(context).textTheme.headline2,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getData,
        tooltip: 'Atualizar',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

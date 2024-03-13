import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wakelock',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Wakelock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _disabled = false;
  var _err;
  _enable(bool ok) async {
    setState(() {
      _disabled = true;
      _err = null;
    });
    try {
      await (ok ? Wakelock.enable() : Wakelock.disable());
      setState(() {
        _disabled = false;
      });
    } catch (e) {
      setState(() {
        _err = e;
        _disabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          TextButton(
            onPressed: _disabled ? null : () => _enable(true),
            child: const Text('enable wakelock'),
          ),
          TextButton(
            onPressed: _disabled ? null : () => _enable(false),
            child: const Text('disable wakelock'),
          ),
          _err == null
              ? Container()
              : Container(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Wrap(
                    children: [
                      Text(
                        "$_err",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ),
          FutureBuilder(
            future: Wakelock.enabled,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              final data = snapshot.data;
              if (data == null) {
                return Container();
              }
              return Text('The wakelock is currently '
                  '${data ? 'enabled' : 'disabled'}.');
            },
          ),
        ],
      ),
    );
  }
}

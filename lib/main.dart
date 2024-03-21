import 'package:flutter/material.dart';
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
  TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  dynamic _err;
  bool enabled = false;
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    try {
      await Wakelock.enable();
      final ok = await Wakelock.enabled;
      setState(() {
        enabled = ok;
      });
    } catch (e) {
      setState(() {
        _err = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_err != null) {
          return true;
        }
        final yes = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("quit"),
              content: SingleChildScrollView(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Enter 123 to confirm quit",
                  ),
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  controller: controller,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                  onPressed: () => Navigator.of(context)
                      .pop(controller.text.trim() == '123'),
                ),
                TextButton(
                  child:
                      Text(MaterialLocalizations.of(context).closeButtonLabel),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            );
          },
        );
        return yes ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: ListView(
          children: [
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
            Text('The wakelock is currently '
                '${enabled ? 'enabled' : 'disabled'}.'),
          ],
        ),
      ),
    );
  }
}

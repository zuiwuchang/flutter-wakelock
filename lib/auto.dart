import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class MyAutoPage extends StatefulWidget {
  const MyAutoPage({
    super.key,
  });

  @override
  State<MyAutoPage> createState() => _MyAutoPageState();
}

class _MyAutoPageState extends State<MyAutoPage> {
  TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
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
          title: const Text("Wakelock auto"),
        ),
        body: ListView(
          children: [
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
      ),
    );
  }
}

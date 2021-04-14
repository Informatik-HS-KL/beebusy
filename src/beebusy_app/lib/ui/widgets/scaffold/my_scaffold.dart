import 'package:beebusy_app/ui/widgets/scaffold/my_appbar.dart';
import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    @required this.body,
    this.showActions = false,
  });

  final Widget body;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        showActions: showActions,
      ),
      body: body,
    );
  }
}

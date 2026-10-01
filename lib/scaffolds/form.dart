import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config.dart';

class FormScaffold extends StatefulWidget {
  final Widget body;
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  const FormScaffold({
    super.key,
    required this.body,
    this.title,
    this.leading,
    this.actions,
  });

  @override
  State<FormScaffold> createState() => _FormScaffoldState();
}

class _FormScaffoldState extends State<FormScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(config.defaultPadding),
        child: widget.body,
      ),
      appBar: AppBar(
        title: Text(widget.title ?? config.appTitle),
        leading: !context.canPop()
            ? null
            : widget.leading ??
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
        actions: widget.actions,
      ),
    );
  }
}

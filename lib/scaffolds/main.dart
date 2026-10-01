import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config.dart';

class MainScaffold extends StatefulWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final FloatingActionButton? floatingActionButton;
  final Drawer? drawer;
  final NavigationBar? bottomNavigationBar;

  const MainScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    final List<ListTile> drawerListTiles = [
      ListTile(
        title: Text('Tasks'),
        onTap: () {
          context.pushNamed('task.index');
        },
      ),
    ];

    return Scaffold(
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButton: widget.floatingActionButton,
      body: Padding(
        padding: EdgeInsetsGeometry.all(config.defaultPadding),
        child: widget.body,
      ),
      appBar: AppBar(
        title: Text(widget.title ?? config.appTitle),
        actions: widget.actions ?? [],
      ),
      drawer:
          widget.drawer ??
          Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Row(
                      children: [
                        Text(
                          config.appTitle,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/pexels-adit-syahfiar-991235-39579441.jpg',
                        ),
                        opacity: 0.25,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ...drawerListTiles,
                  Spacer(),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Sign out'),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

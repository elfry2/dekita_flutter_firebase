import 'package:dekita_flutter_firebase/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

import 'middleware.dart';

class IfNotLoggedInShowLoginPage extends Middleware {
  final String redirectRouteName;
  const IfNotLoggedInShowLoginPage(
    super.child, {
    super.key,
    this.redirectRouteName = 'login',
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LoginPage();

        return super.child;
      },
    );
  }
}

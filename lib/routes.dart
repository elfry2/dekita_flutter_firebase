import 'package:dekita_flutter_firebase/middlewares/If_not_logged_in_show_login_page.dart';
import 'package:dekita_flutter_firebase/pages/login.dart';
import 'package:dekita_flutter_firebase/scaffolds/main.dart';
import 'package:dekita_flutter_firebase/Pages/tasks/create.dart';
import 'package:go_router/go_router.dart';

import 'pages/tasks/edit.dart';
import 'pages/tasks/index.dart';

const _home = 'task.index';

final List<GoRoute> routes = [
  GoRoute(
    name: 'home',
    path: '/',
    redirect: (context, state) => state.namedLocation(_home),
  ),
  GoRoute(
    name: 'login',
    path: '/sign-in',
    builder: (context, state) => LoginPage(),
  ),
  GoRoute(
    name: 'task.index',
    path: '/tasks',
    builder: (context, state) => IfNotLoggedInShowLoginPage(TaskIndexPage()),
  ),
  GoRoute(
    name: 'task.create',
    path: '/tasks/create',
    builder: (context, state) => IfNotLoggedInShowLoginPage(TaskCreationPage()),
  ),
  GoRoute(
    name: 'task.edit',
    path: '/tasks/edit/:id',
    builder: (context, state) => IfNotLoggedInShowLoginPage(
      TaskModificationPage(documentId: state.pathParameters['id']!),
    ),
  ),
];

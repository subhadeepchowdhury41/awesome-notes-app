import 'package:demo_frontend/routes/router_info.dart';
import 'package:flutter/material.dart';

class AppRouterParser extends RouteInformationParser<AppRouterInfo> {
  @override
  RouteInformation? restoreRouteInformation(AppRouterInfo configuration) {
    if (configuration.isUnknown()) {
      return RouteInformation(uri: Uri.parse('/404'));
    } else if (configuration.isHome()) {
      return RouteInformation(uri: Uri.parse('/'));
    } else if (configuration.isLogin()) {
      return RouteInformation(uri: Uri.parse('/login'));
    } else if (configuration.isRegister()) {
      return RouteInformation(uri: Uri.parse('/register'));
    } else if (configuration.isNoteCreate()) {
      return RouteInformation(uri: Uri.parse('/notes/create'));
    } else if (configuration.isNote()) {
      return RouteInformation(uri: Uri.parse('/notes/${configuration.id}'));
    } else if (configuration.isNoteEdit()) {
      return RouteInformation(
          uri: Uri.parse('/notes/${configuration.id}/edit'));
    } else if (configuration.isProfile()) {
      return RouteInformation(uri: Uri.parse('/profile'));
    } else if (configuration.isProfileEdit()) {
      return RouteInformation(uri: Uri.parse('/profile/edit'));
    }
    return super.restoreRouteInformation(configuration);
  }

  @override
  Future<AppRouterInfo> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.uri.path == '/') {
      return AppRouterInfo.home();
    } else if (routeInformation.uri.path == '/login') {
      return AppRouterInfo.login();
    } else if (routeInformation.uri.path == '/register') {
      return AppRouterInfo.register();
    } else if (routeInformation.uri.path == '/notes/create') {
      return AppRouterInfo.noteCreate();
    } else if (routeInformation.uri.pathSegments.length == 2 &&
        routeInformation.uri.pathSegments[0] == 'notes') {
      return AppRouterInfo.note(routeInformation.uri.pathSegments[1]);
    } else if (routeInformation.uri.pathSegments.length == 3 &&
        routeInformation.uri.pathSegments[0] == 'notes' &&
        routeInformation.uri.pathSegments[2] == 'edit') {
      return AppRouterInfo.noteEdit(routeInformation.uri.pathSegments[1]);
    } else if (routeInformation.uri.path == '/profile') {
      return AppRouterInfo.profile();
    } else if (routeInformation.uri.path == '/profile/edit') {
      return AppRouterInfo.profileEdit();
    }
    return super.parseRouteInformation(routeInformation);
  }
}

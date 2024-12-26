import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

void navigate(String routeName, {Object? params}) {
  navigationKey.currentState?.pushNamed(routeName, arguments: params);
}

void goBack() {
  navigationKey.currentState?.pop();
}

import 'package:demo_frontend/routes/router_delegate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routeProvider =
    Provider<AppRouterDelegate>((ref) => AppRouterDelegate(ref: ref));

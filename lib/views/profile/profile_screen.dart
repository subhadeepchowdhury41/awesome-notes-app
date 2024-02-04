import 'package:demo_frontend/providers/auth_provider.dart';
import 'package:demo_frontend/providers/user_provider.dart';
import 'package:demo_frontend/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.pageController});
  final PageController? pageController;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  double _blur = 0;
  bool unmounted = false;
  @override
  void initState() {
    widget.pageController?.addListener(() {
      if (unmounted) return;
      setState(() {
        _blur = widget.pageController!.offset /
            widget.pageController!.position.maxScrollExtent;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    unmounted = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(_blur),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.normalSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 50 * _blur,
                  width: 50 * _blur,
                  child: const CircleAvatar(
                    child: Icon(Icons.person, size: 50),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      user!.name!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      '@${user.username!}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                          color: AppConstants.disabledColor),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 17),
                      SizedBox(width: 10),
                      Text('Sign Out'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

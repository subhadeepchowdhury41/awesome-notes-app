import 'package:demo_frontend/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).login(
                      username: 'admin',
                      password: 'admin',
                    );
              },
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _authService = AuthService();
  bool _authenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    setState(() => _authenticating = true);
    final success = await _authService.authenticate();
    if (!mounted) return;
    setState(() => _authenticating = false);
    if (success) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_rounded,
                size: 80, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text('Finance Tracker',
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Authentication required',
                style: TextStyle(color: theme.colorScheme.outline)),
            const SizedBox(height: 40),
            if (_authenticating)
              const CircularProgressIndicator()
            else
              FilledButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint_rounded),
                label: const Text('Authenticate'),
              ),
          ],
        ),
      ),
    );
  }
}

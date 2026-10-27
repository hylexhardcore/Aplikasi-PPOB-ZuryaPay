import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config.dart';

const gold = Color(0xFFE8BD4F);
const navy = Color(0xFF101722);
const panel = Color(0xFF202C3D);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(url: SupabaseConfig.url, anonKey: SupabaseConfig.anonKey);
  }
  runApp(const ZuryaPayApp());
}

class ZuryaPayApp extends StatelessWidget {
  const ZuryaPayApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'ZuryaPay',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: navy,
      colorScheme: ColorScheme.fromSeed(seedColor: gold, brightness: Brightness.dark),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: panel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    ),
    home: SupabaseConfig.isConfigured ? const AuthGate() : const SetupPage(),
  );
}

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          BrandMark(),
          SizedBox(height: 22),
          Text('Backend belum dikonfigurasi', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text('Buka lib/config.dart dan isi Project URL serta anon/publishable key Supabase. Lihat README.md untuk panduan.', textAlign: TextAlign.center),
        ]),
      ),
    ),
  );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<AuthState>(
    stream: Supabase.instance.client.auth.onAuthStateChange,
    builder: (context, snapshot) => Supabase.instance.client.auth.currentSession == null
      ? const LoginPage() : const DashboardPage(),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  bool hide = true;

  @override
  void dispose() { email.dispose(); password.dispose(); super.dispose(); }

  Future<void> login() async {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      showMsg(context, 'Isi email dan kata sandi.'); return;
    }
    setState(() => loading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email.text.trim(), password: password.text);
    } on AuthException catch (e) {
      if (mounted) showMsg(context, e.message);
    } catch (_) {
      if (mounted) showMsg(context, 'Login gagal. Periksa koneksi dan konfigurasi backend.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    title: 'Selamat datang', subtitle: 'Masuk ke akun ZuryaPay',
    child: Column(children: [
      TextField(controller: email, keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined))),
      const SizedBox(height: 14),
      TextField(controller: password, obscureText: hide,
        decoration: InputDecoration(labelText: 'Kata sandi', prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(icon: Icon(hide ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => hide = !hide)))),
      const SizedBox(height: 20),
      GoldButton(label: 'Login', loading: loading, onPressed: login),
      TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
        child: const Text('Belum punya akun? Daftar')),
    ]),
  );
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool loading = false;

  @override
  void dispose() { name.dispose(); email.dispose(); password.dispose(); confirm.dispose(); super.dispose(); }

  Future<void> register() async {
    if ([name.text, email.text, password.text, confirm.text].any((v) => v.trim().isEmpty)) {
      showMsg(context, 'Lengkapi semua kolom.'); return;
    }
    if (password.text.length < 8) {
      showMsg(context, 'Kata sandi minimal 8 karakter.'); return;
    }
    if (password.text != confirm.text) {
      showMsg(context, 'Konfirmasi kata sandi tidak sama.'); return;
    }
    setState(() => loading = true);
    try {
      final result = await Supabase.instance.client.auth.signUp(
        email: email.text.trim(),
        password: password.text,
        data: {'full_name': name.text.trim()},
      );
      if (!mounted) return;
      showMsg(context, result.session == null
        ? 'Akun dibuat. Periksa email untuk verifikasi, lalu login.'
        : 'Pendaftaran berhasil!');
      Navigator.pop(context);
    } on AuthException catch (e) {
      if (mounted) showMsg(context, e.message);
    } catch (_) {
      if (mounted) showMsg(context, 'Daftar gagal. Periksa koneksi dan konfigurasi backend.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    title: 'Buat akun', subtitle: 'Daftar akun ZuryaPay',
    child: Column(children: [
      TextField(controller: name, decoration: const InputDecoration(labelText: 'Nama lengkap', prefixIcon: Icon(Icons.person_outline))),
      const SizedBox(height: 12),
      TextField(controller: email, keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined))),
      const SizedBox(height: 12),
      TextField(controller: password, obscureText: true,
        decoration: const InputDecoration(labelText: 'Kata sandi (min. 8 karakter)', prefixIcon: Icon(Icons.lock_outline))),
      const SizedBox(height: 12),
      TextField(controller: confirm, obscureText: true,
        decoration: const InputDecoration(labelText: 'Konfirmasi kata sandi', prefixIcon: Icon(Icons.lock_reset))),
      const SizedBox(height: 20),
      GoldButton(label: 'Daftar', loading: loading, onPressed: register),
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Sudah punya akun? Login')),
    ]),
  );
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.userMetadata?['full_name'] as String?;
    return Scaffold(
      appBar: AppBar(title: const Text('ZuryaPay'), actions: [
        IconButton(tooltip: 'Keluar', icon: const Icon(Icons.logout),
          onPressed: () async => Supabase.instance.client.auth.signOut()),
      ]),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const BrandMark(),
        const SizedBox(height: 24),
        Text('Halo${name != null && name.isNotEmpty ? ', $name' : ''}!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(user?.email ?? ''),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18)),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('SALDO ZURYAPAY', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            Text('Rp0', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: gold)),
            SizedBox(height: 8),
            Text('Saldo ini hanya placeholder, belum berupa uang sungguhan.'),
          ]),
        ),
        const SizedBox(height: 16),
        const Text('Login berhasil. Backend autentikasi aktif.'),
      ]),
    );
  }
}

class AuthScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const AuthScaffold({super.key, required this.title, required this.subtitle, required this.child});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460), child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const BrandMark(),
          const SizedBox(height: 28),
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 24),
          child,
        ],
      )),
    ))),
  );
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});
  @override
  Widget build(BuildContext context) => Column(children: [
    Container(width: 64, height: 64, decoration: BoxDecoration(color: gold, borderRadius: BorderRadius.circular(20)),
      child: const Icon(Icons.account_balance_wallet_outlined, color: navy, size: 34)),
    const SizedBox(height: 10),
    const Text('ZuryaPay', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: gold)),
  ]);
}

class GoldButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;
  const GoldButton({super.key, required this.label, required this.loading, required this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(height: 50, child: FilledButton(
    onPressed: loading ? null : onPressed,
    style: FilledButton.styleFrom(backgroundColor: gold, foregroundColor: navy),
    child: loading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
      : Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  ));
}

void showMsg(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

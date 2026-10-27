import 'package:flutter/material.dart';

void main() {
  runApp(const ZuryaPayApp());
}

const gold = Color(0xFFE8BD4F);
const navy = Color(0xFF101722);
const panel = Color(0xFF202C3D);

class ZuryaPayApp extends StatelessWidget {
  const ZuryaPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZuryaPay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: navy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: panel,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Selamat datang',
      subtitle: 'Masuk ke akun ZuryaPay kamu',
      child: Column(
        children: [
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Kata sandi',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 20),
          GoldButton(
            label: 'Login',
            onPressed: () => showMessage(
              'Login belum terhubung ke backend. Ini masih starter UI.',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            ),
            child: const Text('Belum punya akun? Daftar'),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            ),
            child: const Text('Lihat pratinjau aplikasi'),
          ),
        ],
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Buat akun',
      subtitle: 'Daftar untuk mulai menggunakan ZuryaPay',
      child: Column(
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(
              labelText: 'Nama lengkap',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Nomor HP',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Kata sandi',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 20),
          GoldButton(
            label: 'Daftar',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Registrasi belum aktif. Backend dan validasi keamanan perlu dibuat.',
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sudah punya akun? Login'),
          ),
        ],
      ),
    );
  }
}

class AuthScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BrandMark(),
                  const SizedBox(height: 28),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 26),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: gold,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.bolt, color: navy, size: 32),
        ),
        const SizedBox(width: 12),
        const Text(
          'ZuryaPay',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const GoldButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: navy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final services = const [
    ServiceItem('E-Wallet', Icons.account_balance_wallet_outlined),
    ServiceItem('Paket Data', Icons.wifi),
    ServiceItem('Pulsa', Icons.phone_android),
    ServiceItem('PLN', Icons.bolt),
    ServiceItem('QRIS', Icons.qr_code_2),
    ServiceItem('Tagihan', Icons.receipt_long),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BrandMark(),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifikasi belum dihubungkan.')),
            ),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          _homeContent(),
          const HistoryPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() => selectedIndex = value);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Riwayat'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _homeContent() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF29384C), Color(0xFF182333)],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: gold.withValues(alpha: 0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('SALDO ANDA', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              const Text(
                'Rp 0',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pratinjau UI — bukan saldo uang sungguhan',
                style: TextStyle(fontSize: 11, color: Colors.white60),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: GoldButton(
                      label: 'Isi Saldo',
                      onPressed: () => _message(
                        'Top up akan diaktifkan setelah payment gateway terintegrasi.',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => selectedIndex = 1),
                      icon: const Icon(Icons.history),
                      label: const Text('Riwayat'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const Text(
          'Layanan Utama',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.18,
          ),
          itemBuilder: (context, index) {
            final service = services[index];
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _message(
                '${service.title}: perlu integrasi API penyedia sebelum transaksi aktif.',
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: panel,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(service.icon, color: gold, size: 30),
                    const SizedBox(height: 12),
                    Text(
                      service.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Lihat layanan',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Biaya admin akan ditampilkan sebelum konfirmasi transaksi.',
          style: TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class ServiceItem {
  final String title;
  final IconData icon;

  const ServiceItem(this.title, this.icon);
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long, color: gold, size: 56),
            SizedBox(height: 14),
            Text(
              'Belum ada transaksi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Riwayat nyata akan muncul setelah backend transaksi terhubung.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 38,
          backgroundColor: panel,
          child: Icon(Icons.person, color: gold, size: 40),
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text(
            'Pengguna ZuryaPay',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        const ListTile(
          leading: Icon(Icons.verified_user_outlined, color: gold),
          title: Text('Keamanan akun'),
          subtitle: Text('Pengaturan keamanan akan tersedia setelah backend siap'),
        ),
        const ListTile(
          leading: Icon(Icons.support_agent, color: gold),
          title: Text('Bantuan'),
          subtitle: Text('Informasi dukungan ZuryaPay'),
        ),
        const ListTile(
          leading: Icon(Icons.info_outline, color: gold),
          title: Text('Tentang ZuryaPay'),
          subtitle: Text('Versi awal'),
        ),
      ],
    );
  }
}

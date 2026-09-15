import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BusinessAppointmentManagerApp());
}

class ApiConfig {
  static const String baseUrl = 'http://localhost:5000/api';
}

class AppColors {
  static const Color primary = Color(0xFF00796B);
  static const Color primaryLight = Color(0xFF009688);
  static const Color background = Color(0xFFF4F7F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF263238);
  static const Color textMuted = Color(0xFF78909C);
  static const Color border = Color(0xFFE0E6E6);

  static const Color scheduled = Color(0xFF1E88E5);
  static const Color completed = Color(0xFF2E7D32);
  static const Color cancelled = Color(0xFFD32F2F);
}

class BusinessAppointmentManagerApp extends StatelessWidget {
  const BusinessAppointmentManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Business Appointment Manager',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.6,
            ),
          ),
          labelStyle: const TextStyle(color: AppColors.textMuted),
          prefixIconColor: AppColors.textMuted,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.border,
          thickness: 1,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: const {
        'Content-Type': 'application/json',
      },
    ),
  );

  Options _authOptions(String token) {
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> register({
    required String businessName,
    required String ownerName,
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/register',
      data: {
        'business_name': businessName,
        'owner_name': ownerName,
        'full_name': fullName,
        'email': email,
        'password': password,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<List<dynamic>> getClients(String token) async {
    final response = await _dio.get(
      '/clients',
      options: _authOptions(token),
    );

    return List<dynamic>.from(response.data);
  }

  Future<void> createClient({
    required String token,
    required String fullName,
    required String phone,
    required String email,
    required String notes,
  }) async {
    await _dio.post(
      '/clients',
      options: _authOptions(token),
      data: {
        'full_name': fullName,
        'phone': phone,
        'email': email,
        'notes': notes,
      },
    );
  }

  Future<void> updateClient({
    required String token,
    required int clientId,
    required String fullName,
    required String phone,
    required String email,
    required String notes,
  }) async {
    await _dio.patch(
      '/clients/$clientId',
      options: _authOptions(token),
      data: {
        'full_name': fullName,
        'phone': phone,
        'email': email,
        'notes': notes,
      },
    );
  }

  Future<List<dynamic>> getAppointments(String token) async {
    final response = await _dio.get(
      '/appointments',
      options: _authOptions(token),
    );

    return List<dynamic>.from(response.data);
  }

  Future<void> createAppointment({
    required String token,
    required int clientId,
    required String title,
    required String description,
    required String appointmentDate,
    required String startTime,
    required String endTime,
  }) async {
    await _dio.post(
      '/appointments',
      options: _authOptions(token),
      data: {
        'client_id': clientId,
        'title': title,
        'description': description,
        'appointment_date': appointmentDate,
        'start_time': startTime,
        'end_time': endTime,
      },
    );
  }

  Future<void> updateAppointmentStatus({
    required String token,
    required int appointmentId,
    required String status,
  }) async {
    await _dio.patch(
      '/appointments/$appointmentId/status',
      options: _authOptions(token),
      data: {
        'status': status,
      },
    );
  }

  Future<Map<String, dynamic>> getStatistics(String token) async {
    final response = await _dio.get(
      '/stats/overview',
      options: _authOptions(token),
    );

    return Map<String, dynamic>.from(response.data);
  }
}

final apiService = ApiService();

String getErrorMessage(
  Object error,
  String fallback,
) {
  if (error is DioException) {
    return error.response?.data?['message']?.toString() ?? fallback;
  }

  return fallback;
}

class AuthLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool showBackButton;

  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showBackButton)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text('Πίσω'),
                      ),
                    ),
                  Container(
                    width: 72,
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.event_available,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 26),
                  AppCard(
                    padding: const EdgeInsets.all(22),
                    child: child,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Business Appointment Manager',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await apiService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final token = data['token']?.toString() ?? '';

      if (token.isEmpty) {
        throw Exception('Δεν επιστράφηκε token από το backend.');
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            token: token,
            userEmail: data['user']?['email']?.toString() ??
                _emailController.text.trim(),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = getErrorMessage(
          error,
          'Αποτυχία σύνδεσης με το backend.',
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Καλώς ήρθες',
      subtitle: 'Συνδέσου για να διαχειριστείς τα ραντεβού σου.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_errorMessage != null) ...[
              ErrorBox(message: _errorMessage!),
              const SizedBox(height: 4),
            ],
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Συμπλήρωσε το email.';
                }

                if (!value.contains('@')) {
                  return 'Δώσε έγκυρο email.';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Κωδικός',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Συμπλήρωσε τον κωδικό.';
                }

                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? const Loader()
                  : const Text('Σύνδεση'),
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'ή',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
              icon: const Icon(Icons.person_add_alt),
              label: const Text('Δημιουργία λογαριασμού'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await apiService.register(
        businessName: _businessNameController.text.trim(),
        ownerName: _ownerNameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Η εγγραφή ολοκληρώθηκε επιτυχώς.'),
          backgroundColor: AppColors.primary,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = getErrorMessage(
          error,
          'Αποτυχία εγγραφής.',
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Συμπλήρωσε το πεδίο.';
          }

          if (label == 'Email' && !value.contains('@')) {
            return 'Δώσε έγκυρο email.';
          }

          if (label == 'Κωδικός' && value.length < 4) {
            return 'Ο κωδικός πρέπει να έχει τουλάχιστον 4 χαρακτήρες.';
          }

          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Δημιουργία λογαριασμού',
      subtitle: 'Καταχώρησε τα στοιχεία της επιχείρησής σου.',
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_errorMessage != null) ErrorBox(message: _errorMessage!),
            const SectionLabel(text: 'Στοιχεία επιχείρησης'),
            _buildField(
              controller: _businessNameController,
              label: 'Όνομα επιχείρησης',
              icon: Icons.storefront_outlined,
            ),
            _buildField(
              controller: _ownerNameController,
              label: 'Όνομα υπευθύνου',
              icon: Icons.person_outline,
            ),
            const SectionLabel(text: 'Στοιχεία λογαριασμού'),
            _buildField(
              controller: _fullNameController,
              label: 'Πλήρες όνομα χρήστη',
              icon: Icons.badge_outlined,
            ),
            _buildField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildField(
              controller: _passwordController,
              label: 'Κωδικός',
              icon: Icons.lock_outline,
              obscureText: true,
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const Loader()
                  : const Text('Δημιουργία λογαριασμού'),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Έχω ήδη λογαριασμό — Σύνδεση'),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final String token;
  final String userEmail;

  const DashboardScreen({
    super.key,
    required this.token,
    required this.userEmail,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> _clients = [];
  List<dynamic> _appointments = [];
  Map<String, dynamic>? _statistics;

  bool _isLoading = true;
  String? _errorMessage;

  int _currentIndex = 0;
  String _appointmentFilter = 'all';
  String _clientSearch = '';

  bool _calendarView = false;
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        apiService.getClients(widget.token),
        apiService.getAppointments(widget.token),
        apiService.getStatistics(widget.token),
      ]);

      if (!mounted) return;

      setState(() {
        _clients = results[0] as List<dynamic>;
        _appointments = results[1] as List<dynamic>;
        _statistics = results[2] as Map<String, dynamic>;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = getErrorMessage(
          error,
          'Σφάλμα φόρτωσης δεδομένων.',
        );
        _isLoading = false;
      });
    }
  }

  Future<void> _openClientForm() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateClientScreen(token: widget.token),
      ),
    );

    if (result == true) await _loadData();
  }

  Future<void> _editClient(dynamic client) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditClientScreen(
          token: widget.token,
          client: client,
        ),
      ),
    );

    if (result == true) await _loadData();
  }

  Future<void> _openAppointmentForm() async {
    if (_clients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Καταχώρησε πρώτα έναν πελάτη.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateAppointmentScreen(
          token: widget.token,
          clients: _clients,
        ),
      ),
    );

    if (result == true) await _loadData();
  }

  Future<void> _changeAppointmentStatus(
    int appointmentId,
    String status,
  ) async {
    try {
      await apiService.updateAppointmentStatus(
        token: widget.token,
        appointmentId: appointmentId,
        status: status,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Η κατάσταση ενημερώθηκε επιτυχώς.'),
          backgroundColor: AppColors.primary,
        ),
      );

      await _loadData();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            getErrorMessage(error, 'Αποτυχία ενημέρωσης κατάστασης.'),
          ),
          backgroundColor: AppColors.cancelled,
        ),
      );
    }
  }

  Future<void> _confirmCancellation(
    int appointmentId,
    String title,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text('Ακύρωση ραντεβού'),
        content: Text('Θέλεις να ακυρώσεις το «$title»;'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Όχι'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cancelled,
            ),
            child: const Text('Ακύρωση ραντεβού'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _changeAppointmentStatus(appointmentId, 'cancelled');
    }
  }

  String _statusText(String status) {
    switch (status) {
      case 'scheduled':
        return 'Προγραμματισμένο';
      case 'completed':
        return 'Ολοκληρωμένο';
      case 'cancelled':
        return 'Ακυρωμένο';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'scheduled':
        return AppColors.scheduled;
      case 'completed':
        return AppColors.completed;
      case 'cancelled':
        return AppColors.cancelled;
      default:
        return AppColors.textMuted;
    }
  }

  String _formatDate(dynamic value) {
    final text = value?.toString() ?? '-';

    if (text.length < 10) return text;

    final parts = text.substring(0, 10).split('-');

    return parts.length == 3
        ? '${parts[2]}/${parts[1]}/${parts[0]}'
        : text;
  }

  String _formatTime(dynamic value) {
    final text = value?.toString() ?? '-';
    return text.length >= 5 ? text.substring(0, 5) : text;
  }

  int _stat(String key) {
    return int.tryParse((_statistics?[key] ?? 0).toString()) ?? 0;
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) return '?';

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts[0].substring(0, 1) + parts[1].substring(0, 1))
        .toUpperCase();
  }

  Widget _buildClientsTab() {
    final query = _clientSearch.toLowerCase();

    final filtered = _clients.where((client) {
      if (query.isEmpty) return true;

      final name = client['full_name']?.toString().toLowerCase() ?? '';
      final phone = client['phone']?.toString().toLowerCase() ?? '';
      final email = client['email']?.toString().toLowerCase() ?? '';

      return name.contains(query) ||
          phone.contains(query) ||
          email.contains(query);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Αναζήτηση πελάτη...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _clientSearch.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _clientSearch = '');
                      },
                    ),
            ),
            onChanged: (value) {
              setState(() => _clientSearch = value);
            },
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? EmptyState(
                  icon: Icons.people_outline,
                  title: _clients.isEmpty
                      ? 'Δεν υπάρχουν πελάτες'
                      : 'Κανένα αποτέλεσμα',
                  description: _clients.isEmpty
                      ? 'Πάτησε «Νέος πελάτης» για την πρώτη καταχώρηση.'
                      : 'Δοκίμασε διαφορετικό όρο αναζήτησης.',
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final client = filtered[index];

                      final name =
                          client['full_name']?.toString() ?? '-';
                      final phone = client['phone']?.toString() ?? '';
                      final email = client['email']?.toString() ?? '';

                      return AppCard(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        onTap: () => _editClient(client),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primary
                                    .withOpacity(0.10),
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                              child: Text(
                                _initials(name),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  if (phone.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    _clientLine(
                                      Icons.phone_outlined,
                                      phone,
                                    ),
                                  ],
                                  if (email.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    _clientLine(
                                      Icons.email_outlined,
                                      email,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: AppColors.primary,
                              ),
                              tooltip: 'Επεξεργασία πελάτη',
                              onPressed: () => _editClient(client),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _clientLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String value, String label) {
    final selected = _appointmentFilter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) {
          setState(() => _appointmentFilter = value);
        },
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        side: const BorderSide(color: AppColors.border),
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : AppColors.textMuted,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  DateTime? _appointmentDate(dynamic appointment) {
    final raw = appointment['appointment_date']?.toString() ?? '';

    if (raw.length < 10) return null;

    try {
      final parsed = DateTime.parse(raw.substring(0, 10));
      return DateTime(parsed.year, parsed.month, parsed.day);
    } catch (_) {
      return null;
    }
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<dynamic> _appointmentsForDay(DateTime day) {
    final list = _appointments.where((appointment) {
      final date = _appointmentDate(appointment);
      return date != null && _sameDay(date, day);
    }).toList();

    list.sort((a, b) {
      final first = a['start_time']?.toString() ?? '';
      final second = b['start_time']?.toString() ?? '';
      return first.compareTo(second);
    });

    return list;
  }

  Widget _viewToggle() {
    Widget button({
      required bool active,
      required IconData icon,
      required String label,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: active ? Colors.white : AppColors.textMuted,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            button(
              active: !_calendarView,
              icon: Icons.view_list_outlined,
              label: 'Λίστα',
              onTap: () => setState(() => _calendarView = false),
            ),
            button(
              active: _calendarView,
              icon: Icons.calendar_month_outlined,
              label: 'Ημερολόγιο',
              onTap: () => setState(() => _calendarView = true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    return Column(
      children: [
        _viewToggle(),
        Expanded(
          child: _calendarView
              ? _buildCalendarView()
              : _buildAppointmentsList(),
        ),
      ],
    );
  }

  Widget _buildAppointmentsList() {
    final filtered = _appointments.where((appointment) {
      final status = appointment['status']?.toString() ?? 'scheduled';

      return _appointmentFilter == 'all' || status == _appointmentFilter;
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 54,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            children: [
              _filterChip('all', 'Όλα'),
              _filterChip('scheduled', 'Προγραμματισμένα'),
              _filterChip('completed', 'Ολοκληρωμένα'),
              _filterChip('cancelled', 'Ακυρωμένα'),
            ],
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const EmptyState(
                  icon: Icons.event_busy_outlined,
                  title: 'Δεν υπάρχουν ραντεβού',
                  description:
                      'Άλλαξε φίλτρο ή δημιούργησε νέο ραντεβού.',
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _appointmentCard(filtered[index]);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCalendarView() {
    final dayAppointments = _appointmentsForDay(_selectedDay);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 96),
      children: [
        _calendarCard(),
        const SizedBox(height: 18),
        SectionLabel(
          text: 'Ραντεβού ${_dayLabel(_selectedDay)}',
        ),
        if (dayAppointments.isEmpty)
          AppCard(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: const [
                Icon(
                  Icons.event_available_outlined,
                  color: AppColors.textMuted,
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Δεν υπάρχουν ραντεβού αυτή την ημέρα.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          )
        else
          ...dayAppointments.map(_appointmentCard),
      ],
    );
  }

  String _dayLabel(DateTime day) {
    return '${day.day.toString().padLeft(2, '0')}/'
        '${day.month.toString().padLeft(2, '0')}/${day.year}';
  }

  String _monthLabel(DateTime month) {
    const names = [
      'Ιανουάριος',
      'Φεβρουάριος',
      'Μάρτιος',
      'Απρίλιος',
      'Μάιος',
      'Ιούνιος',
      'Ιούλιος',
      'Αύγουστος',
      'Σεπτέμβριος',
      'Οκτώβριος',
      'Νοέμβριος',
      'Δεκέμβριος',
    ];

    return '${names[month.month - 1]} ${month.year}';
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + offset,
        1,
      );
    });
  }

  Widget _calendarCard() {
    final firstDay = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );

    final daysInMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;

    final leadingEmpty = firstDay.weekday - 1;
    final totalCells = leadingEmpty + daysInMonth;
    final rows = (totalCells / 7).ceil();

    const weekDays = ['Δε', 'Τρ', 'Τε', 'Πε', 'Πα', 'Σα', 'Κυ'];

    return AppCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left),
                color: AppColors.primary,
              ),
              Expanded(
                child: Text(
                  _monthLabel(_focusedMonth),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right),
                color: AppColors.primary,
              ),
            ],
          ),
          Row(
            children: weekDays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 6),
          ...List.generate(rows, (row) {
            return Row(
              children: List.generate(7, (column) {
                final cellIndex = row * 7 + column;
                final dayNumber = cellIndex - leadingEmpty + 1;

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 48));
                }

                final day = DateTime(
                  _focusedMonth.year,
                  _focusedMonth.month,
                  dayNumber,
                );

                return Expanded(
                  child: _calendarCell(day),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _calendarCell(DateTime day) {
    final dayAppointments = _appointmentsForDay(day);
    final isSelected = _sameDay(day, _selectedDay);
    final isToday = _sameDay(day, DateTime.now());

    final statuses = dayAppointments
        .map((a) => a['status']?.toString() ?? 'scheduled')
        .toSet()
        .toList();

    return InkWell(
      onTap: () => setState(() => _selectedDay = day),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isToday
                  ? AppColors.primary.withOpacity(0.10)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.primary.withOpacity(0.35))
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.day.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected || isToday
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              height: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: statuses.take(3).map((status) {
                  return Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.white
                          : _statusColor(status),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appointmentCard(dynamic appointment) {
    final id = int.tryParse(appointment['id']?.toString() ?? '') ?? 0;

    final title = appointment['title']?.toString() ?? 'Ραντεβού';
    final status = appointment['status']?.toString() ?? 'scheduled';
    final color = _statusColor(status);
    final description = appointment['description']?.toString() ?? '';
    final dateText = _formatDate(appointment['appointment_date']);
    final dayPart = dateText.split('/');

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        dayPart.isNotEmpty ? dayPart[0] : '-',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        dayPart.length > 1 ? '/${dayPart[1]}' : '',
                        style: TextStyle(fontSize: 12, color: color),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusBadge(
                            text: _statusText(status),
                            color: color,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _infoLine(
                        Icons.person_outline,
                        appointment['client_name']?.toString() ?? '-',
                      ),
                      const SizedBox(height: 4),
                      _infoLine(
                        Icons.schedule,
                        '$dateText  •  '
                        '${_formatTime(appointment['start_time'])}'
                        ' - '
                        '${_formatTime(appointment['end_time'])}',
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        _infoLine(Icons.notes_outlined, description),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (status == 'scheduled') ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        _changeAppointmentStatus(id, 'completed');
                      },
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                      ),
                      label: const Text('Ολοκλήρωση'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.completed,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 22,
                    color: AppColors.border,
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        _confirmCancellation(id, title);
                      },
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('Ακύρωση'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.cancelled,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoLine(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    String title,
    int value,
    IconData icon,
    Color color,
  ) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab() {
    final frequentClients = List<dynamic>.from(
      _statistics?['frequentClients'] ?? [],
    );

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          const SectionLabel(text: 'Επισκόπηση'),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: [
              _statCard(
                'Συνολικοί πελάτες',
                _stat('totalClients'),
                Icons.people_outline,
                AppColors.primary,
              ),
              _statCard(
                'Συνολικά ραντεβού',
                _stat('totalAppointments'),
                Icons.event_note_outlined,
                Colors.deepOrange,
              ),
              _statCard(
                'Σημερινά ραντεβού',
                _stat('totalToday'),
                Icons.today_outlined,
                AppColors.scheduled,
              ),
              _statCard(
                'Προγραμματισμένα',
                _stat('totalScheduled'),
                Icons.schedule,
                Colors.indigo,
              ),
              _statCard(
                'Ολοκληρωμένα',
                _stat('totalCompleted'),
                Icons.check_circle_outline,
                AppColors.completed,
              ),
              _statCard(
                'Ακυρωμένα',
                _stat('totalCancelled'),
                Icons.cancel_outlined,
                AppColors.cancelled,
              ),
            ],
          ),
          const SizedBox(height: 22),
          const SectionLabel(text: 'Συχνότεροι πελάτες'),
          if (frequentClients.isEmpty)
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: const [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Δεν υπάρχουν ακόμη αρκετά δεδομένα.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ...frequentClients.map((client) {
            final name = client['full_name']?.toString() ?? '-';
            final count = client['appointment_count']?.toString() ?? '0';

            return AppCard(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      _initials(name),
                      style: const TextStyle(
                        color: Color(0xFFB8860B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          client['phone']?.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    text: '$count ραντεβού',
                    color: AppColors.primary,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String get _currentTitle {
    switch (_currentIndex) {
      case 0:
        return 'Πελάτες';
      case 1:
        return 'Ραντεβού';
      default:
        return 'Στατιστικά';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildClientsTab(),
      _buildAppointmentsTab(),
      _buildStatisticsTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_currentTitle),
            Text(
              widget.userEmail,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Color(0xCCFFFFFF),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Ανανέωση',
          ),
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Αποσύνδεση',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 2
          ? null
          : FloatingActionButton.extended(
              onPressed: _currentIndex == 0
                  ? _openClientForm
                  : _openAppointmentForm,
              icon: Icon(
                _currentIndex == 0
                    ? Icons.person_add_alt_1
                    : Icons.add_alarm,
              ),
              label: Text(
                _currentIndex == 0 ? 'Νέος πελάτης' : 'Νέο ραντεβού',
              ),
            ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.primary.withOpacity(0.12),
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          child: NavigationBar(
            height: 66,
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(
                  Icons.people,
                  color: AppColors.primary,
                ),
                label: 'Πελάτες',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(
                  Icons.calendar_month,
                  color: AppColors.primary,
                ),
                label: 'Ραντεβού',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(
                  Icons.bar_chart,
                  color: AppColors.primary,
                ),
                label: 'Στατιστικά',
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ErrorBox(message: _errorMessage!),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _loadData,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Δοκίμασε ξανά'),
                        ),
                      ],
                    ),
                  ),
                )
              : IndexedStack(
                  index: _currentIndex,
                  children: tabs,
                ),
    );
  }
}

class CreateClientScreen extends StatefulWidget {
  final String token;

  const CreateClientScreen({
    super.key,
    required this.token,
  });

  @override
  State<CreateClientScreen> createState() => _CreateClientScreenState();
}

class _CreateClientScreenState extends State<CreateClientScreen> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _notes = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await apiService.createClient(
        token: widget.token,
        fullName: _name.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        notes: _notes.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = getErrorMessage(e, 'Αποτυχία καταχώρησης πελάτη.');
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClientFormLayout(
      title: 'Νέος πελάτης',
      headline: 'Καταχώρηση νέου πελάτη',
      subtitle: 'Συμπλήρωσε τα στοιχεία επικοινωνίας.',
      icon: Icons.person_add_alt_1,
      formKey: _key,
      nameController: _name,
      phoneController: _phone,
      emailController: _email,
      notesController: _notes,
      errorMessage: _error,
      loading: _loading,
      buttonText: 'Αποθήκευση πελάτη',
      onSave: _save,
    );
  }
}

class EditClientScreen extends StatefulWidget {
  final String token;
  final dynamic client;

  const EditClientScreen({
    super.key,
    required this.token,
    required this.client,
  });

  @override
  State<EditClientScreen> createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  final _key = GlobalKey<FormState>();

  late TextEditingController _name;
  late TextEditingController _phone;
  late TextEditingController _email;
  late TextEditingController _notes;

  bool _loading = false;
  String? _error;

  int get _clientId {
    return int.tryParse(widget.client['id'].toString()) ?? 0;
  }

  @override
  void initState() {
    super.initState();

    _name = TextEditingController(
      text: widget.client['full_name']?.toString() ?? '',
    );

    _phone = TextEditingController(
      text: widget.client['phone']?.toString() ?? '',
    );

    _email = TextEditingController(
      text: widget.client['email']?.toString() ?? '',
    );

    _notes = TextEditingController(
      text: widget.client['notes']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await apiService.updateClient(
        token: widget.token,
        clientId: _clientId,
        fullName: _name.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        notes: _notes.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = getErrorMessage(e, 'Αποτυχία ενημέρωσης πελάτη.');
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClientFormLayout(
      title: 'Επεξεργασία πελάτη',
      headline: widget.client['full_name']?.toString() ?? 'Πελάτης',
      subtitle: 'Ενημέρωσε τα στοιχεία του πελάτη.',
      icon: Icons.edit_note,
      formKey: _key,
      nameController: _name,
      phoneController: _phone,
      emailController: _email,
      notesController: _notes,
      errorMessage: _error,
      loading: _loading,
      buttonText: 'Αποθήκευση αλλαγών',
      onSave: _save,
    );
  }
}

class ClientFormLayout extends StatelessWidget {
  final String title;
  final String headline;
  final String subtitle;
  final IconData icon;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController notesController;
  final String? errorMessage;
  final bool loading;
  final VoidCallback onSave;
  final String buttonText;

  const ClientFormLayout({
    super.key,
    required this.title,
    required this.headline,
    required this.subtitle,
    required this.icon,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.notesController,
    required this.errorMessage,
    required this.loading,
    required this.onSave,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormHeader(
                    icon: icon,
                    headline: headline,
                    subtitle: subtitle,
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (errorMessage != null)
                            ErrorBox(message: errorMessage!),
                          const SectionLabel(text: 'Βασικά στοιχεία'),
                          TextFormField(
                            controller: nameController,
                            textCapitalization:
                                TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Ονοματεπώνυμο *',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Συμπλήρωσε το ονοματεπώνυμο.'
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Τηλέφωνο',
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (v) {
                              if (v != null &&
                                  v.trim().isNotEmpty &&
                                  !v.contains('@')) {
                                return 'Δώσε έγκυρο email.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          const SectionLabel(text: 'Σημειώσεις'),
                          TextFormField(
                            controller: notesController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'Σημειώσεις πελάτη',
                              alignLabelWithHint: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: loading ? null : onSave,
                            icon: loading
                                ? const Loader()
                                : const Icon(Icons.save_outlined),
                            label: Text(
                              loading ? 'Αποθήκευση...' : buttonText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: loading
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text('Άκυρο'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateAppointmentScreen extends StatefulWidget {
  final String token;
  final List<dynamic> clients;

  const CreateAppointmentScreen({
    super.key,
    required this.token,
    required this.clients,
  });

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState
    extends State<CreateAppointmentScreen> {
  final _key = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();

  int? _clientId;
  DateTime _date = DateTime.now();
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 10, minute: 0);

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  String _dateApi() {
    return '${_date.year}-'
        '${_date.month.toString().padLeft(2, '0')}-'
        '${_date.day.toString().padLeft(2, '0')}';
  }

  String _dateLabel() {
    return '${_date.day.toString().padLeft(2, '0')}/'
        '${_date.month.toString().padLeft(2, '0')}/'
        '${_date.year}';
  }

  String _timeApi(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:00';
  }

  String _timeLabel(TimeOfDay time) {
    return _timeApi(time).substring(0, 5);
  }

  Future<void> _save() async {
    if (!_key.currentState!.validate() || _clientId == null) {
      setState(() => _error = 'Συμπλήρωσε όλα τα υποχρεωτικά πεδία.');
      return;
    }

    final startMinutes = _start.hour * 60 + _start.minute;
    final endMinutes = _end.hour * 60 + _end.minute;

    if (endMinutes <= startMinutes) {
      setState(() {
        _error = 'Η ώρα λήξης πρέπει να είναι μετά την ώρα έναρξης.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await apiService.createAppointment(
        token: widget.token,
        clientId: _clientId!,
        title: _title.text.trim(),
        description: _description.text.trim(),
        appointmentDate: _dateApi(),
        startTime: _timeApi(_start),
        endTime: _timeApi(_end),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = getErrorMessage(e, 'Αποτυχία καταχώρησης ραντεβού.');
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2035),
    );

    if (result != null) setState(() => _date = result);
  }

  Future<void> _pickTime(bool isStart) async {
    final result = await showTimePicker(
      context: context,
      initialTime: isStart ? _start : _end,
    );

    if (result != null) {
      setState(() {
        if (isStart) {
          _start = result;
        } else {
          _end = result;
        }
      });
    }
  }

  Widget _pickerTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textMuted),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Νέο ραντεβού')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FormHeader(
                    icon: Icons.event_available,
                    headline: 'Προγραμματισμός ραντεβού',
                    subtitle: 'Επίλεξε πελάτη, ημερομηνία και ώρα.',
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_error != null) ErrorBox(message: _error!),
                          const SectionLabel(text: 'Στοιχεία ραντεβού'),
                          DropdownButtonFormField<int>(
                            value: _clientId,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Πελάτης *',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            items: widget.clients.map((client) {
                              return DropdownMenuItem<int>(
                                value: int.tryParse(
                                  client['id'].toString(),
                                ),
                                child: Text(
                                  client['full_name']?.toString() ?? '-',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _clientId = value);
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _title,
                            decoration: const InputDecoration(
                              labelText: 'Τίτλος ραντεβού *',
                              prefixIcon: Icon(Icons.title),
                            ),
                            validator: (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Συμπλήρωσε τον τίτλο.'
                                    : null,
                          ),
                          const SizedBox(height: 20),
                          const SectionLabel(text: 'Ημερομηνία και ώρα'),
                          _pickerTile(
                            icon: Icons.calendar_today_outlined,
                            label: 'Ημερομηνία',
                            value: _dateLabel(),
                            onTap: _pickDate,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _pickerTile(
                                  icon: Icons.play_arrow_outlined,
                                  label: 'Έναρξη',
                                  value: _timeLabel(_start),
                                  onTap: () => _pickTime(true),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _pickerTile(
                                  icon: Icons.stop_circle_outlined,
                                  label: 'Λήξη',
                                  value: _timeLabel(_end),
                                  onTap: () => _pickTime(false),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const SectionLabel(text: 'Σημειώσεις'),
                          TextFormField(
                            controller: _description,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'Περιγραφή ή σημειώσεις',
                              alignLabelWithHint: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loading ? null : _save,
                            icon: _loading
                                ? const Loader()
                                : const Icon(Icons.save_outlined),
                            label: Text(
                              _loading
                                  ? 'Αποθήκευση...'
                                  : 'Αποθήκευση ραντεβού',
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: _loading
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text('Άκυρο'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class FormHeader extends StatelessWidget {
  final IconData icon;
  final String headline;
  final String subtitle;

  const FormHeader({
    super.key,
    required this.icon,
    required this.headline,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppColors.primary, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headline,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class ErrorBox extends StatelessWidget {
  final String message;

  const ErrorBox({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cancelled.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cancelled.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.cancelled,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.cancelled,
                fontSize: 13.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:p9_714230042/botnav.dart';
// import 'package:p9_714230042/shared_preferences.dart'; // Import ini tampaknya tidak diperlukan jika logic ada di sini
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart'; // Pastikan path ini benar

// --- Kunci Khusus untuk Remember Me ---
const String _keyRememberMe = 'rememberMe';
const String _keySavedUsername = 'savedUsername';
// Kunci lama yang sudah Anda gunakan
const String _keyIsLoggedIn = 'login';
// const String _keyCurrentUsername = 'username'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Tambahan state untuk Checkbox "Remember Me"
  bool _rememberMe = false; 

  late SharedPreferences loginData;
  late bool newUser;

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value != null && value.length < 4) {
      return 'Masukkan minimal 4 karakter';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value != null && value.length < 3) {
      return 'Masukkan minimal 3 karakter';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  // Gabungan Inisialisasi dan Pengecekan Login
  void _initSharedPreferences() async {
    loginData = await SharedPreferences.getInstance();
    
    // 1. Muat Status Remember Me
    _rememberMe = loginData.getBool(_keyRememberMe) ?? false;
    
    // 2. Muat Username Tersimpan (KETENTUAN 2: TextField terisi otomatis)
    String? savedUsername = loginData.getString(_keySavedUsername);
    
    // Pengecekan Login (Logika yang sudah ada)
    newUser = loginData.getBool(_keyIsLoggedIn) ?? true;

    if (newUser == false) {
      // Jika sudah login, langsung navigasi ke Home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DynamicBottomNavBar(),
          ),
        (route) => false,);
    } else {
      // Jika belum login, isi TextField Username jika Remember Me aktif
      if (_rememberMe && savedUsername != null) {
        _usernameController.text = savedUsername;
      }
      setState(() {});
    }
  }
  
  // Fungsi untuk menyimpan data login dan Remember Me
  void _setLoginData(String username) async {
    // 1. Simpan status login utama (yang sudah ada)
    loginData.setBool(_keyIsLoggedIn, false);
    
    // 2. Simpan status Remember Me
    loginData.setBool(_keyRememberMe, _rememberMe);
    
    // 3. Simpan/Hapus Username (KETENTUAN 2 & 3)
    if (_rememberMe) {
      // KETENTUAN 2: Simpan username jika dicentang
      loginData.setString(_keySavedUsername, username);
      loginData.setString('username', username); // Menyimpan username aktif
    } else {
      // KETENTUAN 3: Hapus username jika tidak dicentang
      loginData.remove(_keySavedUsername);
      loginData.setString('username', username); // Tetap menyimpan username aktif untuk sesi ini
    }
  }


  @override
  Widget build(BuildContext context) {
    // Pastikan status Checkbox sudah dimuat sebelum build
    // Jika tidak, Anda akan melihat warning, tapi saat ini kita menggunakan setState() di _initSharedPreferences()
    
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Shared Preference')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // --- Username Field ---
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: _validateUsername,
                      controller : _usernameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        hintText: 'Write username here...',
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        fillColor: Color.fromARGB(255, 242, 254, 255),
                        filled: true,
                      ),
                    ),
                  ),
                  
                  // --- Password Field ---
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      validator: _validatePassword,
                      controller: _passwordController, // Tambahkan controller
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password_rounded),
                        hintText: 'Write your password here...',
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        fillColor: Color.fromARGB(255, 242, 254, 255),
                        filled: true,
                      ),
                    ),
                  ),
                  
                  // --- KETENTUAN 1: Checkbox Remember Me ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _rememberMe = newValue!;
                            });
                          },
                        ),
                        const Text('Remember Me'),
                      ],
                    ),
                  ),
                  
                  // --- Tombol Login ---
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final isValidForm = _formKey.currentState!.validate();

                        String username = _usernameController.text;
                        if (isValidForm) {
                          // Panggil fungsi untuk menyimpan data dan status Remember Me
                          _setLoginData(username);
                          
                          // Navigasi ke Home
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DynamicBottomNavBar(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text('Login'),
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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'login_screen.dart'; 

// --- Kunci Khusus yang Digunakan di LoginScreen ---
// Kita mendefinisikan ulang kunci ini agar sinkron
const String _keyIsLoggedIn = 'login';
const String _keyRememberMe = 'rememberMe';
const String _keyCurrentUsername = 'username';

class MyHome extends StatefulWidget { 
  const MyHome({super.key}); 
  
  @override 
  State<MyHome> createState() => _MyHomeState(); 
} 
  
class _MyHomeState extends State<MyHome> { 

  late SharedPreferences loginData;
  String username ="";
  bool _rememberMeStatus = false;

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    
    // Ambil status Remember Me
    _rememberMeStatus = loginData.getBool(_keyRememberMe) ?? false;

    setState(() {
      // Tampilkan username sesi saat ini
      username = loginData.getString(_keyCurrentUsername) ?? "Guest"; 
    });
  }

  // --- Fungsi Logout yang Diperbarui ---
  void _handleLogout() async {
    // 1. Ubah status sesi menjadi perlu login (newUser = true)
    await loginData.setBool(_keyIsLoggedIn, true);
    
    // 2. Hapus username sesi saat ini
    // Note: Kunci 'username' adalah username sesi aktif. Kunci 'savedUsername'
    // (di LoginScreen) yang menyimpan data untuk fitur Remember Me TIDAK dihapus.
    await loginData.remove(_keyCurrentUsername);
    
    // KETENTUAN 4: Username tetap tersimpan jika Remember Me aktif.
    // Kita tidak perlu melakukan apa-apa terhadap kunci _keySavedUsername.
    
    // 3. Navigasi ke Login Screen
    Navigator.pushReplacement( 
      context, 
      MaterialPageRoute( 
        builder: (context) => const LoginScreen(), 
      ), 
    ); 
  }


  @override 
  void initState() {
    super.initState();
    initial();
  }

  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text('Home'), 
      ), 
      body: Center( 
        child: Container( 
          margin: const EdgeInsets.symmetric( 
            vertical: 12, 
            horizontal: 16, 
          ), 
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten
            children: [ 
              const Text(
                'Welcome to Home',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ), 
              const SizedBox(height: 20), 
              Text(
                username, 
                style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
              ), 
              const SizedBox(height: 10),
              const SizedBox(height: 30), 

              ElevatedButton( 
                onPressed: _handleLogout, // Panggil fungsi Logout yang diperbarui
                child: const Text('Logout'), 
              ), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
}
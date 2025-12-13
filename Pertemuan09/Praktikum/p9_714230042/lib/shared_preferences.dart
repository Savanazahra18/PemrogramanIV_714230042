import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyShared extends StatefulWidget {
  const MyShared({super.key});
  @override
  State<MyShared> createState() {
    return _MySharedState();
  }
}

class _MySharedState extends State<MyShared> {
  late SharedPreferences prefs;
  
  // Asumsi: _dataAja digunakan untuk Username
  final TextEditingController _dataAja = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController(); // Tambahan untuk Password
  
  String name = ""; // Digunakan untuk menampilkan hasil retrieve
  bool _rememberMe = false; // Tambahan untuk status Checkbox

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Panggil fungsi untuk memuat data tersimpan
  }

  @override
  void dispose() {
    _dataAja.dispose();
    _passwordController.dispose(); // Dispose controller baru
    super.dispose();
  }

  // Fungsi baru untuk memuat data saat aplikasi dibuka
  void _loadInitialData() async {
    prefs = await SharedPreferences.getInstance();
    
    // 1. Ambil status Remember Me (Default: false)
    _rememberMe = prefs.getBool('dataRememberMe') ?? false;

    // 2. Ambil Username
    String? savedUsername = prefs.getString('dataUsername');

    // KETENTUAN 2 & 4: Isi TextField jika Remember Me aktif
    if (_rememberMe && savedUsername != null) {
      _dataAja.text = savedUsername;
    }
    
    // Panggil retrieve agar teks tersimpan muncul di TextField kedua saat inisialisasi
    retrieve();
    setState(() {});
  }

  // Fungsi save() diubah menjadi fungsi Login
  save() async {
    // Simulasi validasi login
    if (_dataAja.text.isEmpty || _passwordController.text.isEmpty) {
       setState(() {
        name = "Login Gagal: Harap isi semua field.";
      });
      return;
    }

    prefs = await SharedPreferences.getInstance();
    
    // 1. Simpan Status Remember Me
    prefs.setBool('dataRememberMe', _rememberMe); 

    // 2. KETENTUAN 2 & 3: Simpan/Hapus Username berdasarkan Checkbox
    if (_rememberMe) {
      prefs.setString('dataUsername', _dataAja.text.toString()); // Simpan Username
      setState(() {
        name = "Login Berhasil. Username disimpan.";
      });
    } else {
      prefs.remove('dataUsername'); // Hapus Username
      setState(() {
        name = "Login Berhasil. Username tidak disimpan.";
      });
    }

    // Bersihkan field password setelah login
    _passwordController.text = ""; 
    
    // Pindah ke Home Screen (Simulasi: Bersihkan field username untuk melihat efek)
    _dataAja.text = ""; 
  }

  // Fungsi retrieve() untuk mengambil username yang tersimpan
  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('dataUsername');
    name = storedUsername ?? "Username Kosong"; // Tampilkan username yang tersimpan
    setState(() {});
  }

  // Fungsi delete() diubah menjadi fungsi Logout/Clear Data
  delete() async {
    prefs = await SharedPreferences.getInstance();
    
    // KETENTUAN 4: Logout (tanpa menghapus username jika Remember Me aktif)
    // Untuk simulasi "Hapus Nilai" (full reset), kita akan hapus semuanya
    prefs.remove('dataUsername'); 
    prefs.remove('dataRememberMe'); 
    
    _dataAja.text = "";
    _passwordController.text = "";
    name = "Semua Data Login Dihapus (Full Reset)";
    _rememberMe = false;
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Preferences - Remember Me"),
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TextField 1: Username
              TextField(
                controller: _dataAja,
                decoration: const InputDecoration(
                  labelText: 'Username', // Label ditambahkan
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // TextField Baru: Password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password', // Label ditambahkan
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              
              // KETENTUAN 1: Checkbox "Remember Me"
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _rememberMe = newValue!;
                      });
                    },
                  ),
                  const Text("Remember Me"),
                ],
              ),
              const SizedBox(height: 20),

              // Tombol "Login" (sebelumnya Save)
              ElevatedButton(
                child: const Text("Login"),
                onPressed: () {
                  save();
                },
              ),
              
              const SizedBox(
                height: 20,
              ),

              // TextField 2: Display (Status atau Username Tersimpan)
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: name
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // Tombol "Get Value" (Untuk menampilkan username tersimpan)
              ElevatedButton(
                child: const Text("Get Stored Username"),
                onPressed: () {
                  retrieve();
                },
              ),

              // Tombol "Delete Value" (Logout/Full Reset)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Logout (Delete All Data)"),
                onPressed: () {
                  delete();
                },
              )
            ],
          )),
    );
  }
}
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas Pertemuan 4',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFF5722), // oranye terang
          title: const Text(
            'Tugas Pertemuan 4',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(child: MyLayout()),
      ),
    );
  }
}

class MyLayout extends StatelessWidget {
  const MyLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 90,
          color: const Color(0xFF2196F3),
          alignment: Alignment.center,
          child: const Text(
            'Box 1',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 200,
              color: const Color(0xFFF44336),
              alignment: Alignment.center,
              child: const Text(
                'Box 2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 25),
            Container(
              width: 110,
              height: 200,
              color: const Color(0xFF4CAF50),
              alignment: Alignment.center,
              child: const Text(
                'Box 3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

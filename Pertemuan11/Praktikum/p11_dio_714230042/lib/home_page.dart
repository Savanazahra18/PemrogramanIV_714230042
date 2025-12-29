import 'package:flutter/material.dart';
import 'data_service.dart';
import 'user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataService _dataService = DataService();
  final _nameCtl = TextEditingController();
  final _jobCtl = TextEditingController();

  String _result = '-';
  List<User> _users = [];
  UserCreate? usCreate;
  bool isUpdate = false;

  @override
  void dispose() {
    _nameCtl.dispose();
    _jobCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('REST API (DIO)'), elevation: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameCtl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _jobCtl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Job',
              ),
            ),
            const SizedBox(height: 15),

            // Baris Tombol Utama
            Row(
              children: [
                _buildButton('GET', () async {
                  final res = await _dataService.getUsers();
                  if (res != null) setState(() => _result = res.toString());
                }),
                const SizedBox(width: 8),
                _buildButton('POST', () async {
                  if (_nameCtl.text.isEmpty) return;
                  final res = await _dataService.postUser(
                    UserCreate(name: _nameCtl.text, job: _jobCtl.text),
                  );
                  setState(() {
                    usCreate = res;
                    isUpdate = false;
                    _result = res.toString();
                  });
                }),
                const SizedBox(width: 8),
                _buildButton('PUT', () async {
                  if (_nameCtl.text.isEmpty) return;
                  final res = await _dataService.putUser(
                    '1',
                    _nameCtl.text,
                    _jobCtl.text,
                  );
                  setState(() {
                    usCreate = res;
                    isUpdate = true;
                    _result = res.toString();
                  });
                }),
                const SizedBox(width: 8),
                _buildButton('DELETE', () async {
                  final res = await _dataService.deleteUser('1');
                  setState(() => _result = res.toString());
                }),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final users = await _dataService.getUserModel();
                      setState(() => _users = users?.toList() ?? []);
                    },
                    child: const Text('Model Class User Example'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _result = "-";
                      _users.clear();
                      usCreate = null;
                      _nameCtl.clear();
                      _jobCtl.clear();
                    });
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Result',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),

            SizedBox(
              width: double.infinity,
              child: _users.isEmpty ? Text(_result) : _buildListUser(),
            ),

            const SizedBox(height: 30),

            // --- OUTPUT CARD CHALLENGE ---
            _buildHasilCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHasilCard() {
    if (usCreate == null) return const Text('no data');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue[200], // Biru yang lebih jelas
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Rata Kiri
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 16),
              children: [
                const TextSpan(
                  text: "Name : ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: usCreate!.name),
              ],
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 16),
              children: [
                const TextSpan(
                  text: "Job : ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: usCreate!.job),
              ],
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                  text: "${isUpdate ? 'Updated' : 'Created'} At : ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: usCreate!.createdAt),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontSize: 10)),
      ),
    );
  }

  Widget _buildListUser() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
          title: Text('${user.firstName} ${user.lastName}'),
          subtitle: Text(user.email),
        );
      },
    );
  }
}

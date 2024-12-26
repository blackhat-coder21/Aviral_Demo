import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  final String jwtToken;
  final String? session;

  const Home({Key? key, required this.jwtToken, this.session}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? session;
  List<Map<String, dynamic>> data = [];
  Map<String, dynamic>? dashboard;

  @override
  void initState() {
    super.initState();
    session = widget.session;
    setSessions();
    setUserDashboard();
  }

  Future<void> setSessions() async {
    try {
      // Replace this with your API call for sessions
      final sessions = await getSessions();
      setState(() {
        data = sessions;
      });
    } catch (e) {
      print("Error fetching sessions: $e");
    }
  }

  Future<void> setUserDashboard() async {
    try {
      // Replace this with your API call for dashboard
      final userDashboard = await getDashboard(widget.jwtToken, session);
      setState(() {
        dashboard = userDashboard;
      });
    } catch (e) {
      print("Error fetching dashboard: $e");
    }
  }

  void handleViewScore() {
    if (session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a session')),
      );
      return;
    }
    Navigator.pushNamed(context, '/score', arguments: {
      'session': session,
      'jwtToken': widget.jwtToken,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: dashboard == null
            ? const Center(child: CircularProgressIndicator())
            : GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Card(
                  color: const Color(0xFFE8DFF9),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Welcome', style: TextStyle(fontSize: 15)),
                        Text(
                          dashboard!['student_id'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          [
                            dashboard!['first_name'] ?? '',
                            dashboard!['middle_name'] ?? '',
                            dashboard!['last_name'] ?? ''
                          ].join(' ').trim(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        Text(dashboard!['program'] ?? '',
                            style: const TextStyle(fontSize: 14)),
                        Text(
                          '${dashboard!['semester']} Semester',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'GPA: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${dashboard!['cgpi']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: (dashboard!['cgpi'] < 7)
                                          ? Colors.red
                                          : (dashboard!['cgpi'] < 8)
                                          ? Colors.orange
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Credits: ${dashboard!['completed_core']}/${dashboard!['total_core_credits']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: session,
                  hint: const Text('Select a session'),
                  isExpanded: true,
                  items: data
                      .map(
                        (item) => DropdownMenuItem<String>(
                      value: item['session_id'],
                      child: Text(item['name']),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      session = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: handleViewScore,
                  child: const Text('View Score'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Replace these placeholders with your API calls
  Future<List<Map<String, dynamic>>> getSessions() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {'session_id': '1', 'name': 'Session 1'},
      {'session_id': '2', 'name': 'Session 2'},
    ];
  }

  Future<Map<String, dynamic>> getDashboard(String jwtToken, String? session) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'student_id': '12345',
      'first_name': 'John',
      'middle_name': 'Doe',
      'last_name': '',
      'program': 'Computer Science',
      'semester': '5th',
      'cgpi': 8.2,
      'completed_core': 30,
      'total_core_credits': 40,
    };
  }
}

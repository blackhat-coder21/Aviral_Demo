import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const CourseCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gpa = data['gpa'];
    Color gpaColor = Colors.green;

    if (gpa < 7.5) {
      gpaColor = Colors.red;
    } else if (gpa < 8.5) {
      gpaColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF4F378B), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, -2),
            blurRadius: 3.84,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${data['name']} (${data['course_id']})",
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF4F378B),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColumn("C1", data['c1_marks'].toString()),
              _buildColumn("C2", data['c2_marks'].toString()),
              _buildColumn("C3", data['c3_marks'].toString()),
              _buildColumn("Total", data['total'].toString()),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: "GPA: ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: gpa.toString(),
                      style: TextStyle(color: gpaColor),
                    ),
                  ],
                ),
              ),
              Text("Credits: ${data['credits']}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

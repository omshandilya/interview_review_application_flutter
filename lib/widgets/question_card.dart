
import 'package:flutter/material.dart';
import '../screens/answer_screen.dart';
import '../services/question_service.dart';
import 'package:google_fonts/google_fonts.dart';


class QuestionCard extends StatelessWidget {
  final Map question;

  const QuestionCard({required this.question});

  void _saveQuestion(BuildContext context) async {
    final success = await QuestionService.saveQuestion(question['id']);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Question saved!" : "Failed to save question"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.question_answer_rounded,
                  color: Colors.indigoAccent, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  question['question'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          //function to show if answered or not
          // Text(
          //   "Answered: ${question['is_answered']}",
          //   style: GoogleFonts.poppins(
          //     fontSize: 13,
          //     color: Colors.grey[400],
          //   ),
          // ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.star_border, color: Colors.white),
                onPressed: () => _saveQuestion(context),
              ),
              IconButton(
                icon: Icon(Icons.mic, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnswerScreen(question: question),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}



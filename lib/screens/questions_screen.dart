import 'package:flutter/material.dart';
import '../services/question_service.dart';
import '../widgets/question_card.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/question_service.dart';
import '../widgets/question_card.dart';

class QuestionsScreen extends StatefulWidget {
  final String topic;

  QuestionsScreen({required this.topic});

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  List questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGeneratedQuestions();
  }

  void fetchGeneratedQuestions() async {
    final result = await QuestionService.generateQuestions(widget.topic);
    setState(() {
      questions = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "${widget.topic} Questions",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : questions.isEmpty
            ? Center(
          child: Text(
            "No questions found.",
            style: GoogleFonts.poppins(
                color: Colors.white70, fontSize: 16),
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return QuestionCard(question: questions[index]);
          },
        ),
      ),
    );
  }
}

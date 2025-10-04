import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import 'package:google_fonts/google_fonts.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = true;
  bool isEditing = false;
  List savedQuestions = [];

  String originalName = '';
  String originalEmail = '';

  @override
  void initState() {
    super.initState();
    loadProfile();
    loadSavedQuestions();
  }

  void loadProfile() async {
    final profile = await ProfileService.getProfile();
    if (profile != null) {
      nameController.text = profile['username'] ?? '';
      emailController.text = profile['email'] ?? '';
      originalName = nameController.text;
      originalEmail = emailController.text;
    }
    setState(() => isLoading = false);
  }

  void loadSavedQuestions() async {
    final result = await ProfileService.getSavedQuestions();
    setState(() => savedQuestions = result ?? []);
  }

  void updateProfile() async {
    final success = await ProfileService.updateProfile(
      nameController.text,
      emailController.text,
      passwordController.text,
    );

    if (success) {
      originalName = nameController.text;
      originalEmail = emailController.text;
      setState(() => isEditing = false);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Profile updated' : 'Failed to update profile')),
    );
  }

  void toggleEditMode() {
    if (isEditing) {
      // Exit editing: restore previous values
      nameController.text = originalName;
      emailController.text = originalEmail;
      passwordController.clear();
    } else {
      // Enter editing: store original values safely
      originalName = nameController.text;
      originalEmail = emailController.text;
    }
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: toggleEditMode,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User Details",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  isEditing
                      ? Column(
                    children: [
                      TextField(
                        controller: nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "New Password",
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Update Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: ${nameController.text}",
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 15),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Email: ${emailController.text}",
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            Text(
              "Saved Questions",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: savedQuestions.length,
              itemBuilder: (context, index) {
                final q = savedQuestions[index];
                final questionData = q['question'];
                final answerData = q['answer'];

                String questionText = questionData is Map && questionData.containsKey('question')
                    ? questionData['question']
                    : 'Question ID: ${questionData.toString()}';

                String feedback = answerData?['feedback'] ?? '';
                String accuracy = answerData?['accuracy'] != null
                    ? '${(answerData['accuracy'] * 100).toStringAsFixed(1)}%'
                    : '';

                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Q: $questionText",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      if (feedback.isNotEmpty) ...[
                        SizedBox(height: 8),
                        Text(
                          "Feedback: $feedback",
                          style: GoogleFonts.poppins(
                            color: Colors.greenAccent,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      if (accuracy.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          "Accuracy: $accuracy",
                          style: GoogleFonts.poppins(
                            color: Colors.blueAccent,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}








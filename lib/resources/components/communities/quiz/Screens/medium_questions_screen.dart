import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:while_app/resources/components/message/models/community_user.dart';

class MediumQuestionsScreen extends StatefulWidget {
  final CommunityUser user;
  final void Function(String answer) onSelectAnswer;

  const MediumQuestionsScreen({super.key, required this.user, required this.onSelectAnswer});

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<MediumQuestionsScreen> {
  late List<Map<String, dynamic>> questions;
  int currentQuestionIndex = 0;

  void answerQuestion(String selectedAnswers) {
    widget.onSelectAnswer(selectedAnswers);
    setState(() {
      currentQuestionIndex = currentQuestionIndex +1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Questions'),
      ),
      body: FutureBuilder(
        future: _getQuestions(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No questions available.'),
            );
          }

          questions = snapshot.data!;
          final currentQuestion = questions[currentQuestionIndex];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                currentQuestion['question'],
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ..._buildAnswerButtons(currentQuestion),
            ],
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getQuestions() async {
    const category = 'Medium'; // Set the category as needed
    final querySnapshot = await FirebaseFirestore.instance
        .collection('communities')
        .doc(widget.user.id)
        .collection('quizzes')
        .doc(widget.user.id)
        .collection(category)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

 List<Widget> _buildAnswerButtons(Map<String, dynamic> question) {
  final options = question['options'];

  if (options is Map<String, dynamic>) {
    return options.keys.map((option) {
      return ElevatedButton(
        onPressed: () {
          // Handle the selected answer
          answerQuestion(option);
        },
        child: Text(options[option]),
      );
    }).toList();
  } else {
    // Handle the case where 'options' is not a Map
    return [const Text('Error: Options not available')];
  }
}


  // void _onAnswerSelected(String selectedAnswer) {
  //   // Handle the selected answer
  //   print('Selected Answer: $selectedAnswer');

  //   // Move to the next question or finish the quiz
  //   setState(() {
  //     currentQuestionIndex++;
  //   });

  //   if (currentQuestionIndex < questions.length) {
  //     // Display the next question
  //     print('Next Question: ${questions[currentQuestionIndex]['question']}');
  //   } else {
  //     // Quiz finished
  //     print('Quiz Finished');
  //   }
  // }
}

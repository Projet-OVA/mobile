
import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';
import '../../../services/quiz_service.dart';
import '../../../data/models/quiz_model.dart';
import 'quiz_result_screen.dart';

class QuizQuestionScreen extends StatefulWidget {
  final String quizId;
  final String quizTitle;

  const QuizQuestionScreen({
    super.key,
    required this.quizId,
    required this.quizTitle,
  });

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen>
    with SingleTickerProviderStateMixin {
  QuizDetail? quizDetail;
  bool isLoading = true;
  String? errorMessage;

  int currentQuestionIndex = 0;
  Map<String, String> userAnswers = {}; // questionId -> responseId

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadQuiz();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadQuiz() async {
    try {
      final quiz = await QuizService.getQuiz(widget.quizId);
      setState(() {
        quizDetail = quiz;
        isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _selectAnswer(String optionId) {
    setState(() {
      userAnswers[quizDetail!.questions[currentQuestionIndex].id] = optionId;
    });
  }

  Future<void> _nextQuestion() async {
    // Définir currentQuestion localement pour la validation
    final currentQuestion = quizDetail!.questions[currentQuestionIndex];

    // Vérifier qu'une réponse a été sélectionnée
    if (!userAnswers.containsKey(currentQuestion.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une réponse'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (currentQuestionIndex < quizDetail!.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      _animationController.reset();
      _animationController.forward();
    } else {
      // Dernière question - soumettre le quiz
      await _submitQuiz();
    }
  }

  Future<void> _submitQuiz() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFC113)),
      ),
    );

    try {
      final answers = userAnswers.entries
          .map((e) => QuizAnswer(questionId: e.key, responseId: e.value))
          .toList();

      final submission = QuizSubmission(
        quizId: widget.quizId,
        answers: answers,
      );

      final result = await QuizService.submitQuiz(submission);

      Navigator.pop(context); // Fermer le loader

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(result: result),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFFFFC113)),
        ),
      );
    }

    if (errorMessage != null || quizDetail == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Erreur de chargement'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    // Définir les variables locales
    final currentQuestion = quizDetail!.questions[currentQuestionIndex];
    final totalQuestions = quizDetail!.questions.length;
    final questionNumber = currentQuestionIndex + 1;
    final questionsRemaining = totalQuestions - currentQuestionIndex;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 28, color: Colors.black87),
                    ),
                    Text(
                      "$questionNumber/$totalQuestions",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Barre de progression
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: questionNumber / totalQuestions,
                    backgroundColor: const Color(0xFFFFECB6),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFC113)),
                    minHeight: 8,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Question Card
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20)
                        .add(const EdgeInsets.only(top: 30)),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC113),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFC113).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 45, 24, 24),
                      child: Column(
                        children: [
                          Text(
                            "Question $questionNumber",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.quizTitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            currentQuestion.content,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Cercle avec le nombre de questions restantes
                  Positioned(
                    top: 0,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC113),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "$questionsRemaining",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF232125),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Options de réponse
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: currentQuestion.options.asMap().entries.map((entry) {
                              final index = entry.key;
                              final option = entry.value;
                              final isSelected = userAnswers[currentQuestion.id] == option.id;
                              final letters = ['A', 'B', 'C', 'D', 'E', 'F'];

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _selectAnswer(option.id),
                                    borderRadius: BorderRadius.circular(12),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFFFFC113)
                                              : const Color(0xFFE0E0E0),
                                          width: isSelected ? 2 : 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${letters[index]}. ${option.content}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(
                                              Icons.check_circle,
                                              color: Color(0xFFFFC113),
                                              size: 24,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      // Bouton Suivant
                      SafeArea(
                        child: CustomButton(
                          text: currentQuestionIndex < totalQuestions - 1
                              ? "Suivant"
                              : "Terminer",
                          onPressed: _nextQuestion,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/custom_button.dart';
import '../../../services/quiz_service.dart';
import '../../../services/auth_storage.dart';
import '../../../data/models/quiz_model.dart';
import 'quiz_result_screen.dart';

class QuizQuestionScreen extends StatefulWidget {
  final String quizId;
  final String quizTitle;
  final int? resumeFromIndex; // ✅ Nouveau paramètre pour reprendre

  const QuizQuestionScreen({
    super.key,
    required this.quizId,
    required this.quizTitle,
    this.resumeFromIndex,
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

    // ✅ Initialiser d'abord avec resumeFromIndex si fourni
    if (widget.resumeFromIndex != null) {
      currentQuestionIndex = widget.resumeFromIndex!;
      print('✅ Initialized with resumeFromIndex: ${widget.resumeFromIndex}');
    }

    _loadQuiz();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// === CHARGEMENT DU QUIZ ===
  Future<void> _loadQuiz() async {
    try {
      final quiz = await QuizService.getQuiz(widget.quizId);
      setState(() {
        quizDetail = quiz;
      });

      // ✅ Charger la progression après avoir chargé le quiz
      await _loadProgress();

      setState(() {
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

  /// === SAUVEGARDE DE LA PROGRESSION ===
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progress = {
      'quizId': widget.quizId,
      'quizTitle': widget.quizTitle,
      'currentQuestionIndex': currentQuestionIndex,
      'userAnswers': userAnswers,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString('quiz_progress_${widget.quizId}', jsonEncode(progress));

    // ✅ IMPORTANT: Sauvegarder dans AuthStorage pour la reprise au démarrage
    await AuthStorage.saveQuizProgress(progress);
    await AuthStorage.saveLastPath('/quiz');

    print('✅ Quiz progress saved: Question ${currentQuestionIndex + 1}');
  }

  /// === REPRISE DE LA PROGRESSION ===
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('quiz_progress_${widget.quizId}');

    if (savedData != null) {
      final Map<String, dynamic> progress = jsonDecode(savedData);

      // ✅ Utiliser resumeFromIndex si fourni, sinon utiliser la progression sauvegardée
      int savedIndex = widget.resumeFromIndex ?? progress['currentQuestionIndex'] ?? 0;

      setState(() {
        currentQuestionIndex = savedIndex;
        userAnswers = Map<String, String>.from(progress['userAnswers'] ?? {});
      });

      print('✅ Quiz progress loaded: Question ${currentQuestionIndex + 1}');
    } else if (widget.resumeFromIndex != null) {
      // ✅ Si pas de progression sauvegardée mais index fourni
      setState(() {
        currentQuestionIndex = widget.resumeFromIndex!;
      });

      print('✅ Quiz resumed from index: ${widget.resumeFromIndex}');
    } else {
      print('✅ Starting new quiz');
    }
  }

  /// === SUPPRESSION DE LA PROGRESSION ===
  Future<void> _clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quiz_progress_${widget.quizId}');
    await AuthStorage.clearQuizProgress();
    await AuthStorage.clearLastPath();

    print('✅ Quiz progress cleared');
  }

  /// === SÉLECTION DE RÉPONSE ===
  void _selectAnswer(String optionId) {
    setState(() {
      userAnswers[quizDetail!.questions[currentQuestionIndex].id] = optionId;
    });
    _saveProgress(); // sauvegarde immédiate après sélection
  }

  /// === PASSER À LA QUESTION SUIVANTE ===
  Future<void> _nextQuestion() async {
    final currentQuestion = quizDetail!.questions[currentQuestionIndex];

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
      _saveProgress(); // ✅ sauvegarde progression avec la nouvelle question
      _animationController.reset();
      _animationController.forward();
    } else {
      await _submitQuiz();
    }
  }

  /// === SOUMETTRE LE QUIZ ===
  Future<void> _submitQuiz() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
      const Center(child: CircularProgressIndicator(color: Color(0xFFFFC113))),
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

      await _clearProgress(); // ✅ effacer la progression après succès

      if (!mounted) return;
      Navigator.pop(context); // fermer loader
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizResultScreen(result: result)),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  /// === GESTION DU RETOUR EN ARRIÈRE ===
  Future<bool> _onWillPop() async {
    // ✅ Sauvegarder la progression avant de quitter
    await _saveProgress();
    return true;
  }

  /// === GESTION DE LA FERMETURE ===
  Future<void> _handleClose() async {
    await _saveProgress();
    await AuthStorage.clearQuizProgress();
    if (!mounted) return;
    Navigator.pop(context);
  }

  /// === CONSTRUCTION UI ===
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(
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

    final currentQuestion = quizDetail!.questions[currentQuestionIndex];
    final totalQuestions = quizDetail!.questions.length;
    final questionNumber = currentQuestionIndex + 1;
    final questionsRemaining = totalQuestions - currentQuestionIndex;

    return WillPopScope(
      onWillPop: _onWillPop, // ✅ Sauvegarder avant de quitter
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // --- HEADER ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _handleClose,
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

                // --- BARRE DE PROGRESSION ---
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

                // --- QUESTION CARD ---
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

                    // --- CERCLE QUESTIONS RESTANTES ---
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

                // --- OPTIONS ---
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
                                final isSelected =
                                    userAnswers[currentQuestion.id] == option.id;
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
                                            horizontal: 20, vertical: 16),
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
                                              const Icon(Icons.check_circle,
                                                  color: Color(0xFFFFC113), size: 24),
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

                        // --- BOUTON SUIVANT / TERMINER ---
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
      ),
    );
  }
}
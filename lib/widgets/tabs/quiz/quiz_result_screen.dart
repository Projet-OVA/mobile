// screens/tabs/quiz/quiz_result_screen.dart

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../../data/models/quiz_model.dart';
import '../../../widgets/custom_button.dart';

class QuizResultScreen extends StatefulWidget {
  final QuizResult result;

  const QuizResultScreen({super.key, required this.result});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));

    // Déclencher les confettis immédiatement si le quiz est réussi
    if (widget.result.scorePercentage >= 50) {
      // Déclencher immédiatement après le build
      Future.microtask(() {
        if (mounted) {
          _confettiController.play();
        }
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPassed = widget.result.scorePercentage >= 50;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icône de résultat
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: isPassed
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPassed ? Icons.check_circle : Icons.cancel,
                              size: 80,
                              color: isPassed ? Colors.green : Colors.red,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Titre
                          Text(
                            isPassed ? 'Félicitations !' : 'Continuez vos efforts',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Score en grand
                          Container(
                            padding: const EdgeInsets.all(24),
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
                            child: Column(
                              children: [
                                Text(
                                  '${widget.result.scorePercentage}%',
                                  style: const TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Score obtenu',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Détails
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildStatRow(
                                  'Questions totales',
                                  '${widget.result.totalQuestions}',
                                  Icons.quiz,
                                ),
                                const Divider(height: 24),
                                _buildStatRow(
                                  'Réponses correctes',
                                  '${widget.result.correctAnswers}',
                                  Icons.check_circle_outline,
                                ),
                                const Divider(height: 24),
                                _buildStatRow(
                                  'Réponses incorrectes',
                                  '${widget.result.totalQuestions - widget.result.correctAnswers}',
                                  Icons.cancel_outlined,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Boutons d'action
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CustomButton(
                        text: 'Retour aux parcours',
                        onPressed: () async {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Widget de confettis - centré au milieu pour exploser dans toutes les directions
          if (isPassed)
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                particleDrag: 0.05,
                emissionFrequency: 0.02,
                numberOfParticles: 30,
                gravity: 0.2,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  Color(0xFFFFC113),
                  Colors.red,
                  Colors.yellow,
                  Colors.teal,
                  Colors.amber,
                ],
                maxBlastForce: 25,
                minBlastForce: 15,
                createParticlePath: (size) {
                  // Créer des particules carrées et rectangulaires
                  final path = Path();
                  path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
                  return path;
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFC113).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF232125), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../../custom_button.dart';

class Question extends StatefulWidget {
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> with SingleTickerProviderStateMixin {
  int currentQuestion = 1;
  int totalQuestions = 10;
  int? selectedAnswer;
  bool hasSubmitted = false;
  int correctAnswer = 1; // Index de la bonne réponse (0-based)

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<String> answers = [
    "A. Un devoir optionnel",
    "B. Un droit fondamental",
    "C. Un privilège réservé aux diplômés",
    "D. Une activité politique"
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color getAnswerColor(int index) {
    if (!hasSubmitted) {
      return selectedAnswer == index ? Colors.green : Colors.transparent;
    } else {
      if (index == correctAnswer) {
        return Colors.green;
      } else if (index == selectedAnswer && index != correctAnswer) {
        return Colors.red;
      }
      return Colors.transparent;
    }
  }

  IconData? getAnswerIcon(int index) {
    if (!hasSubmitted) {
      return selectedAnswer == index ? Icons.check_circle : null;
    } else {
      if (index == correctAnswer) {
        return Icons.check_circle;
      } else if (index == selectedAnswer && index != correctAnswer) {
        return Icons.cancel;
      }
      return null;
    }
  }

  void selectAnswer(int index) {
    if (!hasSubmitted) {
      setState(() {
        selectedAnswer = index;
      });
    }
  }

  void submitAnswer() {
    if (selectedAnswer != null && !hasSubmitted) {
      setState(() {
        hasSubmitted = true;
      });

      // Simulation d'une transition vers la question suivante après 2 secondes
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            currentQuestion++;
            selectedAnswer = null;
            hasSubmitted = false;
          });
          _animationController.reset();
          _animationController.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header avec croix et progress
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32 : 20,
                    vertical: isTablet ? 24 : 16
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        size: isTablet ? 32 : 28,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "$currentQuestion/$totalQuestions",
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Barre de progression
              Container(
                margin: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: currentQuestion / totalQuestions,
                    backgroundColor: Color(0xFFFFECB6),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC113)),
                    minHeight: isTablet ? 12 : 8,
                  ),
                ),
              ),

              SizedBox(height: isTablet ? 40 : 30),

              // Question Card
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20)
                        .add(EdgeInsets.only(top: isTablet ? 40 : 30)),
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFC113), Color(0xFFFFC113)],
                      ),
                      borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFC113).withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        isTablet ? 32 : 24,
                        isTablet ? 60 : 45,
                        isTablet ? 32 : 24,
                        isTablet ? 32 : 24,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Question $currentQuestion",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Citoyenneté & Droits",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Le droit de voter est :",
                            style: TextStyle(
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

                  // Cercle positionné sur le bord supérieur
                  Positioned(
                    top: 0,
                    child: Container(
                      width: isTablet ? 80 : 60,
                      height: isTablet ? 80 : 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFC113),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "${totalQuestions - currentQuestion + 1}",
                          style: TextStyle(
                            fontSize: isTablet ? 28 : 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF232125),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: isTablet ? 40 : 30),

              // Réponses + bouton en bas
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 20),
                  child: Column(
                    children: [
                      // Liste scrollable des réponses
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: answers.asMap().entries.map((entry) {
                              int index = entry.key;
                              String answer = entry.value;

                              return Container(
                                margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => selectAnswer(index),
                                    borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      width: double.infinity,
                                      constraints: BoxConstraints(
                                        maxWidth: isTablet ? 600 : double.infinity,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isTablet ? 24 : 20,
                                        vertical: isTablet ? 20 : 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                                        border: Border.all(
                                          color: getAnswerColor(index) != Colors.transparent
                                              ? getAnswerColor(index)
                                              : Color(0xFFE0E0E0),
                                          width: getAnswerColor(index) != Colors.transparent ? 2 : 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              answer,
                                              style: TextStyle(
                                                fontSize: isTablet ? 18 : 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          if (getAnswerIcon(index) != null)
                                            Icon(
                                              getAnswerIcon(index),
                                              color: getAnswerColor(index),
                                              size: isTablet ? 28 : 24,
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

                      // Bouton toujours visible
                      SafeArea(
                        child: CustomButton(
                          text: "Suivant",
                          onPressed: selectedAnswer != null ? submitAnswer : null,
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

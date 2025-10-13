import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../data/models/course_model.dart';
import 'course_card.dart';

class CourseCarousel extends StatefulWidget {
  final List<Course> courses;

  const CourseCarousel({
    super.key,
    required this.courses,
  });

  @override
  State<CourseCarousel> createState() => _CourseCarouselState();
}

class _CourseCarouselState extends State<CourseCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Si aucun cours n'est disponible
    if (widget.courses.isEmpty) {
      return Container(
        height: 230,
        alignment: Alignment.center,
        child: const Text(
          'Aucun parcours disponible',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      );
    }

    return CarouselSlider.builder(
      itemCount: widget.courses.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        final course = widget.courses[itemIndex];
        // Passer l'information si la carte est active (visible au centre)
        final isActive = itemIndex == _currentIndex;
        
        return CourseCard(
          course: course,
          isActive: isActive,
          key: ValueKey(course.id),
        );
      },
      options: CarouselOptions(
        height: 230,
        viewportFraction: 0.52,
        initialPage: 0,
        enableInfiniteScroll: widget.courses.length > 1,
        autoPlay: false,
        enlargeCenterPage: false,
        padEnds: false,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/course_plans_repo.dart';

class CoursePlanBuilder extends StatefulWidget {
  final String? courseId;
  final VoidCallback? onNotFound;
  final Function(CoursePlanModel course)? onFound;
  final Widget Function(
    BuildContext context,
    CoursePlanController controller,
  ) builder;

  const CoursePlanBuilder({
    super.key,
    required this.courseId,
    required this.builder,
    this.onNotFound,
    this.onFound,
  });

  @override
  State<CoursePlanBuilder> createState() => CoursePlanController();
}

class CoursePlanController extends State<CoursePlanBuilder> {
  bool loading = true;
  Object? error;

  CoursePlanModel? course;

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  @override
  void didUpdateWidget(covariant CoursePlanBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courseId != widget.courseId) {
      _loadCourse();
    }
  }

  Future<void> _loadCourse() async {
    if (widget.courseId == null) {
      setState(() {
        loading = false;
        error = null;
        course = null;
      });
      return;
    }

    try {
      setState(() {
        loading = true;
        error = null;
      });

      course = await CoursePlansRepo.get(widget.courseId!);
      course == null
          ? widget.onNotFound?.call()
          : widget.onFound?.call(course!);
    } catch (e) {
      error = e;
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, this);
}

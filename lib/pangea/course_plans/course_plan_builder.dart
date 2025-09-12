import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/course_plans_repo.dart';

class CoursePlanBuilder extends StatefulWidget {
  final String? courseId;
  final VoidCallback? onNotFound;
  final Function(CoursePlanModel course)? onLoaded;
  final Widget Function(
    BuildContext context,
    CoursePlanController controller,
  ) builder;

  const CoursePlanBuilder({
    super.key,
    required this.courseId,
    required this.builder,
    this.onNotFound,
    this.onLoaded,
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
    setState(() {
      loading = false;
      error = null;
      course = null;
    });

    if (widget.courseId == null) {
      return;
    }

    try {
      setState(() {
        loading = true;
        error = null;
      });

      course = await CoursePlansRepo.get(widget.courseId!);

      widget.onLoaded?.call(course!);
    } catch (e) {
      widget.onNotFound?.call();
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

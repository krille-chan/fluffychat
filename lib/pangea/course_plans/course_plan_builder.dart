import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';

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
    _initStorage().then((_) {
      if (mounted) _loadCourse();
    });
  }

  @override
  void didUpdateWidget(covariant CoursePlanBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courseId != widget.courseId) {
      _loadCourse();
    }
  }

  Future<void> _initStorage() async {
    final futures = [
      GetStorage.init("course_storage"),
      GetStorage.init("course_activity_storage"),
      GetStorage.init("course_location_media_storage"),
      GetStorage.init("course_location_storage"),
      GetStorage.init("course_media_storage"),
      GetStorage.init("course_topic_storage"),
    ];

    await Future.wait(futures);
  }

  Future<void> _loadCourse() async {
    setState(() {
      loading = true;
      error = null;
      course = null;
    });

    if (widget.courseId == null) {
      widget.onNotFound?.call();
      setState(() => loading = false);
      return;
    }

    try {
      course = await CoursePlansRepo.get(widget.courseId!);
      widget.onLoaded?.call(course!);
    } catch (e) {
      widget.onNotFound?.call();
      error = e;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, this);
}

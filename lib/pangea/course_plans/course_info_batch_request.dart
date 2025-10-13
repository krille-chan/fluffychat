class CourseInfoBatchRequest {
  final String batchId;
  final List<String> uuids;

  CourseInfoBatchRequest({
    required this.batchId,
    required this.uuids,
  });
}

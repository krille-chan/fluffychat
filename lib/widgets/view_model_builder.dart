import 'package:flutter/material.dart';

class ViewModelBuilder<T extends ValueNotifier> extends StatefulWidget {
  final T Function() create;
  final Widget Function(BuildContext context, T viewModel, Widget? child)
  builder;
  final Widget? child;
  const ViewModelBuilder({
    super.key,
    required this.create,
    required this.builder,
    this.child,
  });

  @override
  State<ViewModelBuilder<T>> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T extends ValueNotifier>
    extends State<ViewModelBuilder<T>> {
  late final T _viewModel;

  @override
  void initState() {
    _viewModel = widget.create();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _viewModel,
      builder: (context, value, child) =>
          widget.builder.call(context, _viewModel, child),
    );
  }
}

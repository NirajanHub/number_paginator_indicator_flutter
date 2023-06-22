import 'package:flutter/material.dart';
import 'package:number_paginator_indicator_flutter/number_paginator.dart';
import 'package:number_paginator_indicator_flutter/src/ui/widgets/buttons/paginator_icon_button.dart';
import 'package:number_paginator_indicator_flutter/src/ui/widgets/inherited_number_paginator.dart';
import 'package:number_paginator_indicator_flutter/src/ui/widgets/paginator_content.dart';

typedef NumberPaginatorContentBuilder = Widget Function(int index);

/// The main widget used for creating a [NumberPaginator].
class NumberPaginator extends StatefulWidget {
  /// Total number of pages that should be shown.
  final int numberPages;

  /// Index of initially selected page.
  final int initialPage;

  /// This function is called when the user switches between pages. The received
  /// parameter indicates the selected index, starting from 0.
  final Function(int)? onPageChange;

  /// The UI config for the [NumberPaginator].
  final NumberPaginatorUIConfig config;

  /// A builder for the central content of the paginator. If provided, the
  /// [config] is ignored.
  final NumberPaginatorContentBuilder? contentBuilder;

  final NumberPaginatorController? controller;
  final Widget leftArrowIcon;
  final Widget rightArrowIcon;

  /// Creates an instance of [NumberPaginator].
  const NumberPaginator({
    Key? key,
    required this.numberPages,
    this.initialPage = 0,
    this.onPageChange,
    this.config = const NumberPaginatorUIConfig(),
    this.contentBuilder,
    this.controller,
    this.leftArrowIcon = const Icon(Icons.chevron_left),
    this.rightArrowIcon = const Icon(Icons.chevron_right),
  })  : assert(initialPage >= 0),
        assert(initialPage <= numberPages - 1),
        super(key: key);

  @override
  NumberPaginatorState createState() => NumberPaginatorState();
}

class NumberPaginatorState extends State<NumberPaginator> {
  late NumberPaginatorController _controller;
  late Widget _leftArrowIcon;
  late Widget _rightArrowIcon;

  @override
  void initState() {
    super.initState();
    _leftArrowIcon = widget.leftArrowIcon;
    _rightArrowIcon = widget.rightArrowIcon;
    _controller = widget.controller ?? NumberPaginatorController();
    _controller.currentPage = widget.initialPage;
    _controller.addListener(() {
      widget.onPageChange?.call(_controller.currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InheritedNumberPaginator(
      numberPages: widget.numberPages,
      initialPage: widget.initialPage,
      onPageChange: _controller.navigateToPage,
      config: widget.config,
      child: SizedBox(
        height: widget.config.height,
        child: Row(
          mainAxisAlignment: widget.config.mainAxisAlignment,
          children: [
            PaginatorIconButton(
              onPressed: _controller.currentPage > 0 ? _controller.prev : null,
              icon: _leftArrowIcon,
            ),
            ..._buildCenterContent(),
            PaginatorIconButton(
              onPressed: _controller.currentPage < widget.numberPages - 1
                  ? _controller.next
                  : null,
              icon: _rightArrowIcon,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCenterContent() {
    return [
      if (widget.contentBuilder != null)
        Container(
          padding: widget.config.contentPadding,
          child: widget.contentBuilder!(_controller.currentPage),
        )
      else if (widget.config.mode != ContentDisplayMode.hidden)
        Expanded(
          child: Container(
            padding: widget.config.contentPadding,
            child: PaginatorContent(
              currentPage: _controller.currentPage,
            ),
          ),
        ),
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:here2there_kids/components/search_input_bar.dart';
import 'package:here2there_kids/components/search_suggestions_dialog.dart';

class SearchOverlay<T> extends StatefulWidget {
  final String Function(T) itemLabel;
  final String Function(T) itemDescription;
  final void Function(T) onItemSelected;
  final String hintText;
  final Future<List<T>> Function(String)? onChanged;

  const SearchOverlay({
    super.key,
    required this.itemLabel,
    required this.onItemSelected,
    this.hintText = 'Buscar...',
    this.onChanged,
    required this.itemDescription,
  });

  @override
  State<SearchOverlay<T>> createState() => _SearchOverlayState<T>();
}

class _SearchOverlayState<T> extends State<SearchOverlay<T>> {
  bool _showDialog = false;

  void _toggle() => setState(() => _showDialog = !_showDialog);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child:
          _showDialog
              ? Container(
                key: const ValueKey('dialog'),
                alignment: Alignment.topCenter,
                child: SearchSuggestionsDialog<T>(
                  itemLabel: widget.itemLabel,
                  itemDescription: widget.itemDescription,
                  onItemSelected: (item) {
                    widget.onItemSelected(item);
                    _toggle();
                  },
                  hintText: widget.hintText,
                  onChanged: widget.onChanged,
                  goBack: _toggle,
                ),
              )
              : Container(
                key: const ValueKey('bar'),
                alignment: Alignment.topCenter,
                child: SearchInputBar(
                  onTap: _toggle,
                  hintText: widget.hintText,
                ),
              ),
    );
  }
}

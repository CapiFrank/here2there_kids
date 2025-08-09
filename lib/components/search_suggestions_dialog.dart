import 'package:flutter/material.dart';

class SearchSuggestionsDialog<T> extends StatefulWidget {
  final Future<List<T>> Function(String)? onChanged;
  final String Function(T) itemLabel;
  final String Function(T) itemDescription;
  final void Function(T) onItemSelected;
  final VoidCallback goBack;
  final String hintText;

  const SearchSuggestionsDialog({
    super.key,
    required this.itemLabel,
    required this.itemDescription,
    required this.onItemSelected,
    required this.goBack,
    this.hintText = 'Buscar...',
    this.onChanged,
  });

  @override
  State<SearchSuggestionsDialog<T>> createState() =>
      _SearchSuggestionsDialogState<T>();
}

class _SearchSuggestionsDialogState<T>
    extends State<SearchSuggestionsDialog<T>> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<T> _filteredItems = [];
  bool _showResults = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _onSearchChanged(String value) async {
    if (value.isEmpty || widget.onChanged == null) {
      setState(() {
        _filteredItems = [];
        _showResults = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showResults = true;
    });

    final results = await widget.onChanged!(value);

    setState(() {
      _filteredItems = results;
      _isLoading = false;
    });
  }

  void _selectItem(T item) {
    widget.onItemSelected(item);
    _controller.text = widget.itemLabel(item);
    _hideResults();
  }

  void _hideResults() {
    setState(() => _showResults = false);
    _focusNode.unfocus();
  }

  Widget _buildSearchBar() {
    return Material(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(100),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.goBack,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _onSearchChanged,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _onSearchChanged(_controller.text),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (!_showResults) return const SizedBox.shrink();

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator(color: Colors.blue,)),
      );
    }

    if (_filteredItems.isEmpty) {
      return const ListTile(title: Text('No se encontraron resultados'));
    }

    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          final label = widget.itemLabel(item);
          final description = widget.itemDescription(item);
          return ListTile(
            title: Text(label),
            subtitle: Text(description),
            onTap: () => _selectItem(item),
          );
        },
        separatorBuilder: (_, _) => Divider(height: 1, color: Colors.grey[300]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildSearchBar(), if (_showResults) _buildResults()],
      ),
    );
  }
}

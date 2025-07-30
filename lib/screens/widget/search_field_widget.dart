import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchFieldWidget extends StatefulWidget {
  final Function(String) onSearch;
  final TextEditingController controller;

  const SearchFieldWidget({
    super.key,
    required this.onSearch,
    required this.controller,
  });

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  List<String> _history = [];
  final String _historyKey = 'search_history';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList(_historyKey) ?? [];
    });
  }

  Future<void> _saveHistory(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _history.remove(value); // remove duplicates
    _history.insert(0, value); // insert latest at top
    if (_history.length > 10) _history = _history.sublist(0, 10); // limit size
    await prefs.setStringList(_historyKey, _history);
  }

  Future<void> _clearAllHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    setState(() => _history.clear());
  }

  Future<void> _removeFromHistory(String item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _history.remove(item);
    await prefs.setStringList(_historyKey, _history);
    setState(() {});
  }

  void _submitSearch(String value) {
    if (value.isEmpty) return;
    widget.onSearch(value);
    _saveHistory(value);
    widget.controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          onSubmitted: _submitSearch,
          decoration: InputDecoration(
            hintText: "Search movies",
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => widget.controller.clear(),
            ),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (_history.isNotEmpty)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Recent Searches", style: TextStyle(color: Colors.white70)),
                    Spacer(),
                    TextButton(
                      onPressed: _clearAllHistory,
                      child: Text("Clear all", style: TextStyle(color: Colors.blueAccent)),
                    )
                  ],
                ),
                ..._history.map(
                      (item) => ListTile(
                    leading: Icon(Icons.history, color: Colors.grey),
                    title: Text(item, style: TextStyle(color: Colors.white)),
                    trailing: IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => _removeFromHistory(item),
                    ),
                    onTap: () => _submitSearch(item),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}

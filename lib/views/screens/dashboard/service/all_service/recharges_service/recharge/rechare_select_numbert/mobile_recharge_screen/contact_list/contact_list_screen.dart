import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:flutter/material.dart';
import 'package:lekra/services/theme.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  /// Fix for UTF-16 errors (invalid characters in name)
  String sanitize(String? text) {
    if (text == null) return '';
    try {
      return text;
    } catch (_) {
      return '';
    }
  }

  Future<void> _loadContacts() async {
    try {
      final Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);

      final validContacts =
          contacts.where((c) => (c.phones?.isNotEmpty ?? false)).toList();

      setState(() {
        _allContacts = validContacts;
        _filteredContacts = validContacts;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("CONTACT LOAD ERROR: $e");
      setState(() => _isLoading = false);
    }
  }

  /// Extract primary number
  String _primaryNumber(Contact c) {
    if (c.phones == null || c.phones!.isEmpty) return '';
    return sanitize(c.phones!.first.value).replaceAll(RegExp(r'\s+|-'), '');
  }

  /// Search logic
  void _searchContacts(String value) {
    final query = value.toLowerCase();
    setState(() {
      _filteredContacts = _allContacts.where((contact) {
        final name = sanitize(contact.displayName).toLowerCase();
        final number = _primaryNumber(contact);

        return name.contains(query) || number.contains(query);
      }).toList();
    });
  }

  Widget _buildAvatar(Contact c) {
    try {
      if (c.avatar != null && c.avatar!.isNotEmpty) {
        return CircleAvatar(backgroundImage: MemoryImage(c.avatar!));
      }
    } catch (_) {}
    return CircleAvatar(child: Text(sanitize(c.initials())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select contact",
          style: TextStyle(color: white),
        ),
      ),
      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: _searchContacts,
              decoration: InputDecoration(
                hintText: "Search name or number",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: _filteredContacts.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final c = _filteredContacts[index];
                      final number = _primaryNumber(c);
                      final name = sanitize(c.displayName);

                      return ListTile(
                        leading: _buildAvatar(c),
                        title: Text(name),
                        subtitle: Text(number),
                        onTap: () {
                          Navigator.of(context).pop(number);
                        },
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}

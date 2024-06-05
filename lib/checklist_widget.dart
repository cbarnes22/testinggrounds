import 'package:flutter/material.dart';

class ChecklistWidget extends StatefulWidget {
  const ChecklistWidget({super.key});

  @override
  ChecklistWidgetState createState() => ChecklistWidgetState();
}

class ChecklistWidgetState extends State<ChecklistWidget> {
  List<ChecklistItem> items = [];

  void _addItem(String itemName) {
    setState(() {
      items.add(ChecklistItem(name: itemName, isChecked: false));
    });
  }

  void _toggleItemCheck(int index) {
    setState(() {
      items[index].isChecked = !items[index].isChecked;
    });
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Checklist',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(
                    item.name,
                    style: TextStyle(
                      decoration:
                          item.isChecked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: item.isChecked,
                        onChanged: (value) => _toggleItemCheck(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteItem(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddItemDialog(onAddItem: _addItem);
                },
              );
            },
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }
}

class ChecklistItem {
  String name;
  bool isChecked;

  ChecklistItem({required this.name, required this.isChecked});
}

class AddItemDialog extends StatefulWidget {
  final Function(String) onAddItem;

  const AddItemDialog({super.key, required this.onAddItem});

  @override
  AddItemDialogState createState() => AddItemDialogState();
}

class AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Checklist Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Item Name'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Add'),
          onPressed: () {
            final itemName = nameController.text;
            widget.onAddItem(itemName);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

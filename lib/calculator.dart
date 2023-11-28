import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String? selectedCategory;

  Map<String, int> selectedRoles = {};

  int projectDuration = 1;

  final Map<String, List<String>> _categories = {
    'Mobile Application Development': [
      'Front end engineer',
      'Back end engineer',
      'Solution Architect',
      'Project manager',
      'Designer',
    ],
    // Add more categories here
  };

  final Map<String, int> _experienceLevels = {
    'Junior': 5000,
    'Mid-level': 7000,
    'Senior': 9000,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
            hint: const Text('Select Category'),
            value: selectedCategory,
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
            items: _categories.keys.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
          const Text(
            'Select Roles:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Wrap(
            children: _categories[selectedCategory]?.map((String role) {
                  int teamSize = selectedRoles.containsKey(role)
                      ? selectedRoles[role]!
                      : 0;

                  return Container(
                    width: 280,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              _updateTeamSize(role, teamSize - 1);
                            },
                            icon: const Icon(Icons.remove)),
                        Text('$role ($teamSize)'),
                        IconButton(
                            onPressed: () {
                              _updateTeamSize(role, teamSize + 1);
                            },
                            icon: const Icon(Icons.add)),
                      ],
                    ),
                  );
                }).toList() ??
                [],
          ),
          _buildDropdown(
            label: 'Select Project Duration (months)',
            value: projectDuration.toString(),
            onChanged: (value) {
              setState(() {
                projectDuration = int.tryParse(value!) ?? 1;
              });
            },
            items: ['1', '2', '3', '4', '5'].toList(),
          ),
          const SizedBox(height: 16.0),
          const Text('Estimated Budget'),
          Text('\$${_calculateBudget()}'),
        ],
      ),
    );
  }

  void _updateTeamSize(String role, int teamSize) {
    setState(() {
      selectedRoles = {...selectedRoles, role: teamSize};
    });
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required Function(String?) onChanged,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          hint: Text('Select $label'),
          value: value,
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  int _calculateBudget() {
    int totalBudget = 0;
    selectedRoles.forEach((role, teamSize) {
      totalBudget += teamSize *
          (_experienceLevels[_getExperienceLevel(role)] ?? 0) *
          projectDuration;
    });
    return totalBudget;
  }

  String _getExperienceLevel(String role) {
    return selectedRoles.containsKey(role)
        ? _experienceLevels.keys.firstWhere(
            (level) => _experienceLevels[level] == _experienceLevels[role],
            orElse: () => 'Junior',
          )
        : 'Junior';
  }
}

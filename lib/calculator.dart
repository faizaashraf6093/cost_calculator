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
      'Designer'
    ],
    // Add more categories here
  };

  final Map<String, int> _experienceLevels = {
    'Junior': 5000,
    'Mid-level': 7000,
    'Senior': 9000
  };

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildDropdown('Select Category', _categories.keys,
                (value) => setState(() => selectedCategory = value)),
            Center(child: _buildRoleSelection(height)),
            const SizedBox(height: 16.0),
            _buildDropdown(
                'Select Project Duration (months)',
                ['1', '2', '3', '4', '5'],
                (value) => setState(
                    () => projectDuration = int.tryParse(value!) ?? 1)),
            const SizedBox(height: 16.0),
            _buildEstimatedBudget(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label, Iterable<String> items, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          alignment: Alignment.center,
          focusColor: Colors.transparent,
          hint: Text('Select $label'),
          value: label == 'Select Category'
              ? selectedCategory
              : projectDuration.toString(),
          onChanged: onChanged,
          items: items
              .toList()
              .map((item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)))
              .toList(),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildRoleSelection(double height) {
    return selectedCategory != null && selectedCategory != ''
        ? Wrap(
          children: _categories[selectedCategory!]
                  ?.map((role) => _buildRoleContainer(role))
                  .toList() ??
              [],
        )
        : SizedBox(
            height: height * 0.4,
            child: const Center(
              child: Text(
                'Please select any category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          );
  }

  Widget _buildRoleContainer(String role) {
    int teamSize = selectedRoles.containsKey(role) ? selectedRoles[role]! : 0;
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () => _updateTeamSize(role, teamSize - 1),
              icon: const Icon(Icons.remove)),
          Text('$role ($teamSize)'),
          IconButton(
              onPressed: () => _updateTeamSize(role, teamSize + 1),
              icon: const Icon(Icons.add)),
        ],
      ),
    );
  }

  Widget _buildEstimatedBudget() {
    return Column(
      children: [
        const Text('Estimated Budget',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('\$${_calculateBudget()}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _updateTeamSize(String role, int teamSize) {
    if (teamSize >= 0) {
      setState(() => selectedRoles = {...selectedRoles, role: teamSize});
    }
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

  String _getExperienceLevel(String role) => selectedRoles.containsKey(role)
      ? _experienceLevels.keys.firstWhere(
          (level) => _experienceLevels[level] == _experienceLevels[role],
          orElse: () => 'Junior')
      : 'Junior';
}

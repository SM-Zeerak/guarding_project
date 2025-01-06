import 'package:flutter/material.dart';
import 'package:guarding_project/utils/Color%20Utils/color_utils.dart';

class CustomGenderDropdown extends StatelessWidget {
  final String? selectedGender;
  final Function(String?) onChanged;
  final IconData? prefixIcon;

  CustomGenderDropdown({
    Key? key,
    required this.selectedGender,
    required this.onChanged,
    this.prefixIcon,
  }) : super(key: key);

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedGender != '' ? selectedGender : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ClrUtils.greyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ClrUtils.greyColor),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
      ),
      hint: const Text(
        'Select Gender',
        style: TextStyle(color: Colors.grey),
      ),
      items: _genderOptions.map((gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a gender';
        }
        return null;
      },
    );
  }
}

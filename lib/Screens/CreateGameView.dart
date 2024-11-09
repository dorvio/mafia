import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/CustomTextFormField.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';


class CreateGameView extends StatefulWidget {
  const CreateGameView({Key? key}) : super(key: key);

  @override
  State<CreateGameView> createState() => _CreateGameViewState();
}

class _CreateGameViewState extends State<CreateGameView> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String playerName = '';
  List<String> _selectedItems = [];
  final List<MultiSelectItem<String>> _items = [
    MultiSelectItem("Prokurator", "Prokurator"),
    MultiSelectItem("Obrońca", "Obrońca"),
    MultiSelectItem("Bimbrownik", "Bimbrownik"),
    MultiSelectItem("Grabarz", "Grabarz"),
    MultiSelectItem("Burmistrz", "Burmistrz"),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Utwórz gre',
              style: GoogleFonts.creepster(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 186, 86, 36),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    initialValue: null,
                    onChanged: (text) {
                      setState(() => playerName = text);
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Uzupełnij pole';
                      }
                      return null;
                    },
                    labelText: 'Nick gracza',
                    maxLength : 30,
                  ),
                  MultiSelectDialogField(
                      items: _items,
                    onConfirm: (results) {
                      setState(() {
                        _selectedItems = results.cast<String>();
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){

                      }
                    },
                    child: Text('Utwórz')),
                SizedBox(width: 30),
                ElevatedButton(onPressed: () => goBack(context), child: Text('Cofnij ')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void goBack(BuildContext context) {
  Navigator.pop(context);
}
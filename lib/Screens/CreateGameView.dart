import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/CustomTextFormField.dart';
// import '../Widgets/CustomMultiselect.dart';
import 'package:number_picker/number_picker.dart';
import 'package:multiselect/multiselect.dart';


class CreateGameView extends StatefulWidget {
  const CreateGameView({Key? key}) : super(key: key);

  @override
  State<CreateGameView> createState() => _CreateGameViewState();
}

class _CreateGameViewState extends State<CreateGameView> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String playerName = '';
  List<String> roles = ["Bimbrownik", "Prokurator","Obrońca","Burmistrz", "Grabarz"];
  List<IconData> roleIcons = [Icons.wine_bar, Icons.gavel, Icons.favorite, Icons.cases_outlined, Icons.church];
  int pauseTime = 0;
  List<String> selectedRoles = [];


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
                    labelText: 'Nazwa gracza',
                    maxLength : 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Multiselect(
              itemText: roles,
              // itemIcons: roleIcons,
              backgroundColor: const Color.fromARGB(255, 33, 33, 33),
              borderColor: const Color.fromARGB(255, 186, 86, 36),
              labelText: 'Wybierz role',
              labelTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              borderRadius: 30.0,
              optionListBackgroundColor: const Color.fromARGB(255, 186, 86, 36),
              initialValues: roles,
              onValueChange: (values){
                selectedRoles = values;
              },
            ),
            SizedBox(height: 30),
            const Text(
              'Czas na podjęcie wyboru',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            NumberPicker(
              minValue: 1,
              maxValue: 10,
              initialValue: 2,
              backgroundColor: Color.fromARGB(255, 33, 33, 33),
              buttonColor: Color.fromARGB(255, 186, 86, 36),
              borderColor: Color.fromARGB(255, 186, 86, 36),
              borderRadius: 30.0,
              textColor: Colors.white,
              iconColor: Colors.white,
              onValueChange: (newValue) {
                pauseTime = newValue;
              },
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
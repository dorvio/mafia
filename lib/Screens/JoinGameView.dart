import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/CustomTextFormField.dart';

class JoinGameView extends StatefulWidget {
  const JoinGameView({Key? key}) : super(key: key);

  @override
  State<JoinGameView> createState() => _JoinGameViewState();
}

class _JoinGameViewState extends State<JoinGameView> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String playerName = '';

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
              'Dołacz do gry',
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
              child: CustomTextFormField(
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
                    child: Text('Dołącz')),
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
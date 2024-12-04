import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/Screens/GameView.dart';
import 'package:mafia/Services/SupabaseServices.dart';
import '../Classes/Game.dart';
import '../Classes/Player.dart';
import '../Widgets/CustomTextFormField.dart';
import 'package:number_picker/number_picker.dart';
import 'package:multiselect/multiselect.dart';
import 'package:mafia/constants.dart';


class CreateGameView extends StatefulWidget {
  const CreateGameView({Key? key}) : super(key: key);

  @override
  State<CreateGameView> createState() => _CreateGameViewState();
}

class _CreateGameViewState extends State<CreateGameView> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String playerName = '';
  int playerId = -1;
  List<String> roles = ["Bimbrownik", "Prokurator","Obrońca","Burmistrz", "Grabarz"];
  List<IconData> roleIcons = [Icons.sports_bar, Icons.person_search_rounded, Icons.healing, Icons.museum, Icons.church];
  int pauseTime = 0;
  List<String> selectedRoles = [];
  SupabaseServices supabaseServices = SupabaseServices();
  Game? game;
  int playersCount = 1;
  late Stream<int> playerCountStream;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset : false,
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
                    color: ORANGE,
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
                  maxLines: 1,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              const SizedBox(height: 30),
              Multiselect(
                itemText: roles,
                itemIcons: roleIcons,
                backgroundColor: const Color.fromARGB(255, 33, 33, 33),
                borderColor: ORANGE,
                labelText: 'Wybierz role',
                labelTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                borderRadius: 30.0,
                optionListBackgroundColor: ORANGE,
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
                buttonColor: ORANGE,
                borderColor: ORANGE,
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (game == null) {
                          game = await supabaseServices.createGame();
                          if (game != null) {
                            playerId = await supabaseServices.createPlayer(playerName, game!.gameId);
                            _showLobbyDialog();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Nie udało się utworzyć gry. Spróbuj ponownie.')),
                            );
                          }
                        } else {
                          _showLobbyDialog();
                        }
                      }
                    },
                    child: Text('Utwórz'),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(onPressed: () => goBack(context), child: Text('Cofnij ')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLobbyDialog() {
    bool notMinPlayer = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            supabaseServices.subscribeToPlayerChanges(game!.gameId, (newCount) {
              setState(() {
                playersCount = newCount;
              });
            });

            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text(
                'Lobby',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kod gry: ${game!.gameCode}\n"
                        "Liczba graczy w lobby: $playersCount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (notMinPlayer)
                    const Text(
                      "Do gry potrzeba conajmniej 3 graczy.",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: ORANGE,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Rozpocznij'),
                  onPressed: () async {
                    if (playersCount >= 3) {
                      bool statusUpdated = await supabaseServices.updateGameStatus(game!.gameId, 1);
                      List<int> rolesId = getRolesId();
                      await supabaseServices.assignRoles(rolesId, game!.gameId);
                      startGame(context, playerId);
                    } else {
                      setState(() {
                        notMinPlayer = true;
                      });
                    }
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: ORANGE,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Cofnij'),
                  onPressed: () async {
                    supabaseServices.unsubscribeFromPlayerChanges();
                    supabaseServices.unsubscriveAllChanels();
                    await supabaseServices.deleteGame(game!.gameId);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<int> getRolesId() {
    List<int> list = [1, 2, 3, 4, 5];
    Map<String, int> roleMapping = {
      "Obrońca": 1,
      "Prokurator": 2,
      "Bimbrownik": 3,
      "Grabarz": 4,
      "Burmistrz": 5,
    };

    List<int> selectedRolesIds = selectedRoles.map((role) => roleMapping[role]!).toList();

    list.removeWhere((id) => selectedRolesIds.contains(id));

    return list;
  }

}

void goBack(BuildContext context) {
  Navigator.pop(context);
}

void startGame(BuildContext context, int playerId){
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => GameView(playerId: playerId)),
        (Route<dynamic> route) => false,
  );

}


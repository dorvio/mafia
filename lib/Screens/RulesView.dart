import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/constants.dart';

class RulesView extends StatelessWidget {
  const RulesView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'ZASADY',
                style: GoogleFonts.creepster(
                  textStyle: const TextStyle(
                    color: ORANGE,
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                  ),
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle('Przygotowanie do gry:'),
                          Text(
                            textAlign: TextAlign.justify,
                            'Któryś z graczy uruchamia aplikacje oraz tworzy rozgrywkę, dalej nazywany gospodarzem.\n'
                                'Zanim gospodarz utworzy rozgrywkę, może wybrać, jakie role będą dostępne oraz ile czasu gracze będą mieli na wybory.\n'
                                'Pozostali gracze dołączają do rozgrywki, jako goście, poprzez kod, udostępniony przez gospodarza.\n'
                                'Gospodarz widzi graczy w swojej rozgrywce.\n'
                                'W momencie, gdy wszyscy gracze są gotowi, gospodarz może uruchomić rozgrywkę, od tej pory nie będzie można już dołączyć do gry.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          SectionTitle('Cel rozgrywki:'),
                          Text(
                            textAlign: TextAlign.justify,
                            'Tak jak w przypadku karcianej wersji gry:\n'
                                'W grze toczy się walka pomiędzy postaciami mafii a miastem.\n'
                                'Celem postaci z miasta jest wyeliminowane mafii, natomiast celem mafii jest doprowadzenie do sytuacji, '
                                'gdzie ilość postaci z miasta będzie mniejsza lub równa postaciom z mafii.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          SectionTitle('Przebieg rozgrywki:'),
                          SubsectionTitle('Przebieg nocy:'),
                          Text(
                            textAlign: TextAlign.justify,
                            'Każdy z graczy wybiera akcje, dostosowane dla każdej postaci (bez wieśniaków). Te akcje to np. wybór eliminacji gracza przez mafię albo sprawdzenie przez prokuratora.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SubsectionTitle('Przebieg dnia:'),
                          Text(
                            textAlign: TextAlign.justify,
                            'Gracze dyskutują nad poprzednimi akcjami, zastanawiając się kogo wyeliminować. '
                                'Czas dyskusji jest dowolny, wybrany przez gospodarza. Na koniec dyskusji, gospodarz przechodzi do głosowania. '
                                'Głosowanie trwa tyle, ile ustalono na początku gry (np. stałe 2 minuty). '
                                'Podczas głosowania każdy wybiera, kogo należy wyeliminować. W przypadku remisu nikt nie umiera.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          SectionTitle('Wyeliminowani gracze:'),
                          Text(
                            textAlign: TextAlign.justify,
                            'Wyeliminowany gracz przestaje brać udział w rozgrywce. Może jednak obserwować rozgrywkę, ponieważ widzi który z graczy posiadał jaką rolę.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          SectionTitle('Koniec gry:'),
                          Text(
                            textAlign: TextAlign.justify,
                            'Po każdym głosowaniu automatycznie sprawdzany jest warunek końca gry.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          SectionTitle('Znaczenie ról:'),
                          RoleDescription('Mafia', 'Mafia jest główną postacią przeciwników miasta, i jej celem jest wyeliminowanie graczy z "miasta". '
                              'W nocy Mafia dowiaduje się tożsamości pozostałych mafii, następnie wspólnie decydują, który z graczy zostanie wyeliminowany o poranku. '
                              'W przypadku braku jednoznacznej decyzji nikt nie ginie.'),
                          RoleDescription('Prokurator', 'Postać z miasta, której celem jest rozpoznanie mafii. W nocy prokurator przeprowadza dochodzenie w sprawie któregoś z graczy '
                              'i dowiaduje się czy jest on z miasta, czy z mafii. Aplikacja wyświetla czy dana postać jest z miasta, czy z mafii.'),
                          RoleDescription('Obrońca', 'Postać z miasta, która w nocy broni celu. Jeżeli obrońca wybierze cel mafii, ten został obroniony i nie jest eliminowany o poranku.'),
                          RoleDescription('Bimbrownik', 'Postać z miasta. Bimbrownik w nocy wybiera jedną osobę, która zostaje zbimbrowana. Jeżeli ta osoba wykonuje jakąś akcję w nocy '
                              '(przykładowo jest jedną z Mafii i próbuje wyeliminować innego gracza), cel akcji tej postaci przechodzi na 3 osobę w dół na liście graczy (cyklicznie).'),
                          RoleDescription('Grabarz', 'Postać, należąca do drużyny miasta. W nocy grabarz sprawdza jakie role posiadali wyeliminowani gracze.'),
                          RoleDescription('Mieszczuch', 'Postać należąca do miasta, oznaczany przez kartę. Postać bez większych przywilejów (dla największych koneserów, którzy bez żadnych sztuczek potrafią wytypować mafię).'),
                        ],
                      )
                    ),
                  ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => goBack(context),
                  child: Text('Cofnij')),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}

class SubsectionTitle extends StatelessWidget {
  final String text;
  SubsectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    );
  }
}

class RoleDescription extends StatelessWidget {
  final String role;
  final String description;

  RoleDescription(this.role, this.description);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$role: ',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextSpan(
              text: description,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        textAlign: TextAlign.justify, // Wyjustowanie tekstu
      ),
    );
  }
}

void goBack(BuildContext context) {
  Navigator.pop(context);
}

import 'package:SIRA/widgets/tabs/card_populaire.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class MesDefisCrees extends StatefulWidget {
  const MesDefisCrees({Key? key}) : super(key: key);

  @override
  State<MesDefisCrees> createState() => _MesDefisCreesState();
}

class _MesDefisCreesState extends State<MesDefisCrees> {
  bool hasDefis = false; // Changez à true/false pour tester les deux cas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Contenu principal qui prend tout l'espace disponible
            Expanded(
              child: hasDefis
                  ? // Si il y a des défis, afficher la grille
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: 10, // Ajoutez itemCount pour éviter une grille infinie
                  itemBuilder: (context, index) {
                    return const CardPopulaire(
                      imageAsset: 'assets/images/reboisement.png',
                      title: 'Journée de Reboisement sur la V...',
                      date: '30 août 2025',
                      location: 'VDN, Échangeur OMVS',
                      participants: '+100 participants',
                    );
                  },
                ),
              )
                  : // Si pas de défis, afficher l'image et le texte centré
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    Center(
                      child: Image.asset(
                        'assets/images/imageGroup.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain, // Changé de fill à contain pour une meilleure proportion
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Vous pouvez voir ici tous vos défis créés. '
                          'Vous n\'en avez pas encore créé ? Créez dès aujourd\'hui ! '
                          'Lancez-vous et inspirez votre communauté avec des défis engageants.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF88868A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bouton fixe en bas
            Container(
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CustomButton(
                    text: 'Nouveau Défi',
                    borderRadius: 24,
                    icon: Icons.edit_note_outlined,
                    onPressed: () async {
                      // Action du bouton
                      print('Nouveau défi créé !');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
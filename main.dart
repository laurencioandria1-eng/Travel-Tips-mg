import 'package:flutter/material.dart';

void main() => runApp(const AdventureTripApp());

class AdventureTripApp extends StatelessWidget {
  const AdventureTripApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Adventure Trip MG', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B4D)), scaffoldBackgroundColor: const Color(0xFFF6F7F4)),
    home: const HomePage(),
  );
}

class Trip {
  final String title, region, type, price, emoji, description;
  const Trip(this.title, this.region, this.type, this.price, this.emoji, this.description);
}
const trips = <Trip>[
  Trip('Allée des Baobabs','Morondava','Nature','À partir de 35 €','🌅','Admirez les baobabs emblématiques au coucher du soleil.'),
  Trip('Trek dans l’Isalo','Parc national de l’Isalo','Randonnée','À partir de 55 €','🥾','Randonnée, canyons et piscines naturelles avec guide local.'),
  Trip('Nosy Be & les îles','Nosy Be','Plage','À partir de 45 €','🏝️','Une journée entre mer turquoise et snorkeling.'),
  Trip('Rencontre à Antsirabe','Vakinankaratra','Culture','À partir de 18 €','🛺','Découvrez les artisans et la vie locale des Hautes Terres.'),
  Trip('Route des Hautes Terres','Antananarivo – Antsirabe','Circuit','Sur devis','🚙','Un circuit personnalisable au rythme de votre voyage.'),
  Trip('Aventure dans la forêt','Andasibe','Nature','À partir de 40 €','🌿','Explorez la forêt avec un guide local.'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String category = 'Tout', query = '';
  final search = TextEditingController();
  final categories = const ['Tout','Nature','Randonnée','Plage','Culture','Circuit'];
  List<Trip> get filtered => trips.where((t) => (category == 'Tout' || t.type == category) && ('${t.title} ${t.region} ${t.type}'.toLowerCase().contains(query.toLowerCase()))).toList();
  @override void dispose() { search.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: const Color(0xFF176B4D), foregroundColor: Colors.white, title: const Row(children: [Icon(Icons.explore), SizedBox(width: 8), Text('Adventure Trip MG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19))]), actions: [IconButton(onPressed: () => showAboutDialog(context: context, applicationName: 'Adventure Trip MG', children: const [Text('Prototype de découverte touristique. Réservations et paiements non connectés.')]), icon: const Icon(Icons.info_outline))]),
    body: CustomScrollView(slivers: [
      SliverToBoxAdapter(child: Container(padding: const EdgeInsets.fromLTRB(20,24,20,24), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF176B4D),Color(0xFF25966A)]), borderRadius: BorderRadius.vertical(bottom: Radius.circular(26))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('MADAGASCAR, À VOTRE RYTHME', style: TextStyle(color: Color(0xFFD3F4DF), fontSize: 11, letterSpacing: 1.3, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
        const Text('Votre prochaine aventure\ncommence ici.', style: TextStyle(color: Colors.white, fontSize: 29, height: 1.15, fontWeight: FontWeight.w800)), const SizedBox(height: 10),
        const Text('Explorez l’île avec des guides et prestataires locaux.', style: TextStyle(color: Colors.white)), const SizedBox(height: 18),
        TextField(controller: search, onChanged: (v) => setState(() => query = v), decoration: InputDecoration(hintText: 'Où souhaitez-vous aller ?', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
      ]))),
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(18,22,18,10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Explorer par envie', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 12),
        SizedBox(height: 42, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: categories.length, separatorBuilder: (_,__) => const SizedBox(width: 8), itemBuilder: (_,i) => ChoiceChip(label: Text(categories[i]), selected: category == categories[i], onSelected: (_) => setState(() => category = categories[i])))),
        const SizedBox(height: 18), Row(children: [const Expanded(child: Text('Idées de voyage', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))), Text('${filtered.length} expériences', style: const TextStyle(color: Colors.black54, fontSize: 12))]),
      ]))),
      if (filtered.isEmpty) const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(24), child: Center(child: Text('Aucun résultat. Essayez une autre recherche.'))))
      else SliverPadding(padding: const EdgeInsets.fromLTRB(16,2,16,20), sliver: SliverGrid(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .72), delegate: SliverChildBuilderDelegate((context,i) {
        final t = filtered[i];
        return InkWell(borderRadius: BorderRadius.circular(18), onTap: () => _details(t), child: Card(clipBehavior: Clip.antiAlias, margin: EdgeInsets.zero, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 100, width: double.infinity, color: const Color(0xFFE0F0E5), alignment: Alignment.center, child: Text(t.emoji, style: const TextStyle(fontSize: 48))),
          Padding(padding: const EdgeInsets.fromLTRB(12,10,12,8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t.type.toUpperCase(), style: const TextStyle(color: Color(0xFF176B4D), fontSize: 9, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text(t.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, height: 1.15)), const SizedBox(height: 6), Text(t.region, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.black54)), const SizedBox(height: 10), Text(t.price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))]))
        ])));
      }, childCount: filtered.length))),
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(16,0,16,28), child: Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.map_outlined, color: Color(0xFF176B4D), size: 30), const SizedBox(height: 8), const Text('Un voyage qui vous ressemble', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 6), const Text('Décrivez votre projet et préparez un circuit sur mesure avec des prestataires locaux.'), const SizedBox(height: 14), SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _requestTrip, icon: const Icon(Icons.send), label: const Text('Créer mon voyage sur mesure')))]))))),
      const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(bottom: 24), child: Center(child: Text('Adventure Trip MG • Découvrir Madagascar autrement', style: TextStyle(fontSize: 11, color: Colors.black54))))),
    ]),
    bottomNavigationBar: NavigationBar(selectedIndex: 0, destinations: const [NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explorer'), NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favoris'), NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil')], onDestinationSelected: (i) { if (i > 0) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(i == 1 ? 'Les favoris seront ajoutés dans une prochaine version.' : 'Les comptes seront activés dans une prochaine version.'))); }),
  );
  void _details(Trip t) => showModalBottomSheet(context: context, showDragHandle: true, builder: (ctx) => Padding(padding: const EdgeInsets.fromLTRB(22,8,22,28), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Center(child: Text(t.emoji, style: const TextStyle(fontSize: 58))), Text(t.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), Text(t.region, style: const TextStyle(color: Colors.black54)), const SizedBox(height: 12), Text(t.description), const SizedBox(height: 12), Text(t.price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF176B4D))), const SizedBox(height: 8), const Text('Tarif indicatif de démonstration à confirmer auprès du prestataire.', style: TextStyle(fontSize: 11, color: Colors.black54)), const SizedBox(height: 12), SizedBox(width: double.infinity, child: FilledButton(onPressed: () { Navigator.pop(ctx); _requestTrip(prefill: t.title); }, child: const Text('Demander cette expérience')))])));
  void _requestTrip({String prefill = ''}) {
    final name = TextEditingController(), destination = TextEditingController(text: prefill), date = TextEditingController(), budget = TextEditingController(), people = TextEditingController(text: '2');
    showModalBottomSheet(context: context, isScrollControlled: true, showDragHandle: true, builder: (ctx) => Padding(padding: EdgeInsets.fromLTRB(20,8,20,MediaQuery.of(ctx).viewInsets.bottom + 24), child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Créer mon voyage', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 6), const Text('Démo uniquement : aucune demande ne sera transmise en ligne.'), const SizedBox(height: 14), TextField(controller: name, decoration: const InputDecoration(labelText: 'Votre nom', border: OutlineInputBorder())), const SizedBox(height: 10), TextField(controller: destination, decoration: const InputDecoration(labelText: 'Destination ou activité', border: OutlineInputBorder())), const SizedBox(height: 10), TextField(controller: date, decoration: const InputDecoration(labelText: 'Date souhaitée', hintText: 'JJ/MM/AAAA', border: OutlineInputBorder())), const SizedBox(height: 10), TextField(controller: people, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Nombre de voyageurs', border: OutlineInputBorder())), const SizedBox(height: 10), TextField(controller: budget, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Budget estimé (€)', border: OutlineInputBorder())), const SizedBox(height: 16), SizedBox(width: double.infinity, child: FilledButton(onPressed: () { Navigator.pop(ctx); showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Demande préparée'), content: Text('Merci ${name.text.isEmpty ? "voyageur" : name.text}. Votre projet « ${destination.text.isEmpty ? "Madagascar" : destination.text} » est enregistré uniquement dans cette démonstration. Aucune demande n’a été envoyée.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer'))])); }, child: const Text('Préparer ma demande'))]))));
  }
}

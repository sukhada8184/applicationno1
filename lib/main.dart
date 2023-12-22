
import 'dart:js_interop_unsafe';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    
    return ChangeNotifierProvider(
      create: (context)=>MyAppState(),
      child: MaterialApp(
          title: 'Worldfav',
          theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 170, 17, 231)),
          useMaterial3: true,
          ),
      home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext(){
    current=WordPair.random();
    notifyListeners();
  }

  var favourites=<WordPair>[];
  void getFavourites(WordPair pair){
    if(favourites.contains(pair)){
      favourites.remove(pair);
    }
    else{ favourites.add(pair);}
    notifyListeners();
  }

  
  
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex=0;
  bool isExtended=false;
  void expandRail() {
    setState(() {
      isExtended = !isExtended;
    });
  }

  
  @override
  Widget build(BuildContext context) {
  Widget page;
  switch(selectedIndex){
    case 0:page=GeneratorPage();
    break;
    case 1:page=Placeholder();
    break;
    case 2:page=ProfilePage();
    break;
    default:
    throw UnimplementedError('no widget for $selectedIndex');
  }
    return Builder(
      builder: (context) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: isExtended,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),                                                        
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
                
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
          floatingActionButton: FloatingActionButton(
            onPressed:(){
              expandRail();
            },
            child: Icon(Icons.menu),
             ),
        );
      }
    );
  }
}


class Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
  
      if(appState.favourites.isEmpty ){
        return Center(
          child:
          Text('You have no favourites yet'),
        );
      }

     return ListView(
      children: [
        Padding(
          padding:const EdgeInsets.all(5),
          child: Text('You have ${appState.favourites.length} Favourites:'),
          ),
          for(var pair in appState.favourites)
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text(pair.asLowerCase),
          trailing: IconButton(onPressed:()=>appState.getFavourites(pair), icon: Icon(Icons.delete)),     
        ),
        
          
      ],
     );
    

  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favourites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.getFavourites(pair);
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  var appState = context.watch<MyAppState>();

   return Center(
    child:Column(
      children: [
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Material(
            clipBehavior: Clip.hardEdge,
            shape: CircleBorder(),
            child: Ink.image(
              width: 300,
              height: 300,
              fit: BoxFit.fitHeight,
              image: NetworkImage('data:image/jpeg;base64,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')
            ),
                   ),
         ),
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.topLeft,
            child: Text('Sukhada Patil',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35
            ),),),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            alignment: Alignment.topLeft,
            child: Text('patilss22@iitk.ac.in')),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title:Text('City:Kolhapur'),
        ),
        ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text('Roll no:220761'),
        ),

      ],
    )

   );

  }
}



class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
      final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asUpperCase,style:style,semanticsLabel: "{$pair.first,$pair.second}",),
        
      ),
    );
  }
}
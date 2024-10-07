import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:rick/logic/cubit/characters_cubit.dart';
import 'package:rick/data/models/characters.dart';
import 'package:rick/data/repository/character_repository.dart';
import 'package:rick/presentation/widgets/character_item.dart';
import 'package:rick/utils/colors.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late CharactersRepository characterRepo;

 late List<Character> allCharacters;
 late List<Character> searchedForCharacter;
  bool _isSearching = false;
  final TextEditingController _searchedTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getCharacters();
    _setupScrollController();
  }

  void _setupScrollController() {
    print("_setupScrollController is Called");
    _scrollController.addListener(() {
      print("_setupScrollController is Called2");
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {

            if(!isLoading){
               print("Inside scrollController fun");
               BlocProvider.of<CharactersCubit>(context).getCharacters();
               setState(() {
                 isLoading = true;
               });
               print("IsLoading: $isLoading");

            }
      }
    });
  }

  
   @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchedTextController,
      cursorColor: MyColors.myGrey,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Find a character...',
        hintStyle: TextStyle(color: MyColors.myGrey, fontSize: 18),
      ),
      style: const TextStyle(color: MyColors.myGrey, fontSize: 18),
      onChanged: (searchedCharacter) {
        addSearchedForCharacterToSearchedList(searchedCharacter);
      },
    );
  }

 

  void addSearchedForCharacterToSearchedList(String searchedCharacter) {
    searchedForCharacter = allCharacters
        .where((character) => character.name
            .toLowerCase()
            .startsWith(searchedCharacter.toLowerCase()))
        .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.clear,
            color: MyColors.myGrey,
          ),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: const Icon(
            Icons.search,
            color: MyColors.myGrey,
          ),
        ),
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchedTextController.clear();
    });
  }

  Widget _buildAppBarTitle() {
    return const Text(
      "Rick and Morty TV",
      style: TextStyle(
        color: MyColors.myGrey,
      ),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
      if (state is CharacterLoading && state.isFirstFetch) {
        return showLoadingIndicator();
      }
      if (state is CharacterLoading) {
        print("CharacterLoading");
        allCharacters = state.oldCharacters;
        isLoading = true;
      } else if (state is CharactersLoaded) {
        print("CharactersLoaded");
        allCharacters = state.characters;
        isLoading = false;
      }

      return buildLoadedListWidget();
    });
  }

  Widget buildLoadedListWidget() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          color:MyColors.myGrey,
          child: Column(
            children: [
             buildCharactersList(),
             if(isLoading)
             showLoadingIndicator()
             else
             Container(),
             //(isLoading)? : Container(),
             
            //  (isLoading)? 
            //  const Center(child: CircularProgressIndicator(color: Colors.red),):
            //  (_searchedTextController.text.isEmpty)?
            //  TextButton(onPressed: (){
            //   fetchData();
            //     // setState(() {
            //     //   isLoading = true;
            //     // });
            //  }, child: const Text('Load More',),)
            //  : Container(),
              //buildTestList(),
            //  showLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTestList() {
    return GridView.builder(
      controller: _scrollController,
        itemCount: allCharacters.length + (isLoading? 1 :0),
         shrinkWrap: true,
      physics: const ScrollPhysics(),
     // AlwaysScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
        itemBuilder: (context, index) {
          if(index < allCharacters.length){
          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridTile(
              footer: Container(
                color: MyColors.myGrey,
                child: Center(
                  child: Text(
                    allCharacters[index].name,
                  ),
                ),
              ),
              child:Image.network(
                allCharacters[index].image,
              ),
              
            ),
          );
        }
        else{
          return showLoadingIndicator();
        }
    });
  }

  Widget buildCharactersList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _searchedTextController.text.isEmpty
           ?allCharacters.length + (isLoading ? 1 : 0)
          : searchedForCharacter.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < allCharacters.length) {
          return CharacterItem(
            character: _searchedTextController.text.isEmpty
                ? allCharacters[index]
                : searchedForCharacter[index],
          );
        }else{
          return Container();
        }
      },
    );
  }

  Widget buildEmptyWidget() {
    return Center();
  }

  Widget showLoadingIndicator() {
    return const Center(
        child: CircularProgressIndicator(
          color: MyColors.myYellow,
        ),
      );
  }

  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Can\'t connect .. check internet',
              style: TextStyle(
                fontSize: 22,
                color: MyColors.myGrey,
              ),
            ),
            Image.asset('assets/images/no_internet.png'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   // _setupScrollController();
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
        backgroundColor: MyColors.myYellow,
      ),
      backgroundColor: MyColors.myGrey,
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          List<ConnectivityResult> connectivity,
          Widget child,
        ) {
          final bool connected =
           !connectivity.contains(ConnectivityResult.none);
          if (connected) {
            return buildBlocWidget();
          } else {
            return buildNoInternetWidget();
          }
        },
        child: showLoadingIndicator(),
      ),
    );
  }
}

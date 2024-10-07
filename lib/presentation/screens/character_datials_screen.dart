import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick/logic/cubit/characters_cubit.dart';
import 'package:rick/data/models/characters.dart';
import 'package:rick/data/models/quote.dart';
import 'package:rick/utils/colors.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;
  // List<String> quotes = [
  //   "Your time is limited, so don't waste it living someone else's life. Don't be trapped by dogma – which is living with the results of other people's thinking. -Steve Jobs",
  //   "The future belongs to those who believe in the beauty of their dreams. -Eleanor Roosevelt",
  // ];
  CharacterDetailsScreen({super.key, required this.character});

  Widget buildSlivarAppBar() {
    return SliverAppBar(
      leading: BackButton(color: Colors.white),
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        //centerTitle: true,
        title: Text(
          character.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Hero(
          tag: character.id,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              color: MyColors.myWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
              text: value,
              style: const TextStyle(
                color: MyColors.myWhite,
                fontSize: 16,
              ))
        ],
      ),
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      height: 30,
      color: MyColors.myYellow,
      endIndent: endIndent,
      thickness: 2,
    );
  }

   Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget checkIfQuotesAreLoaded(CharactersState state){
    if(state is QuoteLoaded){
      return displayRandomQuoteOrEmptySpace(state);
    }else{
      return showLoadingIndicator();
    }

  }

  Widget displayRandomQuoteOrEmptySpace(state) {
    List<Quote> quotes = (state).quotes;
    if (quotes.isEmpty) {
      return buildEmptyWidget();
    } else {
      int randomIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: MyColors.myWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 7,
                color: MyColors.myYellow,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText('${quotes[randomIndex].quote}\n-${quotes[randomIndex].author}'),
            ],
          ),
        ),
      );
    }
  }

  Widget buildEmptyWidget() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getRandomQuotes();
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSlivarAppBar(),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    characterInfo('Gender : ', character.gender),
                    buildDivider(260),
                    characterInfo('Status : ', character.status),
                    buildDivider(200),
                    characterInfo('Species : ', character.species),
                    buildDivider(180),
                    character.type.isEmpty
                        ? Container()
                        : characterInfo('Type : ', character.type),
                    character.type.isEmpty ? Container() : buildDivider(250),
                    characterInfo('Location : ', character.location.name),
                    buildDivider(150),
                    characterInfo('Origin : ', character.origin.name),
                    buildDivider(200),
                    characterInfo('Number of Episodes : ', character.episodes.length.toString()),
                    buildDivider(200),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<CharactersCubit,CharactersState>(
                      builder: (context, state) {
                        return checkIfQuotesAreLoaded(state);
                      },
                    ),
                    //displayRandomQuoteOrEmptySpace(),
                  ],
                ),
              ),
              const SizedBox(
                height: 500,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/context_extension.dart';
import 'package:senior_design_project/screens/search/search_services.dart';

class SearchScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearch(),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
        // title: TextFormField(
        //   controller: searchController,
        //   // onFieldSubmitted: Provider.of<SearchServices>(context).handleSearch,
        //   onChanged:(){
        //     showSearch(context: context, delegate: CustomSearch(),),
        //   },
        //   decoration: InputDecoration(
        //     prefixIcon: Icon(Icons.search),
        //     hintText: 'Search for user',
        //     filled: true,
        //     suffixIcon: IconButton(
        //       icon: Icon(Icons.clear),
        //       onPressed: clearSearch,
        //     ),
        //   ),
        //   showCursor: true,
        //   cursorColor: Colors.white,
        //   autofocus: true,
        // ),
      ),
      // body: Provider.of<SearchServices>(context).searchResultsFuture == null
      //     ? Text('Bos')
      //     : searchResult(context),
    );
  }

  FutureBuilder<QuerySnapshot<Object?>> searchResult(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<SearchServices>(context).searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<UserResult> searchResults = [];
          snapshot.data!.docs.forEach((doc) {
            UserResult searchResult = UserResult(doc);
            searchResults.add(
              searchResult,
            );
          });
          return ListView(
            children: searchResults,
          );
        }
      },
    );
  }

  void clearSearch() {
    searchController.clear();
  }
}

class UserResult extends StatelessWidget {
  final DocumentSnapshot doc;

  UserResult(this.doc);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => print('profile git'),
            child: ListTile(
              // leading: CircleAvatar(
              //   backgroundColor: Colors.grey,
              //   backgroundImage: CachedNetworkImageProvider(
              //     doc['userimage'].toString(),
              //   ),
              // ),
              title: Text(doc['username'].toString()),
              subtitle: Text(doc['useremail'].toString()),
            ),
          ),
          Divider(
            height: context.dynamicHeight(0.1),
          ),
        ],
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  FutureBuilder<QuerySnapshot<Object?>> buildResults(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .where('username')
          .get(),
      builder: (context, snapshot) {
        List<String> matchNameList = [];
        // List<String> matchImageList = [];
        List<String> matchEmailList = [];
        if (!snapshot.hasData) {
          return CircularProgressIndicator(
            color: Colors.blue,
          );
        } else {
          snapshot.data!.docs.forEach(
            (doc) {
              if (doc['username'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  )) {
                matchNameList.add(doc['username'].toString());
                // matchImageList.add(doc['userimage'].toString());
                matchEmailList.add(doc['useremail'].toString());
              }
            },
          );
          return Expanded(
            child: ListView.builder(
              itemCount: matchNameList.length,
              itemBuilder: (context, index) {
                final matchName = matchNameList[index];
                // final matchImage = matchImageList[index];
                final matchEmail = matchEmailList[index];
                return GestureDetector(
                  onTap: () => print('profile git'),
                  child: ListTile(
                    // leading: CircleAvatar(
                    //   backgroundColor: Colors.grey,
                    //   backgroundImage: CachedNetworkImageProvider(
                    //     doc['userimage'].toString(),
                    //   ),
                    // ),
                    title: Text(matchName),
                    subtitle: Text(
                      matchEmail,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  @override
  FutureBuilder<QuerySnapshot<Object?>> buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .where('username')
          .get(),
      builder: (context, snapshot) {
        List<String> matchNameList = [];
        // List<String> matchImageList = [];
        List<String> matchEmailList = [];
        if (!snapshot.hasData) {
          return CircularProgressIndicator(
            color: Colors.blue,
          );
        } else {
          snapshot.data!.docs.forEach(
            (doc) {
              if (doc['username'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  )) {
                matchNameList.add(doc['username'].toString());
                // matchImageList.add(doc['userimage'].toString());
                matchEmailList.add(doc['useremail'].toString());
              }
            },
          );
          return Expanded(
            child: ListView.builder(
              itemCount: matchNameList.length,
              itemBuilder: (context, index) {
                final matchName = matchNameList[index];
                // final matchImage = matchImageList[index];
                final matchEmail = matchEmailList[index];
                return GestureDetector(
                  onTap: () => print('profile git'),
                  child: ListTile(
                    // leading: CircleAvatar(
                    //   backgroundColor: Colors.grey,
                    //   backgroundImage: CachedNetworkImageProvider(
                    //     doc['userimage'].toString(),
                    //   ),
                    // ),
                    title: Text(matchName),
                    subtitle: Text(
                      matchEmail,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/Model/Movie.dart';
import 'package:movie_app/Screens/DashBoard/MovieDetailScreen.dart';
import 'package:movie_app/Screens/Shimmer.dart';
import 'package:movie_app/Service/MovieService.dart';
import 'package:movie_app/constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Movie> nowPlayingMovies = [];
  List<Movie> filteredMovies = [];
  bool _isSearching = false;
  MovieService _movieService = MovieService();

  @override
  void initState() {
    getMovies();
  }

  handleSearchInput(text) async {
    if (text != null || text != "") {
      final searchedMovies = await _movieService.searchMovies(text);
      setState(() {
        _isSearching = true;
        filteredMovies = searchedMovies;
      });
    }
    if (text == null || text == "") {
      setState(() {
        filteredMovies=nowPlayingMovies;
        _isSearching = false;
      });
    }
  }

  handleClear() {
    FocusScope.of(context).unfocus();
    setState(() {
      filteredMovies=nowPlayingMovies;
      _isSearching = false;
      _searchController.text = "";
    });
  }

  getMovies() async {
    final nowPlayingMovieList = await _movieService.findNowPlaying();
    if(this.mounted){
      setState(() {
        nowPlayingMovies = nowPlayingMovieList;
        filteredMovies=nowPlayingMovieList;
        _searchController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: (){
          return getMovies();
        },
        displacement: 120,
        color: kPrimaryColor,
        strokeWidth: 3,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: ListView(physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), children: <
                      Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(40, 40, 150, 0.4),
                                      blurRadius: 15,
                                      offset: Offset(0, 10))
                                ]),
                            child: TextFormField(
                              onChanged: (text) => {handleSearchInput(text)},
                              style: TextStyle(fontSize: 18),
                              controller: _searchController,
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(
                                Icons.search,
                                "Search Movies..",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                          !_isSearching
                              ? "Recommended Movies"
                              : "Searched Movies",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child:filteredMovies.length>0 ?GridView.count(
                          physics: BouncingScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          shrinkWrap: true,
                          children: new List<Widget>.generate(
                              filteredMovies.length, (index) {
                            return new GridTile(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return MovieDetailScreen(
                                        movie: filteredMovies[index],
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  new Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(100, 50, 100, 0.1),
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                filteredMovies[index].image))),
                                  ),
                                  Positioned(
                                      bottom: 5,
                                      left: 5,
                                      child: Text(
                                        filteredMovies[index].title,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ))
                                ],
                              ),
                            ));
                          }),
                        ):ShimmerScreen(height: 200,width: 500,vertical:true,listView: false,),
                      ),
                    ),
                  ])),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(IconData icon, String hintText) {
    return InputDecoration(
        contentPadding: EdgeInsets.all(12),
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
        suffixIcon: IconButton(
            icon: Icon(
              _isSearching ? Icons.clear : Icons.search,
              size: 25,
            ),
            onPressed: () => {_isSearching ? handleClear() : () {}}),
        border: InputBorder.none);
  }
}

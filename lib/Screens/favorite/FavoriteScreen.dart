import 'package:flutter/material.dart';
import 'package:movie_app/Model/Movie.dart';
import 'package:movie_app/Screens/DashBoard/MovieDetailScreen.dart';
import 'package:movie_app/Screens/Shimmer.dart';
import 'package:movie_app/Service/MovieService.dart';
import 'package:movie_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  MovieService _movieService = MovieService();
  List<Movie> popularMovies = [];
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  getMovies() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    List<Movie> popularMovieList =
        _movieService.parseFavoriteMovies(sharedPrefs.get('movies'));
    if (this.mounted) {
      setState(() {
        prefs = sharedPrefs;
        popularMovies = popularMovieList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: RefreshIndicator(
        color: kPrimaryColor,
        onRefresh: () {
          return getMovies();
        },
        strokeWidth: 3,
        displacement: 100,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 5),
                  child: ListView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 10.0),
                          child: Text("Your Favorite Movies",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          margin: EdgeInsets.only(top: 10),
                          child: popularMovies.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: popularMovies.length,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return MovieDetailScreen(
                                                movie: popularMovies[index],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        height: 85,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(100, 50, 100, 0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Container(
                                                width: 150,
                                                child: Image.network(
                                                  popularMovies[index].image,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      popularMovies[index]
                                                          .title,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    popularMovies[index]
                                                            .tagline ??
                                                        "No Tagline Available",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: Colors.grey),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    popularMovies[index]
                                                            .release_date ??
                                                        "No Date Available",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              : ShimmerScreen(
                                  height: 100,
                                  width: width / 2,
                                  vertical: true,
                                  listView: true,
                                  itemCount: 1),
                        ),
                      ])),
            ],
          ),
        ),
      ),
    );
  }
}

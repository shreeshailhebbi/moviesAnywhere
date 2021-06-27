import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_app/Model/Movie.dart';
import 'package:movie_app/Screens/DashBoard/MovieDetailScreen.dart';
import 'package:movie_app/Screens/Shimmer.dart';
import 'package:movie_app/Service/MovieService.dart';
import 'package:movie_app/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MovieService _movieService = MovieService();
  List<Movie> popularMovies = [];
  List<Movie> upcomingMovies = [];
  List<Movie> _movies = [];
  List<Movie> _topRatedMovies = [];
  int _currentIndex = 0;

  @override
  void initState() {
    getMovies();
    super.initState();
  }

  getMovies() async {
    final movieList = await _movieService.findAll();
    final popularMovieList = await _movieService.findPopular();
    final latestMovieList = await _movieService.findUpcoming();
    if (this.mounted) {
      setState(() {
        _movies = movieList.sublist(0, 6);
        _topRatedMovies = movieList.sublist(6, movieList.length);
        popularMovies = popularMovieList;
        upcomingMovies = latestMovieList;
      });
    }
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
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
                        Container(
                          child: Row(
                            children: [
                              Container(
                                  height: 60,
                                  width: 60,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Image.asset(
                                    "assets/primeLogo.png",
                                    fit: BoxFit.fitHeight,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Movies Anywhere",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22),
                                  ),
                                  Text(
                                    "YOUR MOVIES,TOGETHER AT LAST",
                                    style: TextStyle(
                                        color: Colors.blueAccent[200],
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: kPrimaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Stack(
                          children: [
                            _movies.length > 0
                                ? CarouselSlider(
                                    options: CarouselOptions(
                                        autoPlay: true,
                                        aspectRatio: 2,
                                        enlargeCenterPage: true,
                                        enableInfiniteScroll: true,
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 800),
                                        viewportFraction: 0.8,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _currentIndex = index;
                                          });
                                        }),
                                    items: _movies
                                        .map((item) => InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return MovieDetailScreen(
                                                        movie: item,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: width,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      100, 50, 100, 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Image.network(item.image,
                                                    fit: BoxFit.cover,
                                                    width: width),
                                              ),
                                            ))
                                        .toList(),
                                  )
                                : Container(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    height: 200,
                                    child: ShimmerScreen(
                                      height: 200,
                                      width: width - 80,
                                      vertical: false,
                                      listView: true,
                                    )),
                            Positioned(
                              bottom: 0,
                              left: (width / 2) - 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: map<Widget>(_movies, (index, url) {
                                  return Container(
                                    width: 10.0,
                                    height: 10.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentIndex == index
                                          ? kPrimaryColor
                                          : Colors.grey,
                                    ),
                                  );
                                }),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: map<Widget>(_movies, (index, url) {
                                  return _currentIndex == index
                                      ? Text(
                                          _movies[index].title,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text("");
                                }),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 10.0),
                          child: Text("Most Popular Movies",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          margin: EdgeInsets.only(top: 10),
                          height: 150,
                          child: popularMovies.length > 0
                              ? ListView.builder(
                                  itemCount: popularMovies.length,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
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
                                        margin: EdgeInsets.only(right: 10),
                                        height: 150,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                100, 50, 100, 0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    popularMovies[index]
                                                        .image))),
                                      ),
                                    );
                                  })
                              : ShimmerScreen(
                                  height: 150,
                                  width: 100,
                                  vertical: false,
                                  listView: true,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 10.0),
                          child: Text("UpComing Movies",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          margin: EdgeInsets.only(top: 10),
                          height: 150,
                          child: upcomingMovies.length > 0
                              ? ListView.builder(
                                  itemCount: upcomingMovies.length,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return MovieDetailScreen(
                                                movie: upcomingMovies[index],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        height: 150,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                100, 50, 100, 0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    upcomingMovies[index]
                                                        .image))),
                                      ),
                                    );
                                  })
                              : ShimmerScreen(
                                  height: 150,
                                  width: 100,
                                  vertical: false,
                                  listView: true,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 10.0),
                          child: Text("Top Rated Movies",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          margin: EdgeInsets.only(top: 10),
                          height: 150,
                          child: _topRatedMovies.length > 0
                              ? ListView.builder(
                                  itemCount: _topRatedMovies.length,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return MovieDetailScreen(
                                                movie: _topRatedMovies[index],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        height: 150,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                100, 50, 100, 0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    _topRatedMovies[index]
                                                        .image))),
                                      ),
                                    );
                                  })
                              : ShimmerScreen(
                                  height: 150,
                                  width: 100,
                                  vertical: false,
                                  listView: true,
                                ),
                        ),
                      ])),
            ],
          ),
        ),
      ),
    );
  }
}

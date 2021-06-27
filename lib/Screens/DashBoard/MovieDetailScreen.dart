import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_app/Model/Movie.dart';
import 'package:movie_app/Service/MovieService.dart';
import 'package:movie_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetailScreen extends StatefulWidget {
  Movie movie;

  MovieDetailScreen({this.movie});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<MovieDetailScreen> {
  SharedPreferences prefs;
  int _currentIndex = 0;
  MovieService _movieService = MovieService();
  Movie _movie = new Movie();
  bool _isFavorite = false;
  List<Movie> _movies = [];

  @override
  void initState() {
    getMovieDetails();
  }

  getMovieDetails() async {
    final movie = await _movieService.getMovieDetails(widget.movie.id);
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      _movie = movie;
      widget.movie = movie;
      prefs = sharedPrefs;
    });
    List<Movie> movies = _movieService.parseFavoriteMovies(prefs.get('movies'));
    for (Movie movie in movies) {
      if (movie.id == widget.movie.id) {
        setState(() {
          _isFavorite = true;
        });
      }
    }
  }

  handleFavorite() {
    Movie movie = Movie(
        id: widget.movie.id,
        image: widget.movie.image,
        title: widget.movie.title,
        tagline: widget.movie.tagline,
        release_date: widget.movie.release_date);

    List<Movie> movies = _movieService.parseFavoriteMovies(prefs.get('movies'));
    List<Movie> searchedResult =
        movies.where((movie) => movie.id == widget.movie.id).toList();
    if (searchedResult.length <= 0) {
      setState(() {
        _isFavorite = true;
      });
      getToastBar("Added To Favorite Movies..!");
      movies.add(movie);
      prefs.setString("movies", jsonEncode(movies));
    } else {
      setState(() {
        _isFavorite = false;
      });
      getToastBar("Removed From Favorite Movies..!");
      movies = movies.where((movie) => movie.id != widget.movie.id).toList();
      prefs.setString("movies", jsonEncode(movies));
    }
  }

  getToastBar(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: kPrimaryColor2,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: RefreshIndicator(
          color: kPrimaryColor,
          strokeWidth: 3,
          onRefresh: () {
            return getMovieDetails();
          },
          child: Stack(
            children: [
              Container(
                child: CustomScrollView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverAppBar(
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: _isFavorite
                              ? Icon(
                                  Icons.favorite,
                                  size: 35,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.favorite_border_outlined,
                                  size: 35,
                                  color: Colors.white,
                                ),
                          onPressed: () {
                            handleFavorite();
                          },
                        )
                      ],
                      backgroundColor: kPrimaryColor,
                      floating: true,
                      expandedHeight: MediaQuery.of(context).size.height * 0.3,
                      flexibleSpace: Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.movie.image))),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Text(
                            widget.movie.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0.0, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.tag,
                                      color: Colors.grey,
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.movie.tagline ?? "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.movie.release_date,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 25,
                          margin: EdgeInsets.only(
                            top: 15.0,
                          ),
                          padding: const EdgeInsets.only(left: 10),
                          child: DefaultTabController(
                            length: 2,
                            child: TabBar(
                              labelPadding: const EdgeInsets.all(0),
                              indicatorPadding: const EdgeInsets.all(0),
                              isScrollable: true,
                              labelColor: Colors.black,
                              indicatorColor: kPrimaryColor,
                              unselectedLabelColor: Colors.grey,
                              onTap: (value) {
                                setState(() {
                                  _currentIndex = value;
                                });
                              },
                              tabs: [
                                Tab(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Text("Overview",
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      "More Details",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _currentIndex == 0
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  child: Text(
                                    widget.movie.overview,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, right: 15.0),
                                child: reviewWidget(),
                              )
                      ]),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget reviewWidget() {
    return widget.movie.status != null
        ? Container(
            child: ListView.builder(
                itemCount: 1,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Genres",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                for (final genre in widget.movie.genres)
                                  Text(genre['name'].toString() + " , ",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          )) ??
                                      ""
                              ],
                            )
                          ],
                        ),
                        Divider(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Studios",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            for (final genre
                                in widget.movie.production_companies)
                              Text(genre['name'].toString() ?? "",
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ))
                          ],
                        ),
                        Divider(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Languages",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                for (final genre in widget.movie.languages)
                                  Text(genre['name'].toString() + "  ",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          )) ??
                                      ""
                              ],
                            )
                          ],
                        ),
                        Divider(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.movie.status ?? "Released",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }))
        : Container();
  }
}

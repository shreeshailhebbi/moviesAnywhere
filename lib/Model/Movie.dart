class Movie {
  int id;
  String title;
  String release_date;
  String overview;
  String image;
  String tagline;
  String status;
  List<dynamic> genres;
  List<dynamic> production_companies;
  List<dynamic> languages;

  Movie(
      {this.id,
      this.image,
      this.title,
      this.overview,
      this.release_date,
      this.genres,
      this.production_companies,
      this.tagline,
      this.languages,
      this.status});

  factory Movie.fromMap(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      image: "https://image.tmdb.org/t/p/original" + json['poster_path'],
      title: json['title'],
      release_date: json['release_date'],
      overview: json['overview'],
    );
  }

  factory Movie.searchMap(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      image: "https://image.tmdb.org/t/p/original" +
          (json['backdrop_path'] ?? "/620hnMVLu6RSZW6a5rwO8gqpt0t.jpg"),
      title: json['title'],
      release_date: json['release_date'] ?? "No Tagline Available",
      overview: json['overview'],
    );
  }

  factory Movie.movieDetailMap(Map<String, dynamic> json) {
    return Movie(
        id: json['id'],
        image: "https://image.tmdb.org/t/p/original" +
            (json['backdrop_path'] ?? "/620hnMVLu6RSZW6a5rwO8gqpt0t.jpg"),
        title: json['title'],
        release_date: json['release_date'] ?? "No Date Available",
        overview: json['overview'] ?? "",
        tagline: json['tagline'] ?? "No Tagline Available",
        genres: json['genres'] ?? "",
        production_companies: json['production_companies'] ?? "",
        languages: json['spoken_languages'] ?? "",
        status: json['status'] ?? "");
  }

  factory Movie.favoriteMovieMap(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      release_date: json['release_date'] ?? "No Date Available",
      overview: json['overview'] ?? "",
      tagline: json['tagline'] ?? "No Tagline Available",
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "image": image,
        "title": title,
        "release_date": release_date,
        "overview": overview
      };

  Map toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "release_date": release_date,
        "overview": overview,
        "tagline": tagline
      };
}

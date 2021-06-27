class User {
  int id;
  String firstName;
  String lastName;
  String mobileNo;
  String username;
  String password;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.mobileNo,
      this.username,
      this.password});

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      mobileNo: json['mobileNo'],
      username: json['username'],password: json['password']
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "mobileNo": mobileNo,
    "username": username,
    "password":password
  };
}

List<User> getUsers() {
  List<User> users = List();
  User user1 = User(
      id: 1,
      firstName: "Rahul",
      lastName: "Patil",
      mobileNo: "8861568154",
      password: "1234",
      username: "test");
  User user2 = User(
      id: 2,
      firstName: "Virat",
      lastName: "Gowda",
      mobileNo: "9035776261",
      password: "admin",
      username: "admin");
  User user3 = User(
      id: 2,
      firstName: "Gourav",
      lastName: "Yadav",
      mobileNo: "9916853823",
      password: "test",
      username: "admin");
  users.add(user1);
  users.add(user2);
  users.add(user3);
  return users;
}

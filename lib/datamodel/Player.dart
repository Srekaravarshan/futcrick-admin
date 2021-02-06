class Player<T> {
  int _id;
  String _name;
  DateTime _dateOfBirth;
  int _age;
  String _nationality;
  String _position;
  String _bio;

  Player(this._id, this._name, this._dateOfBirth, this._nationality,
      this._position, this._bio) {
    this._age = DateTime.now().year - _dateOfBirth.year;
  }

  String get bio => _bio;

  String get position => _position;

  String get nationality => _nationality;

  int get age => _age;

  DateTime get dateOfBirth => _dateOfBirth;

  String get name => _name;

  int get id => _id;
}

class ChennainFC extends Player {
  ChennainFC(int id, String name, DateTime dateOfBirth, String nationality,
      String position, String bio)
      : super(id, name, dateOfBirth, nationality, position, bio);
}

class Hydrabad extends Player {
  Hydrabad(int id, String name, DateTime dateOfBirth, String nationality,
      String position, String bio)
      : super(id, name, dateOfBirth, nationality, position, bio);
}

class CSK extends Player {
  CSK(int id, String name, DateTime dateOfBirth, String nationality,
      String position, String bio)
      : super(id, name, dateOfBirth, nationality, position, bio);
}

class KKR extends Player {
  KKR(int id, String name, DateTime dateOfBirth, String nationality,
      String position, String bio)
      : super(id, name, dateOfBirth, nationality, position, bio);
}

List<Player> goa = [];
List<Player> mumbaiCity = [];
List<Player> keralaBlasters = [];
List<Player> odisha = [];
List<Player> jamshedpurFC = [];
List<Player> scEastBengal = [];
List<Player> hyderabad = [];
List<Player> atkMohunBagan = [];

List<Player<CSK>> csk = [
  new Player<CSK>(
      1,
      "M S Dhoni",
      DateTime.utc(1986, DateTime.october, 3),
      "Nationality",
      "Wicket keeper",
      "Csk are finally back to  winning track as they registered an allround winning performance against the hyderabad . It seemed to be a good move that Curran was sent to the opening. He gave a blitzkrieg start but couldn't extend his role . Whatever but he did his role both with bat and ball . He seems to be a promising prospect for the daddies army .Now let's move on to our subject csk ceo spoke to ani , that the conditions in uae have forced us to go with two proper foreign batsman at top and then the two pace bowling allrounders."),
  new Player<CSK>(2, "Suresh Raina", DateTime.utc(1986, DateTime.october, 3),
      "Nationality", "Batsman", "bio"),
  new Player<CSK>(3, "Uthappa", DateTime.utc(1986, DateTime.october, 3),
      "Nationality", "Bowler", "bio")
];

List<Player<KKR>> kkr = [
  new Player<KKR>(4, "Yeah", DateTime.utc(1986, DateTime.october, 3),
      "Nationality", "Mm.. you go to slip", "bio"),
  new Player<KKR>(5, "Don't know", DateTime.utc(1986, DateTime.october, 3),
      "Nationality", "Bowler", "bio"),
  new Player<KKR>(6, "Who he is", DateTime.utc(1986, DateTime.october, 3),
      "Nationality", "Batsman", "bio")
];

Map<String, List<Player>> teamMap = {'CSK': csk, 'KKR': kkr};

class Dog {
  String name;
  int age;
  Dog._in();
  static Dog _instance = Dog._in();

  factory Dog(name, age) {
    _instance.name = name;
    _instance.age = age;
    return _instance;
  }
}

main(List<String> args) async {
  Dog a = Dog('andy', 1);
  Dog b = Dog('james', 1);
  print(a.name + a.age.toString());
  print(b.name + b.age.toString());
  print(a == b);
}

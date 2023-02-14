

class Blocked{

  String name;
  bool check;

  Blocked({
    this.name,this.check
});

  factory Blocked.fromMap(Map<String,dynamic> map){
    return new Blocked(
     name :map["name"],
     check : map["check"]
    );

  }



  static List<Map<String,dynamic>> block_list =[
    {
      "id":1,
      "name":"Ce n'est pas un membre de ma communauté",
      "check":false
    },
    {
      "id": 2,
      "name":"Publie un contenue indésirable",
      "check":false
    },{
      "id": 3,
      "name":"Harcèlement",
      "check":false
    },{
      "id": 4,
      "name":"Faux profile",
      "check":false
    },
  ];

}
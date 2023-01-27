
class Link1 {
  String description;
  String url;
  String image;
  String title;

  Link1({this.description, this.url, this.image});
  Link1.fromMap(Map<String, dynamic>  map) :
        description = "${map['description']}",
        url = "${map['url']}",
        image = "${map['image']}",
        title = "${map['title']}";


}

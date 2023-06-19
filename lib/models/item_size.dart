class ItemSize{

  ItemSize({this.name, this.price, this.stock});

  ItemSize.fromMap(Map<String, dynamic> map){
    name = map["name"] as String;
    price = map["price"] as num;
  }

  String name;
  num price;
  int stock;


  ItemSize clone(){
    return ItemSize(
      name: name,
      price: price,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "name":name,
      "price": price,
    };
  }

  @override
  String toString(){
    return "ItemSize{name: $name, price: $price}";
  }

}
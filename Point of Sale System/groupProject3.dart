import 'dart:io';

class Item {
  String name;
  double price;
  int quantity;
  int stock;

  Item(this.name, this.price, this.quantity, this.stock);

  String getName() {
    return this.name;
  }

  double getPrice() {
    return this.price;
  }

  void setQuantity(int quantity) {
    this.quantity = quantity;
  }

  int getQuantity() {
    return this.quantity;
  }

  void setStock(int stock) {
    this.stock = stock;
  }

  int getStock() {
    return this.stock;
  }

  //get the total payable amount of the item
  double getTotal() {
    return price * quantity;
  }
}

bool inventoryStockCheck(List itemList, int index) {
  //to check if there are enough stock
  bool status = false;
  int totalStock = itemList[index].getStock(); //refer current stock
  int totalBuy = itemList[index].getQuantity(); //refer quantity that user want

  if (totalBuy > totalStock) {
    // if user request more than stock
    status = false;
    print('Not enough stock, please enter another amount.');
  } else {
    status = true;
  }

  return status;
}

void recalculateStock(List itemList, int index, int quantity) {
  //to update the quantity of stock after the end of transaction
  int current = itemList[index].getStock();
  int after = current - quantity;

  itemList[index].setStock(after);
}

void start(List itemList) {
  int totalProduct = itemList.length;
  var date = DateTime.now();
  print("=================================================================");
  print("                Welcome To Our Vending Machine                   ");
  print("=================================================================");
  print("   $date                                       ");
  print("                                                                 ");
  print("   Snack Available :                                             ");
  print("                                                                 ");
  //list all items and its details
  for (var i = 0; i < totalProduct; i++) {
    var products = itemList[i].getName();
    var prices = itemList[i].getPrice();
    var stock = itemList[i].getStock();
    var number = i + 1;
    print(
        '   $number   $products RM$prices               $stock left in stock');
  }

  print("                                                                 ");
  print("=================================================================\n");
}

void chooseItem(List itemList) {
  var x = 1;
  //keep prompting user input if want to add more item
  while (x != 2) {
    var y = 0;
    int? snack;
    int? quantity;
    print(" Which Snack You Like To Buy :");
    snack = int.parse(stdin.readLineSync()!);
    print("\n You have choosen : $snack");

    //loop to check if the quantity wanted exceed the current stock
    while (y != 2) {
      print("\n How Many Of The Snack you Like To Buy :");
      quantity = int.parse(stdin.readLineSync()!);

      //adding to the current quantity (if there are previously added same item)
      (itemList[snack - 1]
          .setQuantity(quantity + (itemList[snack - 1].getQuantity())));

      if ((inventoryStockCheck(itemList, (snack - 1)))) {
        y = 2; //if true, then exit
      } else {
        //if false, repeat, then minus back the quantity added
        (itemList[snack - 1]
            .setQuantity((itemList[snack - 1].getQuantity()) - quantity));
        y = 1;
      }
    }

    print(
        " Do You Want To Buy Another Snack? 1:Yes 2:No                          ");
    x = int.parse(stdin.readLineSync()!);
  }
}

double payment() {
  print(" Enter amount given :");
  double? pay = double.parse(stdin.readLineSync()!);
  return pay;
}

void receipt(List itemList) {
  var date = DateTime.now();
  double gst = 6 / 100;
  double discount1 = 10 / 100;
  double discount2 = 20 / 100;
  double discount = 0;
  int totalProduct = itemList.length;
  num totalProductQuantity = 0;
  double totalBeforeGst = 0;
  double totalAfterDiscount;
  double pay = 0;

  for (var i = 0; i < totalProduct; i++) {
    // total price before gst
    totalBeforeGst = totalBeforeGst + (itemList[i].getTotal());
    //total item count
    totalProductQuantity = totalProductQuantity + (itemList[i].getQuantity());
  }

  //Final amount the user need to pay
  double totalAfterGst = totalBeforeGst + (totalBeforeGst * gst);

  //give discount if more item
  if (totalProductQuantity >= 15) {
    totalAfterDiscount = totalAfterGst - (totalAfterGst * discount2);
    discount = discount2;
  } else if (totalProductQuantity >= 10) {
    totalAfterDiscount = totalAfterGst - (totalAfterGst * discount1);
    discount = discount1;
  } else {
    totalAfterDiscount = totalAfterGst;
  }

  var x = true;
  while (x == true) {
    pay = payment();
    double change = pay - totalAfterDiscount;
    if (pay > totalAfterDiscount) {
      // if the amount is enough
      print(
          "\n/////////////////////////////////////////////////////////////////");
      print("                 Thank You For using our Vending Machine");
      print("   $date                                       ");
      print(
          "DESCRIPTION                                            AMOUNT(RM)");
      print(
          "*****************************************************************");

      for (var i = 0; i < totalProduct; i++) {
        double subtotal =
            itemList[i].getTotal(); //subtotal for each product that user bought
        if (itemList[i].getQuantity() > 0) {
          print(itemList[i].getName());
          print(
              "${itemList[i].getQuantity()} X ${itemList[i].getPrice()}                                                  ${subtotal}");
        }
      }
      ;

      print(
          "*****************************************************************");

      print(
          "TOTAL (Inc 6%GST)                                          ${totalAfterGst}");
      print(
          "DISCOUNT                                                    ${discount}");
      print("Cash                                                      ${pay}");
      print(
          "CHANGE                                                     ${change}");
      print("ITEM SOLD *${totalProductQuantity}");

      print("");
      print("THANK YOU & PLEASE COME AGAIN");
      print(
          "/////////////////////////////////////////////////////////////////");
      x = false;
    } else {
      print("Please insert more cash");
    }
  }
}

void main() {
  List itemList = []; // unlimited storage
  //name, price, quantity, stock
  itemList.add(Item('KitKat', 3.99, 0, 13));
  itemList.add(Item('Mars', 4.00, 0, 2));
  itemList.add(Item('Snickers', 5.00, 0, 3));
  itemList.add(Item('Oreo', 3.00, 0, 4));

  start(itemList);
  chooseItem(itemList);
  receipt(itemList);
}

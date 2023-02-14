enum OrderType { singleOrder, multipleOrder, blackFridayOrder }

abstract class Order {
  dynamic sum();
}

class SingleOrder extends Order {
  final int price;

  SingleOrder({required this.price});

  dynamic sum() {
    return price;
  }
}

class MultipleOrder extends Order {
  final List<Product> list;

  MultipleOrder({required this.list});

  dynamic sum() {
    var total = 0;

    for (var item in list) {
      if (item.discount == 0) {
        total += item.price;
      } else {
        total += item.price - item.discount;
      }
    }

    return total;
  }
}

class BlackFridayOrder extends Order {
  final List<Product> list;

  BlackFridayOrder({required this.list});

  dynamic sum() {
    var total = 0;

    for (var item in list) {
      total += item.price;
    }

    return total - total / 100 * 10;
  }
}

class Product {
  final String name;
  final int price;
  final int discount;

  Product({required this.price, required this.discount, required this.name});
}

class OrderFactory {
  static Order factory(OrderType orderType, List<Product> listOrders) {
    switch (orderType) {
      case OrderType.singleOrder:
        return SingleOrder(price: listOrders[0].price);
      case OrderType.blackFridayOrder:
        return BlackFridayOrder(list: listOrders);
      default:
        return MultipleOrder(list: listOrders);
    }
  }
}

var prod1 = Product(name: 'Джинсы', price: 100, discount: 0);
var prod2 = Product(name: 'Кофта', price: 80, discount: 3);

var order1 = [prod1];
var order2 = [prod1, prod2];

dynamic calculateSum(List<Product> listOfOrders, bool blackFriday) {
  Order userOrder;

  if (listOfOrders.length == 1) {
    userOrder = OrderFactory.factory(OrderType.singleOrder, listOfOrders);
  }

  if (blackFriday) {
    userOrder = OrderFactory.factory(OrderType.blackFridayOrder, listOfOrders);
  } else {
    userOrder = OrderFactory.factory(OrderType.multipleOrder, listOfOrders);
  }

  return userOrder.sum();
}

void main(List<String> arguments) {
  print(calculateSum(order1, false));
  print(calculateSum(order2, false));
  print(calculateSum(order2, true));
}

/*
  Задача.

  Выдача кредитов клиентам

  Условия

  Если клиенту до 25 лет то мы выдаем кредит под 3.6% годовых процента

  Если клиент уже является пользователем нашего банка то 7%, даже если ему меньше 25 лет

  Если это новый клиент и ему больше 25 лет то 10% годовых

  пример реализации

  Есть 3 клиента

  client1 = Client(age: 24, isAccount: false, deposit: 100)
  client1.calculateCredit() => 103.6 $

  client2 = Client(age: 24, isAccount: true, deposit: 100)
  client3 = Client(age: 26, isAccount: true, deposit: 100)
  client2.calculateCredit() => 107 $
  client3.calculateCredit() => 107 $

  client4 = Client(age: 26, isAccount: false, deposit: 100)
  client4.calculateCredit() => 110 $
*/

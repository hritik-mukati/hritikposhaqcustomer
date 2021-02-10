import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

//PAYTM DETAILS STARTS
const PAYMENT_URL =
    "https://us-central1-poshaq-customer.cloudfunctions.net/customFunctions/payment";

const ORDER_DATA = {
  "custID": "USER_1122334455",
  "custEmail": "someemail@gmail.com",
  "custPhone": "7777777777"
};

const STATUS_LOADING = "PAYMENT_LOADING";
const STATUS_SUCCESSFUL = "PAYMENT_SUCCESSFUL";
const STATUS_PENDING = "PAYMENT_PENDING";
const STATUS_FAILED = "PAYMENT_FAILED";
const STATUS_CHECKSUM_FAILED = "PAYMENT_CHECKSUM_FAILED";

// PAYTM DETAILS ENDS

class Constants {
  static final String APP_NAME = "Poshaq";
  static final PRIMARY_COLOR = Colors.black;
  static final ACCENT_COLOR = Colors.white;
  static final BACKGROUND_COLOR = Colors.grey[100];
  static final APP_BAR_COLOR = Colors.white;
}

class API {
  static final String key = "abc";

  // static final String BaseUrl= "https://www.saffronitsystems.com/dproject/index.php/";
  static final String BaseUrl =
      "https://www.saffronitsystems.com/dproject_dev/index.php/";

  //Dashboard
  static var fetchbanner = BaseUrl + "Admin/fetchInfoBanner";
  static var fetchbannerper = BaseUrl + "Product/dashboard_getProductByPercent";
  static var fetchbannerpirce = BaseUrl + "Product/dashboard_getProductByPrice";

  //login all
  static var login = BaseUrl + "Login/customer_login";
  static var logout = BaseUrl + "Customer/deleteDeviceToken";
  static var register = BaseUrl + "Login/register_customer";
  static var check = BaseUrl + "Login/user_exist";
  static var snedOTP = BaseUrl + "Login/sendOTP";
  static var checkgooglelogin = BaseUrl + "Login/customer_google_login";
  static var registergooglelogin = BaseUrl + "Login/register_customer_google";

  //Cart
  static var add_cart = BaseUrl + "Customer/addToCart";
  static var add_cart_login = BaseUrl + "Customer/addToCartLogin";
  static var fetch_cart = BaseUrl + "Customer/getCart";
  static var delete_cart = BaseUrl + "Customer/deleteCart";

  //Wishlist
  static var add_wishlist = BaseUrl + "Customer/addToWishlist";
  static var fetch_wishlist = BaseUrl + "Customer/getWishlist";
  static var delete_wishlist = BaseUrl + "Customer/deleteWishlist";

  //checkout
  static var getaddress = BaseUrl + "Customer/getAddress";
  static var addaddress = BaseUrl + "Customer/addAddress";
  static var deleteaddress = BaseUrl + "Customer/deleteAddress";
  static var delivery = BaseUrl + "Customer/checkDelivery";

  //Order
  static var add_order = BaseUrl + "Customer/addOrder";
  static var updatePaytm = BaseUrl + "Customer/updatePaytmOrderId";

  //product
  static var fetch_all_cat = BaseUrl + "Customer/getAllCategory";
  static var fetch_product = BaseUrl + "Product/getProductByCategory";
  static var fetch_product_by_catname =
      BaseUrl + "Customer/getProductByCatName";

  static var fetch_new_product = BaseUrl + "Customer/getNewProducts";
  static var fetch_detailed = BaseUrl + "Product/getProductDetailById";
  static var fetchmyordersdetailed = BaseUrl + "Admin/fetchOrderDetail";
  static var fetchmyorders = BaseUrl + "Admin/fetchOrders";
  static var updateOrderStatus = BaseUrl + "Admin/updateOrderStatus";
  static var upvote = BaseUrl + "Customer/addUpvote";
  static var dovote = BaseUrl + "Customer/deleteUpvote";
  static var trending = BaseUrl + "Product/dashboard_getTrendingProducts";

  //search
  static var search1 = BaseUrl + "customer/search1";
  static var search2 = BaseUrl + "customer/search2";

  //DEEP Link Function

}

extension ExtendedText on String {
  TextWithColor({var color}) {
    var c = color == null ? Constants.PRIMARY_COLOR : color;
    return Text(
      this,
      style: TextStyle(color: c),
    );
  }
}

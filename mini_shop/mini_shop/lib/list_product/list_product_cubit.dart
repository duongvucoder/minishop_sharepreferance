import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_shop/list_product/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListProductCubit extends Cubit<ProductState> {
  ListProductCubit() : super(ProductInitState());

  List<ProducModel> listProduct = [];
  List<ProducModel> listProductSelected = [];
  SharedPreferences? preferences;

  void addItemToCart(ProducModel model) async {
    if (!listProductSelected.contains(model)) {
      listProductSelected.add(model);
      emit(ProductGetSuccessState());
    }
    await saveListProductSelected();
  }

  void updateDataSelectedNew(List<ProducModel> newSelected) {
    listProductSelected = newSelected;
    emit(ProductGetSuccessState());
    saveListProductSelected();
  }

  void onRemoveItemSelected(ProducModel model) {
    listProductSelected.remove(model);
    emit(ProductGetSuccessState());
    saveListProductSelected();
  }

  Future saveListProductSelected() async {
    List<String> listDataString = [];
    for (ProducModel producModel in listProductSelected) {
      Map<String, dynamic> dataJson = Map<String, dynamic>();
      dataJson['name'] = producModel.name;
      dataJson['price'] = producModel.price;
      int colorValue = producModel.color!.value;
      dataJson['color'] = colorValue;
      String dataString = jsonEncode(dataJson);
      listDataString.add(dataString);
    }
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    preferences!.setStringList('dataProductCart', listDataString);
  }

  Future converListStringToListModel() async {
    emit(ProductGettingState());
    await Future.delayed(Duration(seconds: 2));
    for (String item in itemNames) {
      ProducModel model = ProducModel();
      model.name = item;
      model.price = 42;
      Random random = Random();
      model.color = Color.fromARGB(
        random.nextInt(255),
        random.nextInt(255),
        random.nextInt(255),
        1,
      );
      listProduct.add(model);
    }
    emit(ProductGetSuccessState());
  }

  Future getListProductSelected() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }

    List<String>? dataListString =
        preferences!.getStringList('dataProductCart');
    if (dataListString != null) {
      for (String obj in dataListString) {
        Map<String, dynamic> dataMap = jsonDecode(obj);
        ProducModel productModel = ProducModel();
        productModel.name = dataMap['name'];
        productModel.price = dataMap['price'];
        productModel.color = Color(dataMap['color']);
        listProductSelected.add(productModel);
      }
    }
    emit(ProductGetSuccessState());
  }

  List<String> itemNames = [
    'Gà KFC',
    'Trà sữa',
    'Vịt quay bắc kinh',
    'Sữa chua hạ long',
    'Gà ủ muối',
    'Bia Tiger',
    'Spaghetti',
    'Pizza',
    'Bánh mì hội an',
    'Phở thìn',
    'Chân gà',
    'Coffee',
    'Trà',
    'Xôi',
    'Cơm',
  ];
}

class ProductState {}

class ProductInitState extends ProductState {}

class ProductGettingState extends ProductInitState {}

class ProductGetSuccessState extends ProductInitState {}

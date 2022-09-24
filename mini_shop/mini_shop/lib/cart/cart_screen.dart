import 'package:flutter/material.dart';
import 'package:mini_shop/list_product/product_model.dart';

class CartScreen extends StatefulWidget {
  final List<ProducModel> listProductSelected;
  const CartScreen({Key? key, required this.listProductSelected})
      : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<ProducModel> _listProductIncart = [];
  @override
  void initState() {
    _listProductIncart = widget.listProductSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int tongTien = 0;
    for (ProducModel obj in widget.listProductSelected) {
      tongTien += obj.price ?? 0;
    }

    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Cart',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(_listProductIncart);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 20,
                ),
                itemBuilder: (context, index) {
                  ProducModel model = _listProductIncart[index];

                  return _itemWiget(model, () {
                    _listProductIncart.remove(model);
                    setState(() {});
                  });
                },
                itemCount: _listProductIncart.length,
              ),
            ),
            Expanded(
                child: Text(
              'TỔNG TIỀN: $tongTien',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
          ],
        ),
      ),
    );
  }

  Widget _itemWiget(ProducModel model, Function onRemove) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
              child: Text(
            '${model.name}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          )),
          InkWell(
            onTap: () {
              onRemove();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                Icons.remove_circle,
              ),
            ),
          )
        ],
      ),
    );
  }
}

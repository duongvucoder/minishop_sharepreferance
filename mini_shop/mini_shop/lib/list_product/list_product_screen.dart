import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_shop/cart/cart_screen.dart';
import 'package:mini_shop/list_product/list_product_cubit.dart';
import 'package:mini_shop/list_product/product_model.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({Key? key}) : super(key: key);

  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool _runFistTime = true;

  void myInitState(ListProductCubit listProductCubit) async {
    await listProductCubit.converListStringToListModel();
    await listProductCubit.getListProductSelected();
  }

  @override
  Widget build(BuildContext context) {
    final listProductCubit = BlocProvider.of<ListProductCubit>(context);
    if (_runFistTime) {
      _runFistTime = false;
      myInitState(listProductCubit);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: InkWell(
          child: Text('Danh mục'),
        ),
        actions: [
          InkWell(
            onTap: () async {
              final data = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    listProductSelected: listProductCubit.listProductSelected,
                  ),
                ),
              );
              if (data != null) {
                listProductCubit.updateDataSelectedNew(data);
                listProductCubit.listProductSelected = data;
              }
            },
            child: BlocBuilder<ListProductCubit, ProductState>(
              bloc: listProductCubit,
              builder: (context, state) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.shopping_cart),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                              '${listProductCubit.listProductSelected.length}'),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
      body: BlocBuilder<ListProductCubit, ProductState>(
        builder: (context, ProductState state) {
          if (state is ProductGettingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProductGetSuccessState &&
              listProductCubit.listProduct.isNotEmpty) {
            List<ProducModel> listProducts = listProductCubit.listProduct;
            return ListView.separated(
              itemBuilder: (context, index) {
                return ItemProductWidget(
                  producModel: listProducts[index],
                  onAddItem: (ProducModel model) {
                    listProductCubit.addItemToCart(model);
                  },
                  isSelected: listProductCubit.listProductSelected
                      .contains(listProducts[index]),
                );
              },
              itemCount: listProductCubit.listProduct.length,
              separatorBuilder: ((context, index) => SizedBox(
                    height: 12,
                  )),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class ItemProductWidget extends StatelessWidget {
  final ProducModel producModel;
  final Function(ProducModel producModel) onAddItem;
  final bool isSelected;
  const ItemProductWidget(
      {Key? key,
      required this.producModel,
      required this.onAddItem,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          color: producModel.color ?? Colors.grey,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(child: Text('${producModel.name}')),
        isSelected
            ? Icon(Icons.check)
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Text(
                    'Thêm',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    onAddItem(producModel);
                    //  print('${producModel.name}');
                  },
                ),
              ),
      ],
    );
  }
}

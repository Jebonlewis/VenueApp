import 'package:flutter/material.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/screens/vendor/additem_details.dart';
import 'package:venue/screens/vendor/branch_details.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.1),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back, // Use the back arrow icon
              color: Colors.black,
            ),
            onPressed: () {
              NavigationUtils.navigateToPage(context, BranchDetails());
            },
          ),
          title: Text(
            'Add Items',
            style: TextStyle(fontSize: 19, color: Colors.black),
          )),
          body:Center(child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/package.png'),
                SizedBox(height: 10,),
              Text('Add Your Items',
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 7,),
               Text('Tap Below Button To Add Items',
              style: TextStyle(fontSize: 14,color: Colors.grey),),
              SizedBox(height: 7,),
               Text('In Your Stall',
              style: TextStyle(fontSize: 14,color: Colors.grey),),
                SizedBox(height: 15,),
                GestureDetector(onTap: (){
                   NavigationUtils.navigateToPage(context,AdditemDetails());
                },
             child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                 
                  borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.black,
                )
                ),
                child: Center(
                  child:Text('ADD ITEMS')
                ),
              ),
                ),
            ],

          ),
          ),
    );

  }
}
import 'package:bounce_tapper/bounce_tapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:umkmfirebase/models/firebaseUser.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/services/appServices.dart';

class HomePage extends StatefulWidget {
  final Function(int) changePage;
  final UserModel user;
  HomePage({super.key, required this.changePage,  required this.user});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  child: Text(widget.user.namaUMKM),
                ),
                showMenu()
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget showMenu(){
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  widget.changePage(1);
                },
                child: BounceTapper(
                  child: Card(
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icons/inventory.png", scale: 10,),
                            Text("Inventaris", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ).animate().scale(),
                ),
              ),

              GestureDetector(
                onTap: (){
                  widget.changePage(2);
                },
                child: BounceTapper(
                  child: Card(
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icons/note.png", scale: 10,),
                            Text("Cacatan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ).animate().scale(),
                ),
              ),
              GestureDetector(
                onTap: (){
                  widget.changePage(3);
                },
                child: BounceTapper(
                  child: Card(
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icons/cart.png", scale: 10,),
                            Text("Penjualan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ).animate().scale(),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  widget.changePage(4);
                },
                child: BounceTapper(
                  child: Card(
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icons/report.png", scale: 10,),
                            Text("Keuangan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ).animate().scale(),
                ),
              ),

              GestureDetector(
                onTap: (){

                },
                child: BounceTapper(
                  child: Card(
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icons/tersimpan.png", scale: 10,),
                            Text("Download", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ).animate().scale(),
                ),
              ),
              GestureDetector(
                onTap: (){
                },
                child: BounceTapper(
                  child: Card(
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/icons/pengingat.png", scale: 10,),
                            Text("Pengingat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ).animate().scale(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

}


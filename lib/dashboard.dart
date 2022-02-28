import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: size.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage('assets/images/top_header.png')
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.all(40.0),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 64,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: NetworkImage('https://w7.pngwing.com/pngs/304/305/png-transparent-man-with-formal-suit-illustration-web-development-computer-icons-avatar-business-user-profile-child-face-web-design.png'),
                        ),
                        SizedBox(width: 25,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Mattia Marra", style: TextStyle(fontFamily: 'Montserrat Medium', color: Colors.white, fontSize: 20),),
                            Text("tbarbera98@gmail.com")
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) => Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            setState(() {
                              //myProducts.removeAt(index);
                              //richiesta elimazione animale
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0)
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 55.0,
                                          height: 55.0,
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage('https://creazilla-store.fra1.digitaloceanspaces.com/emojis/58264/dog-face-emoji-clipart-md.png')
                                          ),
                                        ),
                                        SizedBox(width: 20.0),
                                        Padding(
                                          padding: EdgeInsets.all(13.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Hiro", style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                      child: FlatButton(
                                        onPressed: () {},
                                        color: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text("Modifica"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          background: Container(
                            color: Colors.red,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.centerRight,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    color: Colors.indigoAccent,
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () {  },
                    )
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taass_frontend_android/model/animale.dart';
import 'package:taass_frontend_android/model/utente.dart';
import 'package:taass_frontend_android/utente/pagine/dettagli_animale.dart';
import 'package:taass_frontend_android/utente/service/utente_service.dart';

class Dashboard extends StatefulWidget {
  late Utente user;

  Dashboard(this.user);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  UtenteService httpService = UtenteService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Animale animale = Animale(id: 0, nome: '', dataDiNascita: DateTime.now() , patologie: [], razza: '', peso: 0, peloLungo: false);
          Navigator.push(context, new MaterialPageRoute(builder: (__) => new DettagliAnimale(widget.user,animale,true)));
        },
      ),
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
                            Text(widget.user.nome, style: TextStyle(fontFamily: 'Montserrat Medium', color: Colors.white, fontSize: 20),),
                            Text(widget.user.email)
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: widget.user.animali.length,
                        itemBuilder: (BuildContext context, int index) => Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            setState(() {
                              //myProducts.removeAt(index);
                              //richiesta elimazione animale
                              httpService.removeAnimal(widget.user,widget.user.animali[index]);
                              widget.user.animali.removeAt(index);
                              print('Eliminato correttamente');
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
                                child: SingleChildScrollView( //altrimenti overflow row right
                                  scrollDirection: Axis.horizontal,
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
                                                Text(widget.user.animali[index].nome, style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => DettagliAnimale(widget.user,widget.user.animali[index],false),
                                                ));
                                          },
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

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}
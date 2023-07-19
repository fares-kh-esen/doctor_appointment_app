import 'package:woorack_app/components/button.dart';
import 'package:woorack_app/models/auth_model.dart';
import 'package:woorack_app/providers/dio_provider.dart';
import 'package:woorack_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components//custom_appbar.dart';

class GroomerDetails extends StatefulWidget {
  const GroomerDetails({Key? key, required this.groomer, required this.isFav})
      : super(key: key);
  final Map<String, dynamic> groomer;
  final bool isFav;

  @override
  State<GroomerDetails> createState() => _GroomerDetailsState();
}

class _GroomerDetailsState extends State<GroomerDetails> {
  Map<String, dynamic> groomer = {};
  bool isFav = false;

  @override
  void initState() {
    groomer = widget.groomer;
    isFav = widget.isFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Groomer Details',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          //Favarite Button
          IconButton(
            //press this button to add/remove favorite groomer
            onPressed: () async {
              //get latest favorite list from auth model

              //update the list into auth model and notify all widgets
              auth.setFavList(groomer);

              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';

              //if (token.isNotEmpty && token != '') {
              //update the favorite list into database
              //final response =
//await DioProvider().storeFavGroomer(token, list);
              //if insert successfully, then change the favorite status

              //if (response == 200) {
              //setState(() {
              //isFav = !isFav;
              //});
              //  }
              //}
            },
            icon: FaIcon(
              Provider.of<AuthModel>(context).hasGroomerInFavs(groomer)
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AboutGroomer(
                groomer: groomer,
              ),
              DetailBody(
                groomer: groomer,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Button(
                  width: double.infinity,
                  title: 'Book Appointment',
                  onPressed: () {
                    Navigator.of(context).pushNamed('booking_page',
                        arguments: {"groomer_id": groomer['groomer_id']});
                  },
                  disable: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutGroomer extends StatelessWidget {
  const AboutGroomer({Key? key, required this.groomer}) : super(key: key);

  final Map<dynamic, dynamic> groomer;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 65.0,
            backgroundImage: NetworkImage(
              "${groomer['user']['profile_photo_url']}",
            ),
            backgroundColor: Colors.white,
          ),
          Config.spaceMedium,
          Text(
            "${groomer['user']['name']}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Purrfection Catz Grooming Academy, Malaysia',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Groomer Malaysia Institute',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({Key? key, required this.groomer}) : super(key: key);
  final Map<dynamic, dynamic> groomer;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Config.spaceSmall,
          GroomerInfo(
            patients: groomer['patients'] ?? 0,
            exp: groomer['experience'] ?? 0,
          ),
          Config.spaceMedium,
          const Text(
            'About Groomer',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Config.spaceSmall,
          Text(
            'Ms. ${groomer['user']['name']} is an experience ${groomer['category']} groomer at Sarawak, graduated since 2008, and completed his/her training at Groomer Malaysia Academy.',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}

class GroomerInfo extends StatelessWidget {
  const GroomerInfo({Key? key, required this.patients, required this.exp})
      : super(key: key);

  final int patients;
  final int exp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InfoCard(
          label: 'Patients',
          value: '$patients',
        ),
        const SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Experiences',
          value: '$exp years',
        ),
        const SizedBox(
          width: 15,
        ),
        const InfoCard(
          label: 'Rating',
          value: '4.6',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Config.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

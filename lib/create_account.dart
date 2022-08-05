import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';


import 'models/firebase_user_model.dart';

void main() => runApp(const CreateAccountLess());

final _dobController = TextEditingController();
final _firstNameController = TextEditingController();
final _lastNameController = TextEditingController();
String? _gender = 'Choose your Gender';

//var _country = 'Choose your Country';
final _areaOfInterestController = TextEditingController();
final _emailController = TextEditingController();
final _phoneController = TextEditingController();
final _addressController = TextEditingController();
final _countryController = TextEditingController();
final _stateController = TextEditingController();
final _pinCodeController = TextEditingController();
final _usernameController = TextEditingController();
String? _securityQuestion = 'Select your Security Question';
final _securityAnswerController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();
List<Country> countries = [];
Country? _country;

class Country {
  String? abbreviation;
  String? capital;
  String? currency;
  String? name;
  String? phone;
  int? population;
  Media? media;
  int? id;

  Country(
      {this.abbreviation,
      this.capital,
      this.currency,
      this.name,
      this.phone,
      this.population,
      this.media,
      this.id});

  Country.fromJson(Map<String, dynamic> json) {
    abbreviation = json['abbreviation'];
    capital = json['capital'];
    currency = json['currency'];
    name = json['name'];
    phone = json['phone'];
    population = json['population'];
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['abbreviation'] = this.abbreviation;
    data['capital'] = this.capital;
    data['currency'] = this.currency;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['population'] = this.population;
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class Media {
  String? flag;
  String? emblem;
  String? orthographic;

  Media({this.flag, this.emblem, this.orthographic});

  Media.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    emblem = json['emblem'];
    orthographic = json['orthographic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['emblem'] = this.emblem;
    data['orthographic'] = this.orthographic;
    return data;
  }
}

Future<List<Country>> fetchCountries() async {
  String url = 'https://api.sampleapis.com/countries/countries';
  final response = await http.get(Uri.parse(url));
  print(response.body);

  if (response.statusCode == 200) {
    //var data = json.decode(response.body);
    return parseCountries(response.body);
  } else {
    throw Exception('Failed to load Countries');
  }
}

List<Country> parseCountries(String responseBody) {
  final parsed = jsonDecode(responseBody);
  print(parsed);

  return parsed.map<Country>((json) => Country.fromJson(json)).toList();
}

class CreateAccountLess extends StatelessWidget {
  const CreateAccountLess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const CreateAccountFul(),
    );
  }
}

class CreateAccountFul extends StatefulWidget {
  const CreateAccountFul({Key? key}) : super(key: key);

  @override
  _CreateAccountFulState createState() => _CreateAccountFulState();
}

class _CreateAccountFulState extends State<CreateAccountFul> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref('users');
  bool isLoaded = false;

  void isLoading() {
    setState(() {
      isLoaded = !isLoaded;
    });
  }

  void _signUp() async {
    isLoading();

    await _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _confirmPasswordController.text)
        .whenComplete(() async{
      FireBaseUserModel model = FireBaseUserModel(
        _auth.currentUser!.uid,
          _firstNameController.text,
          _lastNameController.text,
          _gender,
          _dobController.text,
          _areaOfInterestController.text,
          _emailController.text,
          _phoneController.text,
          _addressController.text,
          _countryController.text,
          _stateController.text,
          _pinCodeController.text,
          _usernameController.text,
          _passwordController.text,
          _confirmPasswordController.text,
          _securityQuestion,
          _securityAnswerController.text);
      user = _auth.currentUser;
      await ref.child(user!.uid).set(model.toJson());

      //firestore.collection('Users').doc(user?.uid).set(model.toJson());
      isLoading();
      Navigator.pushReplacementNamed(context, 'Login');
    });
  }

  int _index = 0;

  List<Step> _steps() {
    List<Step> _stepsToCreateAccount = [
      Step(
        isActive: _index >= 0,
        title: const Text('Step 1'),
        content: const Page1(),
      ),
      Step(
        isActive: _index >= 1,
        title: const Text('Step 2'),
        content: const Page2(),
      ),
      Step(
          isActive: _index >= 2,
          title: const Text('Step 3'),
          content: const Page3()),
    ];
    return _stepsToCreateAccount;
  }

  Widget createAccountScreen() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 700,
              child: Theme(
                data: ThemeData(
                    primaryColor: Colors.orange,
                    primarySwatch: Colors.orange,
                    colorScheme:
                        const ColorScheme.light(primary: Colors.orange)),
                child: Stepper(
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_index == 2) {
                              _signUp();
                              const snackBar = SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                    'You have created account successfully'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }

                            setState(() {
                              if ((_steps().length - 1) > _index) {
                                setState(() {
                                  _index++;
                                });
                              }
                            });
                          },
                          child: Text(_index == 2 ? 'Done' : 'Next')),
                    );
                  },
                  steps: _steps(),
                  elevation: 0.0,
                  type: StepperType.horizontal,
                  currentStep: _index,
                  onStepContinue: () {},
                  onStepTapped: (int value) {
                    setState(() {
                      _index = value;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Stack(
        children: [
          createAccountScreen(),
          isLoaded
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    color: Colors.blue,
                  ),
                )
              : Container(),
        ],
      ),
    ));
  }
}

Widget textField(
    TextEditingController controller, String label, String hintText) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        label: Text(label), border: OutlineInputBorder(), hintText: hintText),
  );
}

Widget sizedBoxOfHeight(double heightOfBox) {
  return SizedBox(
    height: heightOfBox,
  );
}

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final List<DropdownMenuItem<String>> _listOfDropMenu = [
    const DropdownMenuItem<String>(
      child: Text('Choose your Gender'),
      value: 'Choose your Gender',
    ),
    const DropdownMenuItem<String>(
      child: Text('Male'),
      value: 'Male',
    ),
    const DropdownMenuItem<String>(
      child: Text('Female'),
      value: 'Female',
    ),
    const DropdownMenuItem<String>(
      child: Text('Others'),
      value: 'Others',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Personal Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        sizedBoxOfHeight(20),
        textField(_firstNameController, 'First Name', 'Enter your First name here'),
        sizedBoxOfHeight(20),
        textField(_lastNameController, 'Last Name', 'Enter your last name here'),
        sizedBoxOfHeight(20),
        DropdownButtonFormField<String>(
          items: _listOfDropMenu,
          onChanged: (String? value) {
            setState(() {
              _gender = value;
            });
          },
          //Todo  Typecast
          // As Keyword
          // parse
          //.cast
          value: _gender,
          decoration: const InputDecoration(
              label: Text('Gender'),
              border: OutlineInputBorder(),
              hintText: "Choose your gender"),
        ),
        sizedBoxOfHeight(20),
        TextField(
          showCursor: false,
          controller: _dobController,
          onTap: () async {
            DateTime? selected = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1920),
                lastDate: DateTime.now());
            setState(() {
              _dobController.text = DateFormat(
                'dd/MM/yyyy',
              ).format(selected!);
            });
          },
          decoration: const InputDecoration(
              label: Text('DOB'),
              border: OutlineInputBorder(),
              hintText: "Enter your Date of Birth"),
        ),
        sizedBoxOfHeight(20),
        textField(_areaOfInterestController, 'Area Of Interest',
            'Type your area of interest'),
      ],
    );
  }
}

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountry();
    print(getCountry());
  }

  Future getCountry() async {
    countries = await fetchCountries();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Contact Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        sizedBoxOfHeight(20),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
              label: Text('Email'),
              border: OutlineInputBorder(),
              hintText: "Enter your Email here"),
        ),
        sizedBoxOfHeight(20),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
              label: Text('Phone-no'),
              border: OutlineInputBorder(),
              hintText: "Enter your Phone no here"),
        ),
        sizedBoxOfHeight(20),
        textField(_addressController, 'Address', 'Enter your Address'),
        sizedBoxOfHeight(20),
        DropdownButtonFormField(
          itemHeight: null,
          isExpanded: true,
          items: countries.map((item) {
            return DropdownMenuItem<Country>(
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  SizedBox(
                      height: 24,
                      width: 24,
                      child: Image.network(item.media!.flag!)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(item.name ?? 'Bangladesh'),
                  Text('<${item.abbreviation}>'),
                  Text(item.phone.toString()),
                ],
              ),
              value: item,
            );
          }).toList(),
          onChanged: (value) {
            setState(() {});
          },
          value: _country,
          decoration: const InputDecoration(
              label: Text('Country'),
              border: OutlineInputBorder(),
              hintText: "Choose your country"),
        ),
        sizedBoxOfHeight(20),
        TextField(
          controller: _stateController,
          decoration: const InputDecoration(
              label: Text('State/UT'),
              border: OutlineInputBorder(),
              hintText: "Select your State/UT "),
        ),
        sizedBoxOfHeight(20),
        textField(_pinCodeController, 'Pincode', 'Enter your Pincode'),
      ],
    );
  }
}

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  bool _isCheck = false;
  bool _password = true;
  bool _confirmPassword = true;

  final List<DropdownMenuItem<String>> _listOfDropMenu = [
    const DropdownMenuItem<String>(
      child: Text('Select your Security Question'),
      value: 'Select your Security Question',
    ),
    const DropdownMenuItem<String>(
      child: Text('Which is your Favourite Book'),
      value: 'Which is your Favourite Book',
    ),
    const DropdownMenuItem<String>(
      child: Text('Your first mobile phone'),
      value: 'Your first mobile phone',
    ),
    const DropdownMenuItem<String>(
      child: Text('Your Second name'),
      value: 'Your Second name',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Last Step to create account ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        const SizedBox(
          height: 20,
        ),
        textField(_usernameController, 'Username', 'Create your username'),
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: _passwordController,
          obscureText: _password,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _password = !_password;
                  });
                },
                icon: _password
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
              label: const Text('Password'),
              border: const OutlineInputBorder(),
              hintText: "Enter your Password"),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: _confirmPasswordController,
          obscureText: _confirmPassword,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _confirmPassword = !_confirmPassword;
                  });
                },
                icon: _confirmPassword
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
              label: const Text('Confirm password'),
              border: const OutlineInputBorder(),
              hintText: "Confirm your password"),
        ),
        const SizedBox(
          height: 20,
        ),
        DropdownButtonFormField(
          items: _listOfDropMenu,
          onChanged: (String? value) {
            _securityQuestion = value;
          },
          decoration: const InputDecoration(
              label: Text('Security Question'),
              border: OutlineInputBorder(),
              hintText: "Select your Security Question"),
        ),
        const SizedBox(
          height: 20,
        ),
        textField(_securityAnswerController, 'Security Answer',
            'Type your Security Answer'),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Checkbox(
                value: _isCheck,
                onChanged: (bool? value) {
                  setState(() {
                    _isCheck = value!;
                  });
                }),
            const Text('I agree your terms and conditions'),
          ],
        )
      ],
    );
  }
}

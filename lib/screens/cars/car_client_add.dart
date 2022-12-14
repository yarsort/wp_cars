import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wp_car/models/api_response.dart';
import 'package:wp_car/models/car.dart';
import 'package:wp_car/screens/auth/login.dart';
import 'package:wp_car/services/car_service.dart';
import 'package:wp_car/services/user_service.dart';
import 'package:wp_car/system/system.dart';

class ScreenCarClientAdd extends StatefulWidget {
  final Car? car;

  const ScreenCarClientAdd({
    Key? key,
    this.car,
  }) : super(key: key);

  @override
  State<ScreenCarClientAdd> createState() => _ScreenCarClientAddState();
}

class _ScreenCarClientAddState extends State<ScreenCarClientAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String pathCarImage = '';

  bool _loading = false;
  final _picker = ImagePicker();
  File? _imageFile;
  List<String> listImages = [];

  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _nicknameTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _yearProductionTextController =
      TextEditingController();
  final TextEditingController _mileageTextController = TextEditingController();
  final TextEditingController _vinCodeTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: widget.car == null
            ? const Text('Створення')
            : const Text('Редагування'),
        actions: [
          IconButton(onPressed: () {_saveCar();}, icon: const Icon(Icons.save)),
        ],
      ),
      body: _loading ? bodyProgress() : bodyData(),
    );
  }

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createUserCar(
        _nameTextController.text,
        _nicknameTextController.text,
        _descriptionTextController.text,
        _yearProductionTextController.text,
        _mileageTextController.text,
        _vinCodeTextController.text,
        image);

    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const ScreenLogin()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  void _editPost(int postId) async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);

    ApiResponse response = await editUserCar(
        postId,
        _nameTextController.text,
        _nicknameTextController.text,
        _descriptionTextController.text,
        _yearProductionTextController.text,
        _mileageTextController.text,
        _vinCodeTextController.text,
        image);
    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const ScreenLogin()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  void _loadPost() async {
    if (widget.car == null) {
      return;
    }
  }

  void _saveCar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = !_loading;
      });
      if (widget.car == null) {
        _createPost();
      } else {
        _editPost(widget.car!.id);
      }
    }
  }

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Widget bodyProgress() {
    return const Center(
        child: CircularProgressIndicator(
      value: null,
      strokeWidth: 4.0,
    ));
  }

  Widget bodyData() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _imageFile == null ? imageFieldsEmpty() : imageFields(),
            textFields(),
            buttonSaving(),
          ],
        ));
  }

  Widget editCarImage() {
    return Positioned(
        bottom: 10,
        right: 10,
        child: InkWell(
          onTap: (){
            getImage();
          },
          child: Ink(
              child:
                  Icon(Icons.edit, size: 30, color: Colors.teal.shade300)),
        ));
  }

  Widget imageFieldsEmpty() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              getImage();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1.0, color: Colors.grey.shade300),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0), //
                ),
              ),
              height: 200,
              width: double.infinity,
              child:
                  Icon(Icons.car_repair, size: 100, color: Colors.grey.shade200),
            ),
          ),
          editCarImage(),
        ],
      ),
    );
  }

  Widget imageFields() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Stack(children: [
        GestureDetector(
          onTap: (){
            getImage();
          },
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1.0, color: Colors.grey.shade300),
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0), //
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.file(
                _imageFile!,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        editCarImage(),
      ]),
    );
  }

  Widget textFields() {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          /// Назва
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextFormField(
              controller: _nameTextController,
              keyboardType: TextInputType.text,
              validator: (val) =>
                  val!.isEmpty ? 'Заповніть назву автомобіля' : null,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'Назва автомобіля',
                  hintText: "Вкажіть назву автомобіля...",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.grey.shade200))),
            ),
          ),

          /// Нік
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextFormField(
              controller: _nicknameTextController,
              keyboardType: TextInputType.text,
              validator: (val) => val!.isEmpty ? 'Кличка автомобіля' : null,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'Кличка автомобіля',
                  hintText: "Не обов'язково...",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.grey.shade200))),
            ),
          ),

          /// Опис автомобіля
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextFormField(
              controller: _descriptionTextController,
              keyboardType: TextInputType.multiline,
              maxLines: 9,
              validator: (val) =>
                  val!.isEmpty ? 'Заповніть опис автомобіля' : null,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  labelText: 'Опис автомобіля',
                  hintText: 'Вкажіть опис автомобіля...',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.grey.shade200))),
            ),
          ),

          /// Рік виробництва
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextFormField(
              controller: _yearProductionTextController,
              keyboardType: TextInputType.datetime,
              validator: (val) =>
                  val!.isEmpty ? 'Заповніть рік виробництва' : null,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'Рік виробництва',
                  hintText: '',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.grey.shade200))),
            ),
          ),

          /// Пробіг
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextFormField(
              controller: _mileageTextController,
              keyboardType: TextInputType.number,
              validator: (val) => val!.isEmpty ? 'Заповніть пробіг' : null,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'Пробіг (км)',
                  hintText: '',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.grey.shade200))),
            ),
          ),

          /// VIN
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextFormField(
              controller: _vinCodeTextController,
              keyboardType: TextInputType.text,
              validator: (val) => val!.isEmpty ? 'Заповніть VIN-код' : null,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'VIN-код',
                  hintText: '',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.grey.shade200))),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonSaving() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: kTextButton('Зберегти', () {
          _saveCar();
        }));
  }
}

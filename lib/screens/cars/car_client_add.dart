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
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: widget.car == null
            ? const Text('Створення')
            : const Text('Редагування'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
        ],
      ),
      body: _loading ? bodyProgress() : bodyData(),
    );
  }

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createCar(
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

    ApiResponse response = await editCar(
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
            textFields(),
            buttonSaving(),
          ],
        ));
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
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _nameTextController,
              keyboardType: TextInputType.text,
              validator: (val) =>
                  val!.isEmpty ? 'Заповніть назву автомобіля' : null,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'Назва автомобіля',
                  hintText: "Вкажіть назву автомобіля...",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black38))),
            ),
          ),

          /// Нік
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _nicknameTextController,
              keyboardType: TextInputType.text,
              validator: (val) => val!.isEmpty ? 'Кличка автомобіля' : null,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'Кличка автомобіля',
                  hintText: "Не обов'язково...",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black38))),
            ),
          ),

          /// Опис автомобіля
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _descriptionTextController,
              keyboardType: TextInputType.multiline,
              maxLines: 9,
              validator: (val) =>
                  val!.isEmpty ? 'Заповніть опис автомобіля' : null,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  labelText: 'Опис автомобіля',
                  hintText: 'Вкажіть опис автомобіля...',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black38))),
            ),
          ),

          /// Рік виробництва
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _yearProductionTextController,
              keyboardType: TextInputType.text,
              validator: (val) =>
                  val!.isEmpty ? 'Заповніть рік виробництва' : null,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'Рік виробництва',
                  hintText: '',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black38))),
            ),
          ),

          /// Пробіг
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _mileageTextController,
              keyboardType: TextInputType.text,
              validator: (val) => val!.isEmpty ? 'Заповніть пробіг' : null,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'Пробіг (км)',
                  hintText: '',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black38))),
            ),
          ),

          /// VIN
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _vinCodeTextController,
              keyboardType: TextInputType.text,
              validator: (val) => val!.isEmpty ? 'Заповніть VIN-код' : null,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'VIN-код',
                  hintText: '',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black38))),
            ),
          ),

        ],
      ),
    );
  }

  Widget buttonSaving() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
        child: kTextButton('Зберегти', (){
          if (_formKey.currentState!.validate()){
            setState(() {
              _loading = !_loading;
            });
            if (widget.car == null) {
              _createPost();
            } else {
              _editPost(widget.car!.id);
            }
          }
        }));
  }
}

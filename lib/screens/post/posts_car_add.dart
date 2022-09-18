import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wp_car/models/api_response.dart';
import 'package:wp_car/models/car.dart';
import 'package:wp_car/models/post.dart';
import 'package:wp_car/screens/auth/login.dart';
import 'package:wp_car/services/post_service.dart';
import 'package:wp_car/services/user_service.dart';
import 'package:wp_car/system/system.dart';

class ScreenPostsCarAdd extends StatefulWidget {
  final Car carItem;

  const ScreenPostsCarAdd({
    Key? key,
    required this.carItem,
  }) : super(key: key);

  @override
  State<ScreenPostsCarAdd> createState() => _ScreenPostsCarAddState();
}

class _ScreenPostsCarAddState extends State<ScreenPostsCarAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Post post = Post();
  String pathCarImage = '';

  bool _loading = false;
  final _picker = ImagePicker();
  File? _imageFile;
  List<String> listImages = [];

  String categoryId = '1';
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
  TextEditingController();
  final TextEditingController _mileageTextController = TextEditingController();
  final TextEditingController _costTextController = TextEditingController();

  final TextEditingController _tagsTextController = TextEditingController();
  bool draft = false;
  bool enableComments = true;

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
        title: widget.carItem == null
            ? const Text('Створення')
            : const Text('Редагування'),
        actions: [
          IconButton(onPressed: () {_savePost();}, icon: const Icon(Icons.save)),
        ],
      ),
      body: _loading ? bodyProgress() : bodyData(),
    );
  }

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createCarPost(
        categoryId,
        widget.carItem.id.toString(),
        _titleTextController.text,
        _descriptionTextController.text,
        _mileageTextController.text,
        _costTextController.text,
        _tagsTextController.text,
        draft,
        enableComments,
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

    ApiResponse response = await editCarPost(
        widget.carItem.id,
        post.id,
        _titleTextController.text,
        _descriptionTextController.text,
        int.parse(_mileageTextController.text),
        double.parse(_costTextController.text),
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
    if (widget.carItem == null) {
      return;
    }
  }

  void _savePost() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = !_loading;
      });
      if (post.id == 0) {
        _createPost();
      } else {
        _editPost(widget.carItem.id);
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
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _imageFile == null ? imageFieldsEmpty() : imageFields(),
            textFields(),
            buttonSaving(),
          ],
        ));
  }

  Widget editPostImage() {
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
            onTap: (){
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
          editPostImage(),
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
        editPostImage(),
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
              controller: _titleTextController,
              keyboardType: TextInputType.text,
              validator: (val) =>
              val!.isEmpty ? 'Заповніть заголовок публікації' : null,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'Заголовок публікації',
                  hintText: "Вкажіть заголовок публікації...",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 1, color: Colors.grey.shade200))),
            ),
          ),

          /// Опис статті
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextFormField(
              controller: _descriptionTextController,
              keyboardType: TextInputType.multiline,
              maxLines: 9,
              validator: (val) =>
              val!.isEmpty ? 'Заповніть текст публікації' : null,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  labelText: 'Текст публікації',
                  hintText: 'Вкажіть текст публікації...',
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
              //validator: (val) => val!.isEmpty ? 'Заповніть пробіг' : null,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'Пробіг (км)',
                  hintText: 'Не обов\'язково',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 1, color: Colors.grey.shade200))),
            ),
          ),

          /// Вартість ремонту
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextFormField(
              controller: _costTextController,
              keyboardType: TextInputType.number,
              //validator: (val) => val!.isEmpty ? 'Заповніть вартість' : null,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  labelText: 'Вартість',
                  hintText: 'Не обов\'язково',
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
          _savePost();
        }));
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/authentication/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final BuildContext scaffoldContext;

  UserProfile({
    @required this.scaffoldContext,
    Key key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final profilePicturePicker = ImagePicker();
  Image _imageProvider;
  bool _loadingImage = false;
  String _imageUrl;

  @override
  Widget build(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context);

    if (userRepository.user?.photoURL != null && _imageProvider == null) {
      setState(() {
        _imageUrl = userRepository.user.photoURL;
        _imageProvider = _initImage(_imageUrl);
      });
    }

    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(start: 5.0),
              child: _userAvatar()
            ),
            Container(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userRepository.user.email, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                Container(height: 10,),
                RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    textColor: Colors.white,
                    elevation: 0.0,
                    color: Theme.of(context).accentColor,
                    child: Text('Change avatar'),
                    onPressed: () => _changeAvatar(userRepository)
                )
              ],
            )
          ],
        )
      ),
    );
  }


  Future<void> _changeAvatar(UserRepository userRepository) async {
    final pickedFile = await profilePicturePicker.getImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      Scaffold.of(widget.scaffoldContext).showSnackBar(
          SnackBar(content: Text('No image selected'))
      );

      return;
    }
    setState(() {
      _loadingImage = true;
    });
    final file = File(pickedFile.path);
    final url = await userRepository.updateAvatar(file);

    setState(() {
      _loadingImage = false;
      _imageUrl = url;
      _imageProvider = _initImage(url);
    });
  }

  Widget _userAvatar() {
    if(_loadingImage) {
      return Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
        child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
            child: CircularProgressIndicator()
        ),
      );
    }

    if (_imageUrl == null) {
      return Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
        child: Center(child: Icon(Icons.person, color: Colors.grey[500], size: 50,)),
      );
    }

    return ClipOval(
      child: _imageProvider,
    );
  }

  Image _initImage(url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: 70,
      height: 70,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }

        final percentage = progress.expectedTotalBytes != null ?
            progress.cumulativeBytesLoaded / progress.expectedTotalBytes :
            null;

        return Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
          child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
              child: CircularProgressIndicator(value: percentage)
          ),
        );
      },
    );
  }
}
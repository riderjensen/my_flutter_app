import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();

  // on creation of widget
  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    super.initState();
  }

  // on deleteiong of widget
  @override
  void dispose() {
    _addressInputFocusNode.removeListener((_updateLocation));
    super.dispose();
  }

  void _updateLocation() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          focusNode: _addressInputFocusNode,
        )
      ],
    );
  }
}

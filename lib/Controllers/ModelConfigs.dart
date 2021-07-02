import 'package:flutter/material.dart';

final Map<int, Widget> models = <int, Widget>{
  0: Text('SRWNN'),
  1: Text('ESRGAN (photo)'),
};

final Map<int, Widget> styles = <int, Widget>{
  0: Text('Ilustration (anime)'),
  1: Text('Photo'),
};

final Map<int, Widget> noise = <int, Widget>{
  0: Text('    0    '),
  1: Text('    1    '),
  2: Text('    2    '),
  3: Text('    3    '),
};

final Map<int, Widget> blurLevel = <int, Widget>{
  0: Text('    0    '),
  1: Text('    1    '),
  2: Text('    2    '),
  3: Text('    3    '),
};

final Map<int, Widget> expand = <int, Widget>{
  0: Text('No'),
  1: Text('Yes'),
};

final Map<int, Widget> upscale = <int, Widget>{
  0: Text('2x'),
  1: Text('4x'),
};

final Map<int, Widget> execution = <int, Widget>{
  0: Text('Local'),
  1: Text('Web'),
};
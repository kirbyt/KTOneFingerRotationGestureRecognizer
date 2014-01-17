HFUCWRotationalPanRecognizer
============================

HFUCWRotationalPanRecognizer is a custom UIGestureRecognizer for doing one finger rotations in iOS apps. It tracks the angle of finger movement about a point (defined in the co-ordinate space of the gesture's view's superview). 

By default it excludes/stops tracking a gesture that approaches too close to the rotation origin (default 40pts) or if the gesture leaves the view (pointInside: return NO). 

A velocity is available only at the end of a gesture and it is based only on the last two touches. This met my requirements but yours may differ.  

The rotation angle provided is the total rotation through the current gesture although if you prefer incremental movements (e.g. because you are updating the view transformation) you can set this to zero after reading it. This matches the behaviour of the UIPanGestureRecognizer which keeps the total translation unless reset.

Only single finger touches are processed.

This [article](https://www.informit.com/articles/article.aspx?p=1998968&seqNum=12) by Erica Sadun good source if you are writing your own UIGestureRecognizer.


KTOneFingerRotationGestureRecognizer
====================================

KTOneFingerRotationGestureRecognizer is a custom UIGestureRecognizer for doing one finger rotations in iOS apps. It tracks finger movement around a central point.


License
=======

The MIT License

Copyright (c) 2014 Human-Friendly Ltd. HFUCWRotationalPanRecognizer (.c/.h)

Copyright (c) 2011 White Peak Software Inc (Excludes 
HFUCWRotationalPanRecognizer(.c/.h) which were developed externally and dropped
in as replacements for KTOneFingerRotationGestureRecognizer).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
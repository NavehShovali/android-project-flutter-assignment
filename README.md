# hello_me

## Dry Part

### Q1

The class used to implement the controller pattern in the *Snapping Sheet* library is `SnappingSheetController`, which allows programmatically modifying or reading the `currentSnapPosition`, and reading or reassigning the `snapPositions` list.

### Q2

The parameter that controls the animations of snapping the sheet into different positions is the `snappingCurve`, which determines the type of animation, and `snappingDuration`, which determines the duration of the animation. These two parameters belong to the class `SnapPosition`, which is used to determine where and how the snapping sheet will snap into various positions.

### Q3
*InkWell* and *GestureDetector* both provide many similar features, enabling the option to set a desired behavior when tapping them, double-tapping  them, and more. However, the latter also allows for setting a behavior for events like dragging the widget, while the former does not. On the other hand, *InkWell* supports the ripple animation when tapping it, as oppose to *GestureDetector*.

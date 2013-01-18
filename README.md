matrixView
==========

A simple custom matrix view like grid view or system collection view.

IOS3.2 above.

Implementaion logic: Just a simple 90 degree transformation.

1. It is used like system tableview, there is one tableview visble to the user, you should implement your datasource and delegate.
2. The tableview can have one or more sections, each section is also a tableview transformed by 90.
3. Each section can have many your custom cells, the number of cells can be different for different sections.

cc65-floatlib
=============

a naive approach for using kernal floating point numbers on C64, while using IEEE float values at application level

right now CC65 does not support floats by itself, this library is a wrapper to the C64 kernal floating point routines and can be used to call these from C. It may serve as a starting point for a proper library once CC65 has been updated to  support floating point.

TODO:

- actually use IEEE floats, the current code uses some funny binary format :)
- fix atan2
- fix the polynom calculation functions
- implement more missing functions
- improve the tests
- disable the BASIC errors somehow(?)

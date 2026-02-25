
        .if .def (__VIC20__)
            .include "float-vic20.inc"
        .elseif .def (__C64__)
            .include "float-c64.inc"
        .elseif .def (__C128__)
            .include "float-c128.inc"
        .else
            .error "Unsupported target"
        .endif

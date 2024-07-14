
        .if .def (__VIC20__)
            .include "float-vic20.inc"
        .elseif .def (__C64__)
            .include "float-c64.inc"
        .else
            .error "Unsupported target"
        .endif

# makefile
# Erstellt von IBM WorkFrame/2 MakeMake um 21:11:28 am 2 Juli 2012
#
# Diese Make-Datei enth„lt folgende Aktionen:
#  Compile::C++ Compiler

!IFNDEF LVMTK
!ERROR LVMTK environment var must point to LVM toolkit base directory !
!ENDIF

!IFNDEF TOOLKIT
!ERROR TOOLKIT environment var must point to the OS/2 toolkit base directory !
!ENDIF


!IF [SET SMINCLUDE=.;$(SMINCLUDE);] || \
    [SET INCLUDE=.;$(CPPMAIN)\INCLUDE;$(SOMBASE)\INCLUDE;$(SOMBASE:som=H);$(LVMTK)\include;] || \
    [SET LIB=$(CPPMAIN)\LIB;$(SOMBASE:som=LIB);$(SOMBASE)\LIB;$(LVMTK)\lib;] || \
    [SET PATH=$(TOOLKIT)\SOM\BIN;$(TOOLKIT)\BIN;$(CPPMAIN)\BIN;$(OSDIR:ecs=EMX)\BIN;]
!ENDIF



.SUFFIXES:

.SUFFIXES: .cpp .obj .idl .rc .res

!IFDEF DEBUG
CFLAGS=-Ti -Fb*
LFLAGS=-de -db -br
!ELSE
CFLAGS=-O
LFLAGS=
!ENDIF

.idl.cpp:
       @echo " Compile::SOM Compiler "
       sc.exe -C200000 -S200000 -sxc;xh;xih $<

.cpp.obj:
       @echo " Compile::C++ Compiler "
       icc.exe -Q -Sp1 -W2 $(CFLAGS) -Gm -Gd -Ge- -G5 -C $<

.rc.res:
	   @echo " Compile::Resource Compiler "
	   rc.exe -n -r $< $@

LIBS   = somtk.lib lvm.lib
OBJS   = filesys.obj system.obj
DEF    = filesys.def
RES    = filesys.res

filesys.dll: $(OBJS) $(RES) $(DEF)
       @echo " Link::Linker "
       -7 ilink.exe -nol -nobas $(LFLAGS) -dll -packc -packd -e:2 -m -o:$@ $(LVMTK)\ $(OBJS) $(LIBS) $(DEF)
	   rc.exe -n -x2 $(RES) $@
       dllrname.exe $@ CPPOM30=OS2OM30 /n /q
       emxupd.exe $@ $(OS2_SHELL:CMD.EXE=DLL)

filesys.res: filesys.rc

filesys.obj: filesys.cpp

filesys.cpp: filesys.idl
system.cpp : system.idl


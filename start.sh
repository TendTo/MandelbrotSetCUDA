#!/bin/bash

helpPrompt(){
    echo "$0 - compiles and executes the mandelbrot set program"
    echo " "
    echo "use: $0 [arguments]"
    echo " "
    echo "arguments:"
    echo "-h, --help                show brief help"
    echo "-s  --skip-compiling      skip the compilation of the executable"
    echo "-e, --execute             launch the compiled executable"
    echo "-i, --include=PATH        specify the path where the SFML headers are stored. Default is ./include"
    echo "-l, --lib=PATH            specify the path where the SFML libraries are stored. Default is ./lib"
    exit 0
}

compile(){
    echo "--------------------------------"
    echo "Starting compilation"
    echo "--------------------------------"

    # Launch cuda compiler
    nvcc -o ./bin/mandelbrot_set.exe src/main.cpp src/Mandelbrot_set.cpp src/kernel.cu -I$1 -Isrc -L$2 -lsfml-graphics -lsfml-window -lsfml-system 

    echo "--------------------------------"
    echo "Compilation ended"
    echo "--------------------------------"
}

execute(){
    echo "--------------------------------"
    echo "Starting executable"
    echo "--------------------------------"

    # Launching the executable telling it where to find the SFML libraries
    LD_LIBRARY_PATH=$1 ./bin/mandelbrot_set.exe
}

fExecute=""
fCompile=true
includedir=./include
libdir=./lib

# Create the bin directory if it doesn't exist already
if [ ! -d ./bin ]; then
    mkdir bin
fi

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      helpPrompt
      ;;
    -e)
      fExecute=true
      shift
      ;;
    --execute)
      fExecute=true
      shift
      ;;
    -s)
      fCompile=
      shift
      ;;
    --skip-compiling)
      fCompile=
      shift
      ;;
    -i)
      shift
      if test $# -gt 0; then
        includedir=$1
      else
        echo "no lib dir specified"
        exit 1
      fi
      shift
      ;;
    --include*)
      includedir=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    -l)
      shift
      if test $# -gt 0; then
        libdir=$1
      else
        echo "no lib dir specified"
        exit 1
      fi
      shift
      ;;
    --lib*)
      libdir=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      helpPrompt
      ;;
  esac
done

if [ $fCompile ]; then
compile $includedir $libdir
fi

if [ $fExecute ]; then
    execute $libdir
fi

# If SFML is not installed in a standard path, you need to tell the dynamic linker where to find the SFML libraries first by specifying LD_LIBRARY_PATH
# LD_LIBRARY_PATH=<sfml-install-path>/lib ./bin/mandelbrot_set.exe
#LD_LIBRARY_PATH=./lib ./bin/mandelbrot_set.exe

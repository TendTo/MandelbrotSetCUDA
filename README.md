# Mandelbrot set CUDA
The aim of this project is just for me to practice CUDA programming while trying some fun ideas.

### :eyes: Preview
![](graphics/vid/demo.gif)

### Commands:
| Move | Zoom in/out | Increase/Decrease max iteration | Reset | Hide/Show HUD |
| :---: | :---: | :---: | :---: | :---: |
| L-click or WASD or Arrows| Mousewheel or +/- | E/Q | R | H |

## :wrench: Requirements
The project written in c++ and uses:
- [CUDA](https://developer.nvidia.com/cuda-zone) 
- [SFML](https://www.sfml-dev.org/index.php)

## :keycap_ten: On windows (See master branch)
Things to download:
- [CUDA](https://developer.nvidia.com/cuda-downloads)
- [SFML](https://www.sfml-dev.org/download.php)
- [Visual Studio](https://visualstudio.microsoft.com/it/downloads/) (for its MSVC compiler)

The program uses the standard CUDA libraries and some SFML libraries.  
All SFML libraries can be both static or dynamic and each has a debug version (just add a -d at the end).  
You should use the debug version when compiling in DEBUG.

Before compiling, make sure that the paths to the SFML libraries and headers you downloaded are correct.

### For the _dynamic_ linking you will need the following libraries (in VS you need to add .lib):
- sfml-graphics
- sfml-system
- sfml-window

The executable will need the following dll(s) to run:
- sfml-graphics-2.dll
- sfml-system-2.dll
- sfml-window-2.dll

### For the _static_ linking you will need the following libraries (in VS you need to add .lib):
- sfml-graphics-s
- sfml-system-s
- sfml-window-s
- opengl32
- winmm
- gdi32
- freetype

The following flag must be set:
- SFML_STATIC

### **Some intersting findings that may act as troubleshooting**
- CUDA on windows **needs** the MSVC compiler, so you don't have the choice to use mingw
- All the lib(s) and dll(s) in SFML have a debug version. You just need to add -d before the extension. You should use this version when compiling with the DEBUG flag
- If you want to use the static linking, make sure that you are compiling in _release_ mode, since otherwise the SFML libraries may conflict with the CUDA ones

## :penguin: On linux (See linux branch)
Things to download:
- [CUDA](https://developer.nvidia.com/cuda-downloads)
- [SFML](https://www.sfml-dev.org/download.php)

The program uses the standard CUDA libraries and some SFML libraries.  
Make sure that the paths to the SFML libraries and headers you downloaded is accessible to the nvidia compiler.

On linux, using static libraries is usually discuraged, so SFML provides only the dynamic version. You can, however, compile your own static libraries ([guide](https://www.sfml-dev.org/tutorials/2.5/compile-with-cmake.php))

### For the _dynamic_ linking you will need the following libraries:
- sfml-graphics
- sfml-system
- sfml-window

The executable will need the following .so to run:
- sfml-graphics.so.2.5
- sfml-system.so.2.5
- sfml-window.so.2.5

Run `sh start.sh -h` to know what flags you may want to add, then run `sh start.sh [flags]` with the desired flags.  
You can also run the nvcc compiler yourself.
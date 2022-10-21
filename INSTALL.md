## Installing software

### macOS
First, update Homebrew’s listing of available packages.
``` sh
% brew update
```
OCaml uses the X system to display graphics windows with interactive elements, but Apple doesn’t install X on Mac OS by default. To install it yourself, run:
``` sh
% brew install xquartz
```
You must now install opam. opam is the package manager for OCaml itself, and you will use it to manage our OCaml installation. opam allows you to install multiple OCaml versions simultaneously.
``` sh
% brew install pkg-config
% brew install gpatch
% brew install opam
```
At this point, restart your computer.

### Linux
First, update Linux’s index of available packages to make sure that everything you need can be found.
``` sh
% sudo apt-get update -y
```
The git program and several other useful tools need to be installed on Linux. You can do so with:
``` sh
% sudo apt-get install -y gcc make patch unzip m4 git xorg libx11-dev pkg-config
```
If you are using an Ubuntu VM on VMWare, you should also run the following command and restart your VM. These packages will help optimize Ubuntu for VMWare Workstation.
``` sh
% sudo apt-get install -y open-vm-tools open-vm-tools-desktop
```
Finally, run the following command to install opam, the OCaml package manager.
``` sh
% sudo apt-get install -y opam
```
</br>
</br>

## Installing graphics
If you do not already have OPAM set up, run the following command:
``` sh
% opam init -a
```
Now, install the graphics library that you will need to see the gui.
``` sh
% opam install -y graphics
```
At this point, restart your computer.
</br>
</br>

## Usage

- Run `make build` to build the project if it isn't built already. 
- Then, run `make play` to play the game.  
</br>
</br>

## Troubleshooting

### If the graphics window does not work on macOS  

**These instructions are for macOS only**  

Verify that the X11 libraries exist by running the following command:
``` sh
% find /opt -name libX11.6.dylib
```
The file should be found at /opt/X11/lib/libX11.6.dylib. If not, you’ll need to reinstall XQuartz. Run the following command.
``` sh
% brew install xquartz
```
If the terminal prompt states that xquartz is already installed, simply reinstall it using the following command:
``` sh
% brew reinstall xquartz
```
Then restart your computer and retry the `find` command.

If things still aren’t working, reinstall the OCaml `graphics` package.
``` sh
% opam uninstall graphics
% opam install graphics
```
Restart your computer again.
</br>
</br>

## Acknowledgements
- The instructions to set up the OCaml development environment was largely borrowed from Harvard University's CS51 class in "Abstraction and Design in Computation"
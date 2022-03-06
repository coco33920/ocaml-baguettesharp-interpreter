build:
  dune build
clean:
  dune clean
install:
  ./install.sh
  sudo cp baguette_sharp /usr/bin/
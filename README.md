# devshell-qmk_port_ch528.nix


## use step

1. install 
```shell

# install NRF Command line tools

echo 'use flake github-url --impure >> .envrc

direnv allow . # or direnv reload to fresh direnv


mkdir build

(cd build ; cmake -Dkeyboard=imk64 -Dkeymap=default ../)
(cd build ; make )




```


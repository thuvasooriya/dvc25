## dvcon25 workflow

install just command runner
https://github.com/casey/just

the first time you clone the repo you wont have the required toolchain and docker image.

you should have access to the private repo and setup the authentication with gh cli tool before this inorder to download the files seamlessly. or you'll have to manually go to the repo download the files from relases and place them in the required places.

if you have gh cli installed and authenticated then run `just setup` to download the required files and set them up in the required places.

now you can use the following commands

```bash
just run # run vivado simulation
just app # build the baremetal demo application ( you need docker for this )
just mif_replace # backup existing mif file and replace it with the new one from app command
```

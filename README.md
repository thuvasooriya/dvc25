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

### requirements

1. have docker installed
2. just command runner
   you can use the following command. replace `DEST` with where you want to install it. `$HOME/.local/bin` is recommended. but if you don't have that in `$PATH` already use some path that you already have in `$PATH`

   ```bash
   # !!! replace DEST with your path
   curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to DEST

   # the following command download and move to $HOME/.local/bin
   curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to $HOME/.local/bin
   ```

3. gh cli tool: https://cli.github.com/

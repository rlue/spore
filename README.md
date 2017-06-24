spore – Disseminate Your Dotfiles
=================================

Colonize a new machine with ease.

The idea is simple: keep all your favorite dotfiles inside `~/.config` (for easy synchronization and version control), then symlink them back into home (so that your programs can still find them). Spore is made up of three scripts that make it all happen.

Installation
------------

### Getting up and Running

#### Already have a `~/.config` directory?

```
$ git clone https://github.com/rlue/spore
$ mv spore/* spore/.[^.]* ~/.config
$ rmdir spore
$ cd ~/.config
$ git submodule init
$ git submodule update
$ _bin/import_dotfiles
```

#### Don’t?

```
$ git clone https://github.com/rlue/spore ~/.config
$ cd ~/.config
$ git submodule init
$ git submodule update
$ _bin/import_dotfiles
```

### Syncing Between Machines

Here are two options:

#### Syncthing

I use [Syncthing][st] to mirror directories between my desktop, my laptop, and my phone. I highly recommend it, especially since once you get it set up, it requires no manual intervention.

#### Git

It may also be nice to keep a copy of your config files as a git repo somewhere, just in the off chance you need access to your configuration on a computer that doesn’t belong to you.

**WARNING:** If you have any sensitive information in your config files (_e.g.,_ API or _especially_ pgp keys), do **NOT** push those to GitHub or any other public platform.

To do this on GitHub, for instance, first [create a new repository][new] (I suggest naming it `.config`). Then,

```
$ cd ~/.config

# track your new remote
# (I chose the name ‘in_situ’, but you can call it whatever you want)...
$ git remote add in_situ https://github.com/<your_username>/<your_repo>

# make the repo yours...
$ rm .gitignore README.md
$ git add .
$ git commit -m “Import dotfiles”

# and push.
$ git push -u in_situ master
```

### Updates

This project probably won’t see much in the way of improvements or future changes. But if it does, you can pull updates like so:

```
$ git fetch origin
$ git rebase origin/master
```

Usage
-----

The three scripts that make up Spore are located under `~/.config/_bin`. Each one accepts the same `-v`, `-f`, `-i`, `-n`, and `-h` flags used for most UNIX file utility commands. See the help messages (`-h`) for more details.

### `import_dotfiles`

Prompts you to select which dotfiles you’d like to migrate into `~/.config`. After it relocates them, it creates symbolic links to restore their presence in the home directory.

Before you do this, it’s advisable to

1. rewrite your configuration files as necessary to make them machine-/platform-aware, and
2. be judicious about which files you include (some package managers, for example, may create hidden directories that grow to many gigabytes in size, and keeping them synchronized between machines would serve little purpose).

### `spawn_links`

If you’ve placed any dotfiles into the `~/.config` directory manually, this script will symlink them as dotfiles in your home directory for you.

Be sure to remove the dot from the start of each filename; `spawn_links` automatically ignores all files that begin with a dot (`.`) or an underscore (`_`). (In addition, there are some files that are _supposed to_ live in `~/.config`, and don’t need to get symlinked back into the home directory. To ignore those files as well, simply list them in a file at `~/.config/.spawnignore`.)

**WARNING:** This script has the potential to overwrite existing dotfiles. By default (i.e., without the `-f` or `-i` flags), conflicting files are moved to a `~/clobber` directory. It’s a good idea to perform a dry-run first (i.e., include the `-v` and `-n` flags) to see what changes this script will make before actually committing to them.

### `purge_orphans`

Every so often, as you modify your config files, the dotfiles in your home directory may fall out of sync with the files stored in your `~/.config` folder. If you have any symlinked dotfiles that point to config files which no longer exist, you can clear them out with this script.

If you want to remove all the symlinks you’ve previously spawned, simply relocate your `~/.config` folder temporarily and then run this script:

```
$ mv ~/.config ~/config
$ ~/config/_bin/purge_orphans
$ mv ~/config ~/.config
```

(This works because moving the config directory orphans all previously spawned symlinks.)

License
-------

The MIT License (MIT)

Copyright © 2017 Ryan Lue

[st]: https://syncthing.net/
[new]: https://github.com/new

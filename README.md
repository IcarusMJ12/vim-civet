vim-civet: Can I copy your homework?

[vim-ls](https://github.com/gkz/vim-ls/): Yeah, just change it up a bit so it
doesn't look obvious you copied.

vim-civet:


## Civet

For more information about Civet see [civet.dev](https://civet.dev/).


### Installing and Using

1. Install [tpope's][tpope] [pathogen] into `~/.vim/autoload/` and add the
   following line to your `~/.vimrc`:

        call pathogen#infect()

     Be aware that it must be added before any `filetype plugin indent on`
     lines according to the install page:

     > Note that you need to invoke the pathogen functions before invoking
     > "filetype plugin indent on" if you want it to load ftdetect files. On
     > Debian (and probably other distros), the system vimrc does this early on,
     > so you actually need to "filetype off" before "filetype plugin indent on"
     > to force reloading.

[pathogen]: http://www.vim.org/scripts/script.php?script_id=2332
[tpope]: http://github.com/tpope/vim-pathogen

2. Create, and change into, the `~/.vim/bundle/` directory:

        $ mkdir -p ~/.vim/bundle
        $ cd ~/.vim/bundle

3. Make a clone of the `vim-civet` repository:

        $ git clone git://github.com/IcarusMJ12/vim-civet.git
        [...]
        $ ls
        vim-civet/

That's it. Pathogen should handle the rest. Opening a file with a `.civet`
extension will load everything.


### Updating

1. Change into the `~/.vim/bundle/vim-civet/` directory:

        $ cd ~/.vim/bundle/vim-civet

2. Pull in the latest changes:

        $ git pull

Everything will then be brought up to date.


### CM -- CivetMake -- Compile the Current File

The `CM` command compiles the current file and parses any errors.

The full signature of the command is:

    :[silent] CM[!] [civet-OPTIONS]...

By default, `CM` shows all compiler output and jumps to the first line
reported as an error by `civet`:

    :CM

Compiler output can be hidden with `silent`:

    :silent CM

Line-jumping can be turned off by adding a bang:

    :CM!

Options given to `CM` are passed along to `civet`:

    :CM --js

`CM` can be manually loaded for a file with:

    :compiler civet


#### Recompile on write

To recompile a file when it's written, add an `autocmd` like this to your
`vimrc`:

    au BufWritePost *.civet silent CM!

All of the customizations above can be used, too. This one compiles silently
and with the `-b` option, but shows any errors:

    au BufWritePost *.civet silent CM! -b | cwindow | redraw!

The `redraw!` command is needed to fix a redrawing quirk in terminal vim, but
can removed for gVim.


#### Default compiler options

The `CM` command passes any options in the `civet_make_options`
variable along to the compiler. You can use this to set default options:

    let civet_make_options = '--js'


#### Path to compiler

To change the compiler used by `CivetMake` and `CivetCompile`, set
`civet_compiler` to the full path of an executable or the filename of one
in your `$PATH`:

    let civet_compiler = '/usr/local/bin/civet'

This option is set to `civet` by default.


### CC -- CivetCompile -- Compile Snippets of Civet

The `CC` command shows how the current file or a snippet of
Civet is compiled to JavaScript. The full signature of the command is:

    :[RANGE] CC [watch|unwatch] [vert[ical]] [WINDOW-SIZE]

Calling `CC` without a range compiles the whole file.

Calling `CC` with a range, like in visual mode, compiles the selected
snippet of Civet.

The scratch buffer can be quickly closed by hitting the `q` key.

Using `vert` splits the CivetCompile buffer vertically instead of horizontally:

    :CC vert

Set the `ls_compile_vert` variable to split the buffer vertically by
default:

    let ls_compile_vert = 1

The initial size of the CivetCompile buffer can be given as a number:

    :CC 4


#### Watch (live preview) mode

Writing some code and then exiting insert mode automatically updates the
compiled JavaScript buffer.

Use `watch` to start watching a buffer (`vert` is also recommended):

    :CC watch vert

After making some changes in insert mode, hit escape and your code will
be recompiled. Changes made outside of insert mode don't trigger this recompile,
but calling `CC` will compile these changes without any bad effects.

To get synchronized scrolling of a Civet and CivetCompile buffer, set
`scrollbind` on each:

    :setl scrollbind

Use `unwatch` to stop watching a buffer:

    :CC unwatch


### Configure Syntax Highlighting

Add these lines to your `vimrc` to disable the relevant syntax group.


#### Disable trailing whitespace error

Trailing whitespace is highlighted as an error by default. This can be disabled
with:

    hi link lsSpaceError NONE


#### Disable reserved words error

Reserved words like `function` and `var` are highlighted as an error where
they're not allowed in Civet. This can be disabled with:

    hi link lsReservedError NONE


### Tune Vim for Civet

Changing these core settings can make vim more Civet friendly.


#### Fold by indentation

Folding by indentation works well for Civet functions and classes.
To fold by indentation in Civet files, add this line to your `vimrc`:

    au BufNewFile,BufReadPost *.civet setl foldmethod=indent nofoldenable

With this, folding is disabled by default but can be quickly toggled per-file
by hitting `zi`. To enable folding by default, remove `nofoldenable`:

    au BufNewFile,BufReadPost *.civet setl foldmethod=indent


#### Two-space indentation

To get standard two-space indentation in Civet files, add this line to
your `vimrc`:

    au BufNewFile,BufReadPost *.civet setl shiftwidth=2 expandtab

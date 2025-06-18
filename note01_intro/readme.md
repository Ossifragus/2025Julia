# Install Julia

More information available here: <https://julialang.org/install/>

1.  Install [juliaup](https://github.com/JuliaLang/juliaup):
    -   For Linux and macOS,
        
        ```bash
             curl -fsSL https://install.julialang.org | sh
        ```
    -   For Windows (you may need to install [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) first),
        
        ```powershell
             winget install --name Julia --id 9NJNWW8PVKMN -e -s msstore
        ```
2.  Install a specific version of julia
    
    ```bash
       juliaup add 1.11.5
    ```
3.  Launch Julia in a shell (you may need to [adjust your `PATH` variable](https://julialang.org/downloads/platform/)),
    
    ```bash
       julia +1.11.5
       julia +beta
       julia +beta -t 10
    ```
    
    Here, the `+1.11.5` and `+beta` specify the version of Julia to use; the `-t 10` gives the Julia access to 10 threads.


# Install VS Code and Julia extension

Download and install VS Code from [here](https://code.visualstudio.com/).

Install useful extensions:

-   launch VS Code and open the extensions view by either
    -   clicking on the extensions icon or
    -   pressing Ctrl-Shift-X (or Cmd-Shift-X on macOS)
-   type `julia` in the search bar and install the "Julia" extension
-   click on the Julia extension, then click on the "Manage" gear icon, and then click on "Settings".
-   Find the "Julia: Executable Path" setting and set it to the path of the specific Julia executable you installed above (e.g., `julia +beta -t 10`).


# Optional tools

1.  [IJulia](https://github.com/JuliaLang/IJulia.jl) (Jupyter notebook)

    Install IJulia from the Julia REPL by pressing `]` to enter pkg mode and entering:
    
    ```julia
    add IJulia
    ```
    
    If you already have Python/Jupyter installed on your machine, this process will also install a [kernel specification](https://jupyter-client.readthedocs.io/en/latest/kernels.html#kernelspecs) that tells Jupyter how to launch Julia. You can then launch the notebook server the usual way by running `jupyter notebook` in the terminal.
    
    Alternatively, you can have IJulia create and manage its own Python/Jupyter installation. To do this, type the following in Julia at the `julia>` prompt to launch the IJulia notebook in your browser:
    
    ```julia
    using IJulia
    notebook()
    ```
    
    The first time you run `notebook()`, it will prompt you for whether it should install Jupyter. Hit enter to have it use the [Conda.jl](https://github.com/Luthaf/Conda.jl) package to install a minimal Python+Jupyter distribution (via [Miniconda](http://conda.pydata.org/docs/install/quick.html)) that is private to Julia (not in your `PATH`).

2.  [Pluto](https://github.com/fonsp/Pluto.jl)

    Press `]` to enter pkg mode and enter:
    
    ```julia
    add Pluto
    ```
    
    To run the notebook server:
    
    ```julia
    julia> import Pluto
    julia> Pluto.run()
    ```
    
    Pluto will open in your browser, and you can get started!

3.  Git and GitHub extensions (optional)

    -   [Link to download Git](https://git-scm.com/downloads)
    -   [Instruction to create a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
    -   [Instruction to set up a SSH key](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
    -   The editor [VS Code](https://code.visualstudio.com/) has [builtin Git support](https://code.visualstudio.com/docs/editor/versioncontrol).
    -   The [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) is a powerful and feature rich extension. Type `git` in the search bar and install the "GitLens" or some other extensions that you find useful for working with Git repositories.
    
    1.  Some basic git commands
    
        -   `git clone RemoteRepoAddress`: clone a remote repository to your local computer
        -   `git status`: check status of your local repository
        -   `git config user.name "Your Name"`: set your name; use the option `--global` to set it globally, e.g., `git config --global user.name "Your Name"` so that it applies to all repositories on your computer that does not have local configuration.
        -   `git config user.email "Your Email"`: set your email you used to register on GitHub; it accepts the `--global` option as well.
        -   `git add filename`: add a file that is in the working directory to the staging area.
        -   `git rm filename`: remove files from the working tree and from the index; use the option `--cached` to keep the file and `-f` to force remove.
        -   `git commit -m "message" filename`: add file(s) that are staged to the local repository.
        -   `git fetch`: get files from the remote repository to the local repository but not into the working directory.
        -   `git merge`: get the files from the local repository into the working directory.
        -   `git pull`: get files from the remote repository directly into the working directory. It is equivalent to a git fetch and a git merge.
        -   `git push`: add all committed files in the local repository to the remote repository. So in the remote repository, all files and changes will be visible to anyone with access to the remote repository.
        -   use `git config pull.rebase false` or `git config pull.rebase true` to set Git merging or Git rebasing with conflicts; they accept the `--global` option as well.

4.  [Neovim](https://neovim.io/)

    -   Install Neovim from the official website: [here](https://neovim.io/).
    -   [Vim plugin for julia](https://github.com/JuliaEditorSupport/julia-vim).
    -   My setup of nvim is [here](https://github.com/Ossifragus/kickstart-modular.nvim). I am not a regular user of Neovim, so I do not have a lot of experience with it. However, I find it very useful for quick edits, as it is very fast and lightweight compared to other editors.

5.  [Emacs](https://www.gnu.org/software/emacs/)

    This is my daily editor, and I will use it during the course.
    
    -   Install Emacs from the official website: [here](https://www.gnu.org/software/emacs/).
    -   Some useful packages for Julia:
        -   [julia-mode](https://github.com/JuliaEditorSupport/julia-emacs), [julia-ts-mode](https://github.com/JuliaEditorSupport/julia-ts-mode): They provides syntax highlighting, indentation, and other features for editing Julia code in Emacs.
        -   [julia-repl](https://github.com/tpapp/julia-repl): It provides a REPL for Julia in Emacs, allowing you to run Julia code interactively.
        -   [eglot-jl](https://github.com/non-Jedi/eglot-jl): It provides LSP support for Julia in Emacs, allowing you to use features like code completion, go-to-definition, and more.
    -   My Emacs setup is [here](https://github.com/Ossifragus/.emacs.d).

# dotfiles

## PowerShell profile

`Microsoft.PowerShell_profile.ps1` is the PowerShell `$PROFILE`. On a new machine,
symlink it into place (requires admin or Developer Mode):

```powershell
New-Item -ItemType SymbolicLink -Path $PROFILE -Target "$PWD\Microsoft.PowerShell_profile.ps1" -Force
```

It relies on `starship` and `zoxide`:

```powershell
winget install Starship.Starship
winget install ajeetdsouza.zoxide
```

## Dependencies

The `.gitconfig` relies on these tools. Install them via winget:

```powershell
winget install Neovim.Neovim      # core.editor (nvim)
winget install dandavison.delta   # core.pager / interactive.diffFilter
winget install junegunn.fzf       # fuzzy pickers (af, uf, bf, rs aliases)
winget install GitHub.GitLFS      # filter.lfs
```

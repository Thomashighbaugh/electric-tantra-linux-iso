################################################################################
## .zshenv    ################################################################
################################################################################


# Global Order: zshenv, zprofile, zshrc, zlogin

## Dotfiles Location ###########################################################
cd "$(readlink ~/.zshrc | xargs dirname)"
export DOTFILES="$(git rev-parse --show-toplevel)"
cd - > /dev/null


## Sourcing Common Shell Files #################################################
source ${HOME}/.profile
source ${HOME}/.aliases


## Calling Sources #############################################################

for file in $(
  find "${HOME}/.zsh.d" -name '*.pre.zsh'
  find "${HOME}/.zsh.d" -name '*plugin.zsh' ! -name '*.pre.zsh' ! -name '*.post.zsh'
); do
  source "$file"
done









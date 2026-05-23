echo "THIS IS NOT A REAL SHELL-SCRIPT!"
exit 1

# ------------------

ag

zsh
	- install the oh-my-zsh
	- cp zshrc.local ~/.zshrc.local
	- source ~/.zshrc.local >> ~/.zshrc
	- PATH=/usr/local/bin:... # OSX-only
	- git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv

tmux
	- cp tmux.conf ~/.tmux.conf

vim
	- git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
	- vim +VundleInstall +qall
	- vim -c "VundleInstall"	

emacs
	1) install the emacs.
	2) mkdir -p ~/.emacs.d/
	3) cp init.el init2.el ~/.emacs.d
	4) git clone https://github.com/jwiegley/use-package ~/.emacs.d/use-package

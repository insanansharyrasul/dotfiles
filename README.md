# Dotfiles

This is my dotfiles for Ubuntu 22.04

# What is dotfile?

A dotfile is a hidden configuration file that starts with a dot (.) and is used to store settings for applications and tools. They are commonly found in the home directory. 

## Requirements

Ensure you have the following installed on your system

### Git

```
sudo apt install git
```

### Stow

```
sudo apt install stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com/insanansharyrasul/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks

```
$ stow .
```
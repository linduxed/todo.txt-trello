# todo.txt-trello

This is an add-on for the [`todo.txt-cli`](https://github.com/ginatrapani/todo.txt-cli/), for synchronizing Trello cards with the tasks in the `TODO_FILE`.

The idea is that a small token is added at the end of the various tasks in one's `TODO_FILE`, which corresponds to a URL that is saved in "mapping file" called `TODO_DIR/trello_cards.yml`.
Sample `trello_cards.yml` file below:

```plain
ABC: https://trello.com/c/foo/bar
DEF: https://trello.com/c/baz/quux
```

With this setup, with just a small token added to the tasks which have a corresponding Trello task, synchronizing the addition and completion of Trello cards can be done with a few simple commands.

## Installation

Start by cloning this repo.
As with all other add-ons, you'll need to place an executable in your `~/.todo.actions.d` folder (see [Installing Addons](https://github.com/ginatrapani/todo.txt-cli/wiki/Creating-and-Installing-Add-ons) for more information).

For this add-on, you can either create a symlink in the `~/.todo.actions.d` folder pointing to the executable ([`bin/trello`](bin/trello)), or generate a single file script that you can place in said folder.

#### Symlink

```plain
$ ln -s ~/.todo.actions.d/trello /foo/bar/todo.txt-trello/bin/trello
```

#### Generated script

```plain
$ /foo/bar/todo.txt-trello/generate_script > ~/.todo.actions.d/trello
$ chmod +x ~/.todo.actions.d/trello
```

You need Ruby, but any non-deprecated version of Ruby should work fine.
The `ruby-trello` gem needs to be installed.

```plain
$ gem install ruby-trello
```

## Configuration

The configuration for the add-on is put in the `TODO_FILE/trello_config.yml` file:

```yaml
developer_api_key: "32 character string"
developer_api_token: "65 character string"
username: your_username_here
board_url: https://trello/b/foo/bar
default_list_name: "Some list name"
```

The `developer_api_key` and `developer_api_token` you can obtain by going to this page: https://trello.com/app-key

`username` should be self-explanatory.

The `board_url` and `default_list_name` are necessary values, primarily for adding cards (since after adding them, the cards get unique URLs anyway).

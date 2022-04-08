# diary100

A simple command-line diary application. Designed to be quick and easy to use (as long as you know your way around).

## Requirements

Requires `dialog`, `git`, `bash` and `coreutils`; it also requires `ffmpeg` and `alsa` if you want to record audio entry.

On Desktop Ubuntu, all of these should be installed by default, except `ffmpeg`, `dialog` and `git`, I think.

## Usage

Create an empty git repository, and add this repo as a submodule. A recommended name for the submodule is `scripts`.

If you want to add audio, make an `audio/` subdirectory.

Next, when you want to use the diary, source the base.sh file (`. ./scripts/base.sh`).

Overall:

```sh
mkdir my-diary
cd my-diary
mkdir audio
git init
git submodule add https://github.com/hle0/diary100.git scripts
git commit -m "Initial commit (add submodule)"
cd scripts
git pull origin main
cd ..
```

Then, when you want to use commands:

```sh
. ./scripts/base.sh
```

After sourcing, you can then use the various commands:

| Command | Description |
|---------|-------------|
| `ecom`  | **Com**mit any **e**xisting staged changes. Fails if there are no staged changes. |
| `qcom`  | **Q**uickly **com**mit all unstaged changes. Fails if there are already staged changes. |
| `qed`   | **Q**uickly **ed**it (in `nano`) and commit some changes in a file. Prompts for confirmation. |
| `qad`   | **Q**uickly record and commit some **a**u**d**io. Plays it back and prompts for confirmation. Press q to stop recording. |

There are also a few internal commands that you probably won't ever use:

| Command   | Description |
|-----------|-------------|
| `chkdiff` | Returns 1 if there are unstaged changes to the git repo. 0 otherwise. |
| `com-sig` | Generate an informative commit signature about where and when a commit was performed. |


## License

This software is licensed under the MIT license. This means you're free to do basically whatever you want with it as long as you don't distribute the program, and you must abide by the very permissive MIT license if you choose to distribute or contribute to the program. Most users won't have to worry about this.

## Contributing

Contributions are always welcome.
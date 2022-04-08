# diary100

A simple command-line diary application. Designed to be quick and easy to use (as long as you know your way around).

## Requirements

Requires `dialog`, `git`, `bash` and `coreutils`; it also requires `ffmpeg` and `pulseaudio` if you want to record audio entry.

On Desktop Ubuntu, all of these should be installed by default, except `ffmpeg`, `dialog` and `git`, I think.

## Usage

Create an empty git repository, and add this repo as a submodule. A recommended name for the submodule is `scripts`.

Next, when you want to use the diary, source the base.sh file (`. ./scripts/base.sh`). You can then use the various commands (TODO: document here).

Overall:

```sh
mkdir my-diary
cd my-diary
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

## License

This software is licensed under the MIT license. This means you're free to do basically whatever you want with it as long as you don't distribute the program, and you must abide by the very permissive MIT license if you choose to distribute or contribute to the program. Most users won't have to worry about this.

## Contributing

Contributions are always welcome.
wasmtime-tutorial
=================

Simple Reproduction of this [wasmtime tutorial](
https://component-model.bytecodealliance.org/tutorial.html)


## Synopsis

```
$ make test

wasmtime run final.wasm 1 2 add
1 + 2 = 3

$
```


## Description

This repo has a Makefile that:

* Should work on MacOS/ARM or Linux/x86
* Fetches the tutorial input files
* Downloads the `wasmtime` and `wac` binaries
* Runs the build commands
* Run the `final.wasm` application with `wasmtime`

You just need to have Rust installed.


## Full Output

```
$ make realclean test    # First run

### Cloning https://github.com/bytecodealliance/component-docs to /tmp/component-docs

git clone https://github.com/bytecodealliance/component-docs /tmp/component-docs

### Fetching command

cp -r /tmp/component-docs/component-model/examples/tutorial/command command

### Fetching wit

cp -r /tmp/component-docs/component-model/examples/tutorial/wit wit

### Building command/target/wasm32-wasip1/release/command.wasm

(cd command && cargo component build --release)
  Generating bindings for command (src/bindings.rs)
   Compiling proc-macro2 v1.0.78
   Compiling unicode-ident v1.0.11
   Compiling utf8parse v0.2.1
   Compiling anstyle-query v1.0.2
   Compiling anstyle v1.0.4
   Compiling colorchoice v1.0.0
   Compiling wit-bindgen-rt v0.24.0
   Compiling heck v0.4.1
   Compiling anyhow v1.0.79
   Compiling strsim v0.10.0
   Compiling clap_lex v0.6.0
   Compiling bitflags v2.4.0
   Compiling anstyle-parse v0.2.3
   Compiling anstream v0.6.11
   Compiling clap_builder v4.4.18
   Compiling quote v1.0.36
   Compiling syn v2.0.48
   Compiling clap_derive v4.4.7
   Compiling clap v4.4.18
   Compiling command v0.1.0 (/home/user/wasmtime-tutorial/command)
    Finished `release` profile [optimized] target(s) in 3.14s
    Creating component target/wasm32-wasip1/release/command.wasm

### Fetching calculator

cp -r /tmp/component-docs/component-model/examples/tutorial/calculator calculator

### Building calculator/target/wasm32-wasip1/release/calculator.wasm

(cd calculator && cargo component build --release)
  Generating bindings for calculator (src/bindings.rs)
   Compiling wit-bindgen-rt v0.24.0
   Compiling bitflags v2.5.0
   Compiling calculator v0.1.0 (/home/user/wasmtime-tutorial/calculator)
    Finished `release` profile [optimized] target(s) in 0.24s
    Creating component target/wasm32-wasip1/release/calculator.wasm

### Fetching adder

cp -r /tmp/component-docs/component-model/examples/tutorial/adder adder

### Building adder/target/wasm32-wasip1/release/adder.wasm

(cd adder && cargo component build --release)
  Generating bindings for adder (src/bindings.rs)
   Compiling wit-bindgen-rt v0.24.0
   Compiling bitflags v2.4.0
   Compiling adder v0.1.0 (/home/user/wasmtime-tutorial/adder)
    Finished `release` profile [optimized] target(s) in 0.24s
    Creating component target/wasm32-wasip1/release/adder.wasm

### Installing bin/wac

mkdir -p bin
( cd /tmp && \
  wget -q https://github.com/bytecodealliance/wac/releases/download/v0.6.1/wac-cli-x86_64-unknown-linux-musl \
) && \
cp /tmp/wac-cli-x86_64-unknown-linux-musl bin/wac && \
chmod +x bin/wac

### Building composed.wasm

wac plug calculator/target/wasm32-wasip1/release/calculator.wasm --plug adder/target/wasm32-wasip1/release/adder.wasm -o composed.wasm

### Building final.wasm

wac plug command/target/wasm32-wasip1/release/command.wasm --plug composed.wasm -o final.wasm
( cd /tmp && \
  wget -q https://github.com/bytecodealliance/wasmtime/releases/download/v30.0.2/wasmtime-v30.0.2-x86_64-linux.tar.xz && \
  tar xf wasmtime-v30.0.2-x86_64-linux.tar.xz \
)

### Installing bin/wasmtime

cp /tmp/wasmtime-v30.0.2-x86_64-linux/wasmtime bin/wasmtime

wasmtime run final.wasm 1 2 add
1 + 2 = 3

$ make test    # Second run

wasmtime run final.wasm 1 2 add
1 + 2 = 3

$
```

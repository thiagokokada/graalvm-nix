# GraalVM derivations for Nix

## Introduction

This repository include multiple versions of GraalVM Community Edition (also
known as `graalvm-ce`) that are not available on
[nixpkgs](https://github.com/NixOS/nixpkgs) itself for some reason.

For example, nixpkgs generally includes only one version of GraalVM, often the
latest version. However it can also lag compared to upstream thanks to issues
that comes when bumping GraalVM and all packages that depends on it. This
repository in comparison has no such limitations, and may include multiple
versions of GraalVM when it does make sense.

Also, it is a ground for experimentation before upstreaming some changes. For
example, this repository includes `musl` variations of GraalVM derivations,
allowing for true static binaries (as oposed of using `--static` flag with
`glibc`). This is still not upstreamed since the solution is far from ideal. See
this [issue](https://github.com/NixOS/nixpkgs/issues/142392) for details.

Finally, another advantage is that everything is encapsulated into Flakes,
making it very easy to run ad-hoc. For example, using `nix run
"github:thiagokokada/graalvm-nix"` is sufficient to have a `musl` compatible
version of `native-image` for `graalvm11-ce`. See [usage](#usage-flakes) for
details.

## Usage (Flakes)

Assuming you have `nix` already installed:

```sh
# Not necessary if you're already are using nixUnstable
$ nix-shell -p nixUnstable
$ nix build --experimental-features 'nix-command flakes' "github:thiagokokada/graalvm-nix"
```

This will generate a `result` directory with the `graalvm11-ce` derivation with
`glibc` support by default. For example, you can find the GraalVM binaries on
`result/bin`.

You can edit your `/etc/nix/nix.conf` or `~/.config/nix/nix.conf` file and
add the following line to avoid having to pass `--experimental-features` flag
every time:

```ini
experimental-features = nix-command flakes
```

From here on this guide will assume the above configuration is done for brevity.

If you want `graalvm11-ce` with `glibc` support, you can use:

```sh
$ nix build "github:thiagokokada/graalvm-nix#graalvm11-ce"
```

If you want `graalvm17-ce` with `musl` support instead, you can use:

```sh
$ nix build "github:thiagokokada/graalvm-nix#graalvm17-ce-musl"
```

This Flake also export GraalVM binaries as apps to be used with `nix run`. For
example:

```sh
$ nix run "github:thiagokokada/graalvm-nix"
```

Will run `native-image` for the latest supported version of `graalvm11-ce` with
support for `glibc`. This is equivalent to:

```sh
$ nix run "github:thiagokokada/graalvm-nix#11/glibc/latest/native-image"
```

If you want `graalpython` on `graalvm17-ce` `21.2.0` instead with `musl`:

```sh
$ nix run "github:thiagokokada/graalvm-nix#17/musl/21_2_0/graalpython"
```

Or if you want `ruby` `graalvm11-ce` `21.3.0` with `musl`:

```sh
$ nix run "github:thiagokokada/graalvm-nix#11/musl/21_3_0/ruby"
```

If you want to check a list of all available apps, see `resources/bin-names.nix`
file.

Keep in mind `musl` variations only works on Linux, and also only makes sense if
you want to use `native-image --static --libc=musl`. Otherwise both variations
should be equal. You should use non-musl variations on macOS.

## Example

See [this PR](https://github.com/thiagokokada/babashka/pull/1) for an example on
how to use this repository to compile GraalVM applications.

## Known issues

`musl` variations must have the `--libc=musl` flag passed to `native-image`,
otherwise the build will fail with linking errors.

`irb` on GraalVM 21.3.0 is broken on all platforms.

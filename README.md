# GraalVM-CE Flake for Nix

Usage (assuming you have `nix` already installed):

```shellsession
# Not necessary if you're already are using nixUnstable
$ nix-shell -p nixUnstable
$ nix build --experimental-features 'nix-command flakes' "git+https://gist.github.com/thiagokokada/9803f71bdb82f701b4d2be0112c5a64c"
```

This will generate a `result` directory with the `graalvm11-ce` derivation with
`musl` support by default. For example, you can find the GraalVM binaries on
`result/bin`.

If you want `graalvm11-ce` with `glibc` support, you can use:

```shellsession
$ nix build --experimental-features 'nix-command flakes' "git+https://gist.github.com/thiagokokada/9803f71bdb82f701b4d2be0112c5a64c#graalvm11-ce"
```

If you want `graalvm17-ce` with `musl` support instead, you can use:

```shellsession
$ nix build --experimental-features 'nix-command flakes' "git+https://gist.github.com/thiagokokada/9803f71bdb82f701b4d2be0112c5a64c#graalvm17-ce-musl"
```

This Flake also export `native-image` as apps to be used with `nix run`. For example:


```shellsession
$ nix run --experimental-features 'nix-command flakes' "git+https://gist.github.com/thiagokokada/9803f71bdb82f701b4d2be0112c5a64c"
```

Will run `native-image` for `graalvm11-ce` with support for `musl`. Don't forget
to pass `--libc=musl`, otherwise the builds will fail!

If you want `graalvm17-ce` instead with `glibc`:

```shellsession
$ nix run --experimental-features 'nix-command flakes' "git+https://gist.github.com/thiagokokada/9803f71bdb82f701b4d2be0112c5a64c#native-image-17"
```

Or if `musl`:

```shellsession
$ nix run --experimental-features 'nix-command flakes' "git+https://gist.github.com/thiagokokada/9803f71bdb82f701b4d2be0112c5a64c#native-image-17-musl"
```

Keep in mind `musl` variations only makes sense on Linux. You should use
non-musl variations on macOS.

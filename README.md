# devin-desktop-nix

A Nix flake that provides a ready-to-use environment for **Devin Desktop**, including toolchains for **Rust and Java development, building, and testing**.

This setup is designed so you can open Devin Desktop and immediately compile, run, and test Rust and Java projects without manually installing toolchains or configuring the environment.

---

### 🧩 Native runtime libraries

Required for GUI/tools and interoperability:

* `libX11`
* `libXi`
* `libxkbcommon`
* `libGL`
* `glib`
* `libXtst`
* `libXxf86vm`

---

## What this is used for

This environment is intended for:

* Building Rust applications (`cargo build`
* Building Java applications (`javac`, Gradle, Maven projects)
* Running Java tests (`gradle test`, `mvn test`)
* Using Devin Desktop as a development environment with full toolchain support

---

## Installation

Run directly:

```bash id="r2m9k1"
nix run github:<YOUR_GITHUB_USERNAME>/devin-desktop-nix
```

Install into your profile:

```bash id="x7p0qd"
nix profile install github:<YOUR_GITHUB_USERNAME>/devin-desktop-nix
```

---

## Using as a flake dev shell

This flake can also be used as a development shell:

```nix id="kq9m2v"
{
  inputs.devin-desktop.url = "github:<YOUR_GITHUB_USERNAME>/devin-desktop-nix";

  outputs = { self, nixpkgs, devin-desktop, ... }:
  {
    devShells.x86_64-linux.default = devin-desktop.devShells.x86_64-linux.default;
  };
}
```

Then enter it with:

```bash id="p9w3md"
nix develop
```

---

## Updating

```bash id="q8c1rt"
nix flake update
```

---

## Building locally

```bash id="v3n8xa"
git clone https://github.com/<YOUR_GITHUB_USERNAME>/devin-desktop-nix.git
cd devin-desktop-nix
nix build
```

---

## Why this exists

Many development environments require manual setup of Rust and Java toolchains, along with native libraries for GUI and tooling support.

This flake provides a **reproducible dev environment** where:

* Rust projects can be built and tested immediately
* Java projects work out of the box
* No system-wide toolchain installation is required
* The environment is consistent across machines

---

## Requirements

* Nix with flakes enabled
* Linux (x86_64 recommended)

---

## Contributing

Issues and pull requests are welcome. If you encounter missing tooling or broken builds, please open an issue with details.

---

## License

MIT License applies to the Nix packaging only.

Devin Desktop and included toolchains are provided by their respective upstream projects.

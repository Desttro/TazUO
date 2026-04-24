<p align="center"><a href="https://discord.gg/QvqzkB95G4"><img src="https://discord.com/api/guilds/1344851225538986064/widget.png?style=banner3" alt="Discord Banner 3"/></a></p>

***


| Channel | Status                                                                                                                                                                     |
| --- |----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Release | [![Release](https://github.com/PlayTazUO/TazUO/actions/workflows/build-test.yml/badge.svg?branch=main)](https://github.com/PlayTazUO/TazUO/actions/workflows/build-test.yml) |
| Dev | [![Dev](https://github.com/PlayTazUO/TazUO/actions/workflows/build-test.yml/badge.svg?branch=dev)](https://github.com/PlayTazUO/TazUO/actions/workflows/build-test.yml)        |


# What is TazUO?
**TazUO** was originally a fork from ClassicUO with the mindset of adding features requested by users to improve QOL. **TazUO** has since moved away from ClassicUO, we will keep an eye on ClassicUO updates and incorporate changes or fixes as they have a wider user base that provides bug reports, but **TazUO** will no longer be merging all changes from ClassicUO.

# Play now
The easiest way to play with TazUO is via our [launcher](https://github.com/PlayTazUO/TUO-Launcher/releases/latest)!

# Build from source

For contributors, or players on niche / legacy shards where the launcher isn't
a fit, you can build the client directly.

## Prerequisites

- [.NET 10 SDK](https://dotnet.microsoft.com/download) — `dotnet --version` should report `10.x`.
- `git`.
- A local copy of your shard's UO data files (must contain at least `tiledata.mul`).

## Build

Works on Windows, macOS, and Linux:

```bash
git clone https://github.com/PlayTazUO/TazUO.git
cd TazUO
dotnet restore
dotnet build -c Release
```

Output binaries land under `bin/Release/net10.0/<rid>/`:

| OS | Binary |
| --- | --- |
| Windows x64 | `bin/Release/net10.0/win-x64/TazUO.exe` |
| macOS Apple Silicon | `bin/Release/net10.0/osx-arm64/TazUO` |
| macOS Intel | `bin/Release/net10.0/osx-x64/TazUO` |
| Linux x64 | `bin/Release/net10.0/linux-x64/TazUO` |

## Run

TazUO reads `settings.json` from the directory containing the binary. A minimal
config points at your UO files and a shard:

```jsonc
{
  "ultimaonlinedirectory": "/absolute/path/to/UO/files",
  "ip": "your.shard.example.com",
  "port": 2593,
  "clientversion": "7.0.95.0"
}
```

You can override any of these on the command line for one-off testing:

```bash
./TazUO -uopath /path/to/UO -ip your.shard.example.com -port 2593 -clientversion 7.0.95.0
```

The full CLI flag list (including `-settings`, `-debug`, `-highdpi`) is parsed
in `src/ClassicUO.Client/Main.cs`.

## Connecting to a legacy shard

Running against a **UO:LBR / SphereServer 99z-era** shard (pre-7.0 client with
active login-packet encryption) needs a few extra fields — the `encryption`
byte, `ignore_relay_ip`, and a correct `clientversion` string. See
[`docs/legacy-shard-setup.md`](docs/legacy-shard-setup.md) for a full walkthrough
(verified on macOS Apple Silicon against a live 3.0.6m / 99z8 shard).

## Tests

```bash
dotnet test tests/ClassicUO.UnitTests
```

# TazUO features
Check out our [website](https://tazuo.org) for details on all the changes TazUO has made for players!  

***Most*** features can be disabled if you don't want to use said feature.  

- [Launcher](https://tazuo.org/?q=launcher) - Managing profiles for multiple accounts/servers
- [Grid containers](https://tazuo.org/?q=grid+containers) - Easily find and move items with our fully customizable grid containers
- [Custom build-in scripting](https://tazuo.org/?q=legion+scripting) - Build in powerful scripting languages. **Python** and Legion Script.
- **Assistant features built-in** - Like Auto buy, sell, auto loot and more.
- [Journal](https://tazuo.org/?q=journal) - Vastly improved journal for readability and organization
- [Alternative paperdoll](https://tazuo.org/?q=alternate+paperdoll) - A new flavor of your paperdoll
- [Improved buff bar](https://tazuo.org/?q=buff+bars)
- [Client commands](https://tazuo.org/?q=commands) - Several commands have been added for various features
- [Controller support](https://tazuo.org/?q=controller+support) - That's right, play with your controller!
- [Cooldown bars](https://tazuo.org/?q=cooldown+bars) - Customizable cooldown bars
- [Grid Highlighting](https://tazuo.org/?q=grid+highlighting) - Grid highlighting of items that have specific properties, easier looting!
- [Tooltip overrides](https://tazuo.org/?q=tooltip+override) - Customize and override any text in tooltips!
- [Custom fonts](https://tazuo.org/?q=ttf+fonts) - BYOF, Bring your own fonts for better readability.

There are ***many*** more features to check out in our [website](https://tazuo.org) or in game, this list is just a sample!


# Screenshots
![Cooldown](https://user-images.githubusercontent.com/3859393/227056224-ef1c6958-fff5-4698-a21a-c63c5814877c.gif)  
![SlottedInv](https://user-images.githubusercontent.com/3859393/226514464-32919a68-ebad-4ec0-8bcf-8614a5055f7d.gif)  
![Grid Previe](https://user-images.githubusercontent.com/3859393/222873187-c88ad321-8b19-4cfd-9617-7e23b2443b6a.gif)  
![image](https://user-images.githubusercontent.com/3859393/222975241-319e5fa6-2c1e-441d-97e6-b04a5e1f6f3b.png)  
![Journal](https://user-images.githubusercontent.com/3859393/222942915-e31d26aa-e9a7-41df-9c99-570bcc00d1fb.gif)  
![image](https://user-images.githubusercontent.com/3859393/225168130-5ce83950-853d-43ce-9583-65ec4b0ae9d6.png)  
![image](https://user-images.githubusercontent.com/3859393/225307385-c8e8014f-9b84-4fe4-a2cd-f33fbeee9563.png)  
![image](https://user-images.githubusercontent.com/3859393/226114408-28c6556d-6ba8-43c7-bf1a-079342aaeacd.png)  
![image](https://user-images.githubusercontent.com/3859393/226114417-e68b1653-f719-49b3-b799-0beb07e0a211.png)  

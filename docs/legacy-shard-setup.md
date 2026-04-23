# Connecting TazUO to a Legacy UO Shard (macOS)

This guide walks through configuring TazUO to connect to older custom UO
shards — e.g. **Lord Blackthorn's Revenge (UO:LBR)** era servers running
**SphereServer 99z** with active login encryption — on macOS (Apple Silicon
and Intel). It was written and verified against a live 3.0.6m / SphereServer
99z8 shard.

If you are joining a modern (UO:HS / 7.x) shard or the official launcher,
this guide is not for you — use the launcher from <https://tazuo.org/launcher>.

---

## Prerequisites

- macOS with the .NET 10 SDK installed (`dotnet --version` reports `10.x`).
- A local copy of the shard's classic UO data files (e.g. UO:LBR installation),
  containing at minimum `tiledata.mul`. The folder also normally contains
  `anim.mul`, `art.mul`, `map0.mul`, `client.exe`, etc.
- The shard's **host**, **port**, and required **client version** string
  (ask the shard operator; e.g. `3.0.6m`, `3.0.6e`, `2.0.3`, etc.).

## 1. Build the client

From the repo root:

```bash
dotnet restore
dotnet build -c Release
```

The macOS build output lands under:

```
bin/Release/net10.0/osx-arm64/TazUO            # Apple Silicon
bin/Release/net10.0/osx-x64/TazUO              # Intel (if built for osx-x64)
```

Verify the executable is there:

```bash
file bin/Release/net10.0/osx-arm64/TazUO
# -> Mach-O 64-bit executable arm64
```

The build target automatically copies the native runtime libraries
(SDL3, FNA3D, FAudio, MoltenVK, Vulkan loader, theorafile) into the
`osx-arm/` and `osx/` subdirectories of the output folder — no manual
dylib wrangling required.

## 2. Create `settings.json` next to the binary

TazUO resolves `settings.json` from the executable's directory
(`src/ClassicUO.Client/Configuration/Settings.cs:104-117`). Drop this
file in the same directory as the `TazUO` binary:

```jsonc
{
  "username": "",
  "password": "",
  "ip": "your.shard.example.com",
  "port": 2593,
  "ultimaonlinedirectory": "/absolute/path/to/your/UO/files",
  "clientversion": "3.0.6m",
  "lang": "ENU",
  "encryption": 0,
  "autologin": false,
  "saveaccount": true,
  "ignore_relay_ip": true,
  "lastservernum": 1,
  "last_server_name": "your.shard.example.com"
}
```

A ready-made template lives at
[`docs/examples/settings.legacy-lbr-sphere.json`](examples/settings.legacy-lbr-sphere.json).

### Field-by-field rationale

| Key | Why it matters |
|---|---|
| `ultimaonlinedirectory` | Absolute path to your UO files. Validated on startup by checking for `tiledata.mul`. Bad path → "could not find the UO directory" error (`src/ClassicUO.Client/Main.cs:171`). |
| `clientversion` | Free-form `MAJOR.MINOR.BUILD[letter]` string. Drives **both** protocol feature flags (`src/ClassicUO.Client/Client.cs:111-189`) and login encryption derivation. Must match what the shard expects; mismatches produce silent login failures or garbled packets. |
| `ip` / `port` | Shard address. `port` defaults to `2593`. |
| `encryption` | `0` means auto-detect from `clientversion`. Leave it 0 — see the encryption section below. |
| `ignore_relay_ip` | See the **Relay-IP** section below. `true` is the right default for SphereServer and most private shards. |
| `autologin` / `saveaccount` | Self-explanatory. Leave `username`/`password` blank and fill them in the login screen if you don't want credentials on disk. |
| `lastservernum` / `last_server_name` | Pre-selects the shard in the server list, making login one click instead of two. |
| `lang` | Three-letter language code used for cliloc lookups. `ENU` is the default English dictionary. |

### Encryption — let TazUO pick it

`EncryptionHelper.CalculateEncryption` in
`src/ClassicUO.Client/Network/Encryption/Encryption.cs:39-70` maps client
versions to encryption schemes:

| Client version | Scheme |
|---|---|
| `< 1.25.35` | `OLD_BFISH` |
| `= 1.25.36` | `BLOWFISH__1_25_36` |
| `<= 2.0.0` | `BLOWFISH` |
| `<= 2.0.3` | `BLOWFISH__2_0_3` |
| `> 2.0.3`  | `TWOFISH_MD5` |

A `3.0.6m` client lands in `TWOFISH_MD5` — which is what SphereServer 99z
expects for a 3.0.x shard. **Do not hardcode a non-zero `encryption`
value** unless you are explicitly forcing a mismatched scheme for a
non-standard server: the keys are derived from the version bytes and will
be out of sync with the shard.

### `ignore_relay_ip` — why it is `true` here

Classic UO login is a two-step dance: the *login server* authenticates,
then a **relay packet** redirects the client to the *game server* IP.
SphereServer (and many private shards) misconfigure this packet and
publish an internal IP like `127.0.0.1` or `192.168.x.x`, which obviously
doesn't route from the outside.

Setting `ignore_relay_ip: true` tells TazUO to ignore the relay IP and
reuse the `ip`/`port` from `settings.json` for the game-server connection
(`Settings.cs:53-56`). This is the common fix for "select-shard-then-disconnect"
on private shards.

Flip it to `false` only if login fails *with* it enabled (i.e. the shard
does publish a correct relay IP).

### Client-version gotchas

- `src/ClassicUO.Utility/ClientVersion.cs` declares constants for common
  versions (`CV_306E`, `CV_308`, `CV_405A`, etc.). **Not every release is
  enumerated.** `3.0.6m` is not in the enum, but the parser accepts any
  `MAJOR.MINOR.BUILD[letter]` string, so it works — only the constants
  used in threshold comparisons matter.
- The `CF_LBR` client-feature flag activates on versions `>= CV_308`
  (`Client.cs:163`). Against a genuine 3.0.6m shard this is *desirable*:
  the server will not send the 3.0.8+ LBR feature set, so the client
  should not advertise support for it.
- If connection succeeds but the server kicks you for an unexpected
  version byte, ask the shard operator which exact string they expect
  and try e.g. `3.0.6e` (matches `CV_306E`, same encryption class) or
  the version string reported by the shard's `client.exe`.

## 3. Launch

```bash
cd bin/Release/net10.0/osx-arm64
./TazUO
```

Or, for one-off testing without editing `settings.json`:

```bash
dotnet bin/Release/net10.0/osx-arm64/TazUO.dll \
  -uopath /absolute/path/to/UO \
  -clientversion 3.0.6m \
  -ip your.shard.example.com \
  -port 2593
```

All CLI flags are parsed in `src/ClassicUO.Client/Main.cs:265-399`.
Notable ones for debugging:

- `-settings <path>` — use a different `settings.json`.
- `-debug` — enable verbose tracing to `Logs/` next to the binary.
- `-highdpi` — opt into HiDPI mode on Retina displays.

## Verification checklist

- [ ] `TazUO` window opens without an error dialog.
- [ ] Log output (stdout) shows the UO files loading from your
      `ultimaonlinedirectory` — lines like
      `[UOFile..ctor] Loading file: /.../tiledata.mul`.
- [ ] The login screen shows your shard in the server list.
- [ ] Clicking the shard advances to the character-select screen
      (this proves the login-handshake encryption negotiated correctly).

## Troubleshooting

| Symptom | Likely cause / fix |
|---|---|
| `"could not find the UO directory"` | `ultimaonlinedirectory` missing or does not contain `tiledata.mul`. Use an absolute path. |
| `"Your UO client version is invalid"` | `clientversion` string malformed (needs `MAJOR.MINOR.BUILD[letter]`). Or, if blank, TazUO tried to read `client.exe` and failed — set it explicitly. |
| Login hangs / disconnects after selecting shard | Relay-IP issue. Toggle `ignore_relay_ip`. |
| Connects but server immediately boots you | Wrong `clientversion` for the shard's expected version, or encryption mismatch. Confirm version string with shard operator; leave `encryption: 0`. |
| `Failed to play music ... MP3Sharp ...` warning | Cosmetic. Login music only — gameplay is unaffected. |

## Platform support matrix (verified)

| Platform | Status |
|---|---|
| macOS 14+ Apple Silicon (arm64), Metal via MoltenVK | Verified against SphereServer 99z8 @ 3.0.6m |
| macOS Intel (x64) | Expected to work (same build pipeline, `osx` runtime folder) — not verified for this guide |
| Windows / Linux | Use the generic instructions in `README.md` |

---

*If you got a legacy shard running with TazUO and hit issues not covered
here, please open an issue or PR extending this guide.*

*This project has been created as part of the 42 curriculum by mobouifr.*

<div align="center">

# get_next_line

One function, one call: stream a file descriptor line by line with persistent state.

![C](https://img.shields.io/badge/language-C-00599C?style=for-the-badge&logo=c&logoColor=white)
![Graphics](https://img.shields.io/badge/graphics-none-6c757d?style=for-the-badge)
![42 Norm](https://img.shields.io/badge/42-Norminette-1f6feb?style=for-the-badge)

</div>

## What Is This?

`get_next_line` is a C function that reads from a file descriptor and returns exactly one line per call, including the trailing newline when present. You call it repeatedly, and it continues where it left off until EOF or error.

The core challenge is state management in low-level I/O: `read(2)` gives raw chunks, not lines. This project builds a small line-oriented reader with dynamic concatenation, newline detection, and leftover buffering across calls.

It is technically interesting because it forces careful handling of static storage duration, partial reads, allocation boundaries, and edge cases controlled by `BUFFER_SIZE`.

> Small API, strict constraints, real systems-programming habits.

## How It Works

Mandatory flow:

```text
get_next_line(fd)
   |
   +--> line_catcher(fd, static_buffer)
   |       read chunks of BUFFER_SIZE
   |       append with ft_strjoin
   |       stop on '\n' or EOF
   |
   +--> get_new_line(accumulated_buffer)
   |       extract current line to return
   |
   +--> reset_buffer(accumulated_buffer)
	   keep remaining bytes after '\n'
	   as next-call state
```

Bonus flow is identical, except state is stored per descriptor in `static char *buffer[1024]`.

## Features

| Feature | Status | Notes |
|---|---|---|
| Read one line per call | ✓ | `get_next_line` returns one line including `\n` when present |
| Persistent read state | ✓ | Mandatory uses one static pointer (`get_next_line.c`) |
| Multi-FD support | ✓ | Bonus uses `static char *buffer[1024]` indexed by `fd` |
| Configurable chunk size | ✓ | `BUFFER_SIZE` can be provided via compiler `-D`; default is `4` in headers |
| Custom string helpers | ✓ | `ft_strlen`, `ft_strdup`, `ft_strjoin`, `ft_strchr` in utils files |
| Build automation | ✓ | Makefile provides `all`, `bonus`, `clean`, `fclean`, `re` |
| Binary-file handling | partial | Subject marks binary behavior undefined; implementation does not add a dedicated binary guard |
| FD bounds guard in bonus | partial | Bonus code does not reject `fd >= 1024` before indexing buffer array |

<details>
<summary>Verified Technical Notes</summary>

- Default `BUFFER_SIZE` is defined as `4` in both headers when `-D BUFFER_SIZE=...` is not passed.
- Mandatory validates only `fd < 0` and `BUFFER_SIZE < 1`.
- Bonus validates only `fd < 0` and `BUFFER_SIZE < 1` while storing state in a fixed `1024` table.

</details>

## Project Structure

```text
.
|-- Makefile                          <- Build rules for mandatory/bonus static libraries
|-- get_next_line.h                   <- Mandatory declarations, includes, BUFFER_SIZE default
|-- get_next_line.c                   <- Mandatory line assembly, extraction, and state reset
|-- get_next_line_utils.c             <- Mandatory helper string functions
|-- get_next_line_bonus.h             <- Bonus declarations, includes, BUFFER_SIZE default
|-- get_next_line_bonus.c             <- Bonus get_next_line with per-fd static state
|-- get_next_line_utils_bonus.c       <- Bonus helper string functions
`-- README.md                         <- Project documentation
```

## Getting Started

> The `Makefile` in this repository is provided only for convenience. The subject can be validated by compiling directly with `cc` and the required flags.

### Build

```bash
make
```

Produces:

- `get_next_line.a`

### Build Bonus

```bash
make bonus
```

Produces:

- `get_next_line_bonus.a`

### Manual Compilation (verified)

```bash
cc -Wall -Wextra -Werror -D BUFFER_SIZE=42 -c get_next_line.c get_next_line_utils.c
cc -Wall -Wextra -Werror -D BUFFER_SIZE=42 -c get_next_line_bonus.c get_next_line_utils_bonus.c
```

### Makefile Rules

<div align="center">

| Rule | Effect |
|---|---|
| `make` / `make all` | Build mandatory static library |
| `make bonus` | Build bonus static library |
| `make clean` | Remove object files |
| `make fclean` | Remove objects and generated libraries |
| `make re` | Full rebuild of mandatory target |

</div>

<details>
<summary>Build Flags</summary>

```text
Compiler: cc
Flags:    -Wall -Wextra -Werror
Archive:  ar rcs
```

</details>

## Resources

- 42 subject: Get Next Line (v14.2)
- Linux man pages: `read(2)`, `open(2)`, `close(2)`
- Linux man pages: `malloc(3)`, `free(3)`
- C static storage duration references (for function-local static state)
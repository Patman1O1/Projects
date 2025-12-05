import os
import sys
import argparse
import platform
import subprocess

def list_path():
    for entry in os.environ["PATH"].split(os.pathsep):
        print(entry)

def normalize(p):
    return os.path.abspath(os.path.expanduser(p))

# --------------------
# Windows Implementation
# --------------------

def windows_get_path(scope="user"):
    cmd = [
        "powershell",
        "-Command",
        f'[Environment]::GetEnvironmentVariable("Path", "{scope}")'
    ]
    return subprocess.check_output(cmd, text=True).strip()

def windows_set_path(new_value, scope="user"):
    cmd = [
        "powershell",
        "-Command",
        f'[Environment]::SetEnvironmentVariable("Path", "{new_value}", "{scope}")'
    ]
    subprocess.check_call(cmd)

def windows_add(path):
    path = normalize(path)
    current = windows_get_path()
    parts = current.split(";")
    if path in parts:
        print("Path already present.")
        return
    parts.append(path)
    windows_set_path(";".join(parts))
    print(f"Added: {path}")

def windows_remove(path):
    path = normalize(path)
    current = windows_get_path()
    parts = current.split(";")
    if path not in parts:
        print("Not in PATH.")
        return
    parts = [p for p in parts if p != path]
    windows_set_path(";".join(parts))
    print(f"Removed: {path}")

# --------------------
# Linux/macOS Implementation
# --------------------

def posix_add(path):
    path = normalize(path)
    rc_file = get_shell_rc()

    with open(rc_file, "a") as f:
        f.write(f'\n# Added by pathctl\nexport PATH="$PATH:{path}"\n')

    print(f"Added to PATH in {rc_file}: {path}")
    print("Restart your terminal to apply.")

def posix_remove(path):
    path = normalize(path)
    rc_file = get_shell_rc()

    with open(rc_file, "r") as f:
        lines = f.readlines()
    with open(rc_file, "w") as f:
        for line in lines:
            if path not in line:
                f.write(line)

    print(f"Removed from PATH in {rc_file}: {path}")
    print("Restart your terminal to apply.")

def get_shell_rc():
    shell = os.path.basename(os.environ.get("SHELL", "bash"))
    home = os.path.expanduser("~")

    if shell == "zsh":
        return f"{home}/.zshrc"
    else:
        return f"{home}/.bashrc"

# --------------------
# Main CLI
# --------------------

def main():
    parser = argparse.ArgumentParser(description="PATH manager tool")
    parser.add_argument("--list", action="store_true", help="List PATH")
    parser.add_argument("--add", help="Add path to PATH")
    parser.add_argument("--remove", help="Remove path from PATH")

    args = parser.parse_args()
    system = platform.system()

    if args.list:
        list_path()
        return

    if args.add:
        if system == "Windows":
            windows_add(args.add)
        else:
            posix_add(args.add)
        return

    if args.remove:
        if system == "Windows":
            windows_remove(args.remove)
        else:
            posix_remove(args.remove)
        return

    parser.print_help()


if __name__ == "__main__":
    main()

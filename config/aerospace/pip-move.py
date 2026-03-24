#!/usr/bin/env python3

import asyncio
import json
import re


async def run_aerospace_command(args):
    """Run an aerospace command asynchronously and return the output."""
    process = await asyncio.create_subprocess_exec(
        "aerospace",
        *args,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    stdout, stderr = await process.communicate()

    if process.returncode != 0:
        raise RuntimeError(f"Command failed: {stderr.decode()}")

    return stdout.decode().strip()


async def run_aerospace_with_jq(args):
    """Run an aerospace command piped through jq and return parsed JSON."""
    import shlex

    # Build the full command with pipe to jq, properly escaping arguments
    aerospace_args = " ".join(shlex.quote(arg) for arg in args)
    full_command = f"aerospace {aerospace_args} | jq -s ."

    process = await asyncio.create_subprocess_shell(
        full_command,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    stdout, stderr = await process.communicate()

    if process.returncode != 0:
        raise RuntimeError(f"Command failed: {stderr.decode()}")

    return json.loads(stdout.decode())


async def move_window(window_id, workspace):
    """Move a window to a workspace asynchronously."""
    process = await asyncio.create_subprocess_exec(
        "aerospace",
        "move-node-to-workspace",
        "--window-id",
        window_id,
        workspace,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    await process.communicate()

    if process.returncode != 0:
        print(f"Warning: Failed to move window {window_id}")


async def main():
    # Get current workspace and all windows in parallel
    current_workspace_task = run_aerospace_command(["list-workspaces", "--focused"])
    visible_workspaces_task = run_aerospace_command(
        ["list-workspaces", "--monitor", "all", "--visible"]
    )
    windows_workspaces_monitors_task = run_aerospace_with_jq(
        [
            "list-windows",
            "--all",
            "--format",
            '{"workspace": %{workspace}, "monitor": %{monitor-id}, "window_id": %{window-id}, "visible": %{workspace-is-visible}}',
        ]
    )
    all_windows_task = run_aerospace_command(["list-windows", "--all"])

    # Wait for all initial queries to complete
    (
        current_workspace,
        visible_workspaces_str,
        windows_workspaces_monitors,
        all_windows,
    ) = await asyncio.gather(
        current_workspace_task,
        visible_workspaces_task,
        windows_workspaces_monitors_task,
        all_windows_task,
    )

    visible_workspaces = visible_workspaces_str.split("\n")

    # Create a lookup for window visibility
    window_visibility = {
        str(window["window_id"]): window["visible"]
        for window in windows_workspaces_monitors
    }

    pip_windows = []
    meet_windows = []

    # Parse window list
    for line in all_windows.split("\n"):
        if not line.strip():
            continue

        # Extract window ID (first field)
        window_id = line.split()[0]

        # Check for Picture in Picture windows
        if re.search(r"(Picture-in-Picture|Picture in Picture)", line):
            pip_windows.append(window_id)

        # Check for Google Meet windows
        if "Google Meet" in line:
            meet_windows.append(window_id)

    # Combine: PiP windows + highest Google Meet window (if multiple exist)
    windows_to_move = pip_windows.copy()

    if len(meet_windows) > 1:
        # Sort numerically descending and get the highest
        meet_windows_sorted = sorted(meet_windows, key=lambda x: int(x), reverse=True)
        highest_meet = meet_windows_sorted[0]
        windows_to_move.append(highest_meet)

    # Filter out visible windows - only move windows that are not visible
    windows_to_move = [
        window_id
        for window_id in windows_to_move
        if window_id and not window_visibility.get(window_id, False)
    ]

    # Move all collected windows in parallel
    move_tasks = [
        move_window(window_id, current_workspace) for window_id in windows_to_move
    ]

    if move_tasks:
        await asyncio.gather(*move_tasks)


if __name__ == "__main__":
    asyncio.run(main())

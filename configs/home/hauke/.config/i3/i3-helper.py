#!/bin/python

import subprocess
import argparse
import sys



monitors = {
	"left": "DisplayPort-1",
	"right": "DVI-D-0"
}



# Returns the index of the current workspace
def getCurrentWorkspace():
	out = subprocess.check_output("i3-msg -t get_workspaces | jq '.[] | select(.focused==true).num'", shell=True)
	return int(out)

# Determines the number of the workspace index. If no name exists (e.g. the workspace doesn't exist yet), the number is returned.
def getWorkspaceName(num):
	name = subprocess.check_output("i3-msg -t get_workspaces | jq '.[] | select(.num==" + str(num) + ").name'", shell=True).decode("UTF-8").strip('\n"')
	
	if name == "":
		print("Workspace not found. Take parameter %d" % num)
		return str(num)
	return str(name)

# Executes the given command in an i3-msg call.
def execute(command):
	subprocess.check_output("i3-msg '" + command + "'", shell=True)

# Returns the command to move the current selected monitor to the workspace with the given name.
def moveToWorkspace(name):
	return "workspace " + name + ";"

# Returns the command to focus the monitor "left" or "right". See the monitor dict above.
def focusMonitor(id):
	return "focus output " + monitors[id] + ";"

# Moves the whole setup to the "next" or "prev" workspace. All monitors will get new workspaces.
def moveToWorkspaceDirection(direction):
	# two screens -> skip one workspace by using an offset of 2 (or -2)
	offset = 2 if direction == "next" else -2
	
	currentWorkspace = getCurrentWorkspace()
	# left monitor = main monitor = contains odd numbered workspaces
	currentMonitor = "right" if currentWorkspace % 2 == 0 else "left"
	
	currentWorkspaceOnLeftMonitor = currentWorkspace - 1 if currentWorkspace % 2 == 0 else currentWorkspace
	currentWorkspaceOnRightMonitor = currentWorkspaceOnLeftMonitor + 1
	
	nextWorkspaceNameLeft = getWorkspaceName(currentWorkspaceOnLeftMonitor + offset)
	nextWorkspaceNameRight = getWorkspaceName(currentWorkspaceOnRightMonitor + offset)

	cmd = focusMonitor("left")
	cmd += moveToWorkspace(nextWorkspaceNameLeft)
	
	cmd += focusMonitor("right")
	cmd += moveToWorkspace(nextWorkspaceNameRight)

	cmd += focusMonitor(currentMonitor)

	execute(cmd)

def moveToNextWorkspace():
	moveToWorkspaceDirection("next")

def moveToPrevWorkspace():
	moveToWorkspaceDirection("prev")



# Setup argument parsing
parser = argparse.ArgumentParser(description = "A small utility to help i3 with my multi-monitor setup")
parser.add_argument("-w", "--workspace", metavar = "<workspace>", nargs = 1, type = str, help = "Move to the given workspace. Supported paratemers: next, prev")

if len(sys.argv)==1:
    parser.print_help(sys.stderr)
    sys.exit(1)

args = parser.parse_args()

if args.workspace != None:
	if args.workspace[0] == "next":
		moveToNextWorkspace()
	elif args.workspace[0] == "prev":
		moveToPrevWorkspace()
	else:
		print("Unknown workspace '" + args.workspace[0] + "'")

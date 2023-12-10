#!/bin/zsh

# Function to display script usage
usage() {
	echo "Usage: $0 -d <day_number> -r <repetitions>"
	echo "Options:"
	echo "  -d, --day        Specify the day number (e.g., 08)"
	echo "  -r, --repetitions Specify the number of repetitions (e.g., 1000)"
	echo "  -h, --help       Display this help message"
	exit 1
}

# Default values
day=""
repetitions=""

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
	case $1 in
	-d | --day)
		day="$2"
		shift
		;;
	-r | --repetitions)
		repetitions="$2"
		shift
		;;
	-h | --help)
		usage
		;;
	*)
		echo "Unknown parameter: $1"
		usage
		;;
	esac
	shift
done

# Validate required arguments
if [[ -z "$day" || -z "$repetitions" ]]; then
	echo "Both day and repetitions must be specified."
	usage
fi

# Check if the file exists
executable="./zig-out/bin/aoc-day${day}"
if [[ ! -f "$executable" ]]; then
	echo "Error: File $executable does not exist."
	exit 1
fi

# Execute the command
repeat "$repetitions" { "$executable" } 2>&1 >/dev/null | awk '{sum+=$1} END {print "AVG=",sum/NR}'

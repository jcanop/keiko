#!/bin/bash
# ============================================================
# A small script to create and manage simple docker containers
# ============================================================
VERSION="1.0.0"

# --- Print Help ---
print_help() {
	echo "Use: keiko [command]"
	echo "command:"
	echo "  ls        List available images"
	echo "  ps        List running containers"
	echo "  run       Creates and runs a container"
	echo "  stop      Stops all running containers"
	echo "  clean     Stop and remove all containers, and remove all images."
	echo "  version   Prints the script's version"
}

# --- Display available images ---
execute_ls() {
	script_dir="$(dirname "$(readlink -f "$0")")"
	echo "IMAGE        DESCRIPTION"
	for file in $(ls $script_dir/configs/*.cfg); do
		source $file
		filename=$(basename $file)
		filename=${filename: 0:-4}
		printf "%-12s %s\n" $filename "$description"
	done
}

# --- Display all running containers ---
execute_ps() {
	exec docker ps --format "{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
}

# --- Execute a Container ---
execute_container() {
	if [ $# -lt 2 ]; then
		echo "Use: keiko run [image] [name] (args)"
		echo "args:"
		echo "  -p, --publish    Binding Port"
		echo "  -v, --volume     Shared Directory"
		exit 1
	fi

	script_dir="$(dirname "$(readlink -f "$0")")"
	file="$script_dir/configs/$1.cfg"
	name=$2

	if [ ! -f $file ]; then
		echo "Unsupported '$1': "
		echo "  Image file not found: $file"
		exit 1
	fi
	source $file
	b_port=$port
	b_dir=$PWD

	shift # skip image
	shift # skip name
	while [[ $# -gt 0 ]]; do
		if [ $# -lt 2 ] || [ ${2: 0:1} == "-" ]; then
			echo "Missing value: $1"
			exit 1
		fi
		case $1 in
			-p|--publish) b_port=$2;;
			-v|--volume)  b_dir=$2;;
		esac
		shift # skip key
		shift # skip value
	done

	echo "Executing container:"
	echo "  Image:   $image"
	echo "  Name:    $name"
	echo "  Volume:  $b_dir:$dir"
	echo "  Port:    $b_port:$port"
	echo "  Args:    $args"

	exec docker run --rm --name $name -v $b_dir:$dir -p 0.0.0.0:$b_port:$port -d $image $args
}

# --- Stops all running containers ---
execute_stop() {
	for cid in $(docker ps -q); do
		docker stop $cid
	done
}

# --- Stop and remove all containers, and remove all images  ---
execute_clear() {
	ids=$(docker ps -aq)
	if [[ ! -z "$ids" ]]; then
		docker stop $ids
		docker rm   $ids
	fi
	ids=$(docker volume ls -q)
	if [[ ! -z "$ids" ]]; then
		docker volume rm $ids
	fi
	ids=$(docker images -q)
	if [[ ! -z "$ids" ]]; then
		docker rmi -f
	fi
	docker image prune -f
	docker system prune -f
}

# --- Prints the script's version ---
execute_version() {
	echo "Keiko - $VERSION"
}

# --- Valdiate user input ---
if [ "$#" -lt 1 ]; then
	print_help
	exit 1
fi

# --- Command matcher ----
case $1 in
	ls)      execute_ls;;
	ps)      execute_ps;;
	run)	 execute_container "${@:2}";;
	stop)    execute_stop;;
	clear)   execute_clear;;
	version) execute_version;;
	*)       print_help;;
esac

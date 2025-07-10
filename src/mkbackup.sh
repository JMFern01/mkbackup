#!/usr/bin/env sh

#==========================================================| HEADER
#
#	Creator: Joao Mauricio
#	github: github.com/jean0t
#
#	Name:
#		Backup Maker
#
#	Description:
#		This software is responsible to take
#		directories and files as an input and
#		create a backup of them
#
#==========================================================| CHANGELOG
#
#	- 1.0:
#		Supports lots of files and directories,
#		creating a backup in the $HOME directory
#		that can be sent anywhere
#
#	- 1.1:
#		Modify the name of the backup file instead
#		of the standard one "backup.tar"
#
#	- 1.2:
#		Don't preserve permissions, which means
#		when extracted it will be accessible
#		right away
#
#		The compression isn't done separately
#		but by the tar itself
#		(less command lines = more readable)
#
#		Corrected infinite loop when used
#		other options
#
#    	- 1.3:
#       	Standardized output directory.
#
#   	- 1.4:
#       	POSIX compliance.
#
#	- 1.5:
#		Removed the option to define the name
#		of the backup file (backup-<date>.tar.gz).
#
#		Started the creation of the incremental
#		backup by using rsync.
#==========================================================#





#==========================================================| GLOBAL VARIABLES

VERSION='1.5'
OUT_DIR="$HOME/.backup_files" 	# the backup will be sent to the home of the user
NAME="backup-$(date '+%Y-%m-%d').tar.gz"
DELETE=false

#==========================================================| TESTS

directory_exists() {
	[ ! -d "$OUT_DIR" ] && mkdir -p "$OUT_DIR"
}



#==========================================================| FUNCTIONS

help() {
	cat <<'EOF'
Usage: ./mkbackup [OPTIONS] FILES

	Check the help menu with -h or send the files that will
	be used for backup separated with space and inside (")

	example: ./mkbackup "~/test_file.txt" "./my_file.pdf"


	OPTIONS:
		-h | --help 		Shows the usage of the program
		-v | --version		Shows the current version
		-C | --complete 	Make complete backup of files [Default]
		-d | --delete		Incremental backup now mirrors the base files
		-I | --incremental	Make incremental backup
EOF
}

make_incremental_backup() {

}

make_complete_backup() {

	# Verify if all the arguments points to valid files, otherwise exits with an error code
	[ "$#" -eq "0" ] && { printf 'You must pass a command or files to backup\n' ; exit 1 ; }

	directory_exists # Verify if the directory exists, if not, creates

	for i in "$@"; do
		if [ -e "$i" ]; then
			continue

		else
			printf '\e[31;1mYou select a file that do not exist.\e[0m\n'
			exit 1
		fi
	done

	printf "\e[39;1mCollecting the files\e[0m\n"
	tar --no-same-permissions -cpzf "${OUT_DIR:-.}/${NAME}" "$@" 1>/dev/null 2>&1
	printf "\e[36;1mProcess completed\e[0m\nYou can find your backup in:\n%s/%s\n" "${OUT_DIR:-.}" "${NAME}"

}

#==========================================================| START
while [ -n "$1" ]; do
	case "$1" in

		-h|--help)
			help
			shift
		;;

		-v|--version)
			printf "Version %s" "$VERSION"
			shift
		;;

		-d|--delete)
			DELETE=true
			shift
		;;

		-I|--incremental)
		
		;;

		*)
			make_complete_backup "$@"
			break
		;;

	esac
done

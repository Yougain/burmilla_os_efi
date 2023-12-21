#!/bin/bash


if ! PATH="./:$PATH" source bashlib_y;then
	echo -e "\033[41m\033[33mERROR    :\033[m \033[31m""bashlib_y not found.\033[m"
	exit 1
fi

if [ ! -e ./commit_editmsg ];then
	if [ ! -e .git/COMMIT_EDITMSG ];then
		die "'.git/COMMIT_EDITMSG' not found"
	fi
	ln .git/COMMIT_EDITMSG ./commit_editmsg
	git add commit_editmsg
fi

if [ -n "`git diff`" ];then
	git commit -a -m $verup
else
	warn "Not modified. Exitting."
	exit 1
fi


function v(){
	local grade="$1"
	local num=${vers[$((grade + 1))]}
	if [ -z "$num" ];then
		echo -n 0
	else
		echo -n $num
	fi
}


function commit(){
	git commit -a -m "`v` $@"
	local c=`git log -1|egrep '^commit '|awk '{print $2}'`
	git commit -a -m "`v` $@"
	
	git push
}


vers=($(cat commit_editmsg | awk '{print $1}' | tr '.' ' '))

cmd="$(__CMD_NAME__)"

if [ "$cmd" = "g" ];then
	cmd=`cat .git/.g`
fi


case "$cmd" in
	"g0")
		whiteBgRed_n "You really need major version up ? "
		yellowBgRed_n  "[y/n]:"
		echo -n " "
		if ! ask_yes_no; then
			info "Terminated by user."
			exit 1
		fi
		vers=($((`v 0` + 1)) 0)
		echo -n g2 > .git/.g
		;;
	"g1")
		vers=($((`v 0`)) $((`v 1` + 1)))
		echo -n g2 > .git/.g
		;;
	"g2")
		vers=($((`v 0`)) $((`v 1`)) $((`v 2` + 1)))
		echo -n g2 > .git/.g
		;;
	"g3")
		vers=($((`v 0`)) $((`v 1`)) $((`v 2`)) $((`v 3` + 1)))
		echo -n g3 > .git/.g
		;;
	*)
		die "command name '$(__CMD_NAME__)', unsupported."
		;;
esac
do_commit "$@"





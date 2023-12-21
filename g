#!/bin/bash


if ! PATH="./:$PATH" source bashlib_y;then
	echo -e "\033[41m\033[33mERROR    :\033[m \033[31m""bashlib_y not found.\033[m"
	exit 1
fi


if [ -z "`git diff`" ];then
	warn "Not modified. Exiting."
	exit 1
fi


if [ ! -e ./version ];then
	echo 0 > version
	git add version
fi

ver=`cat version|awk '{print $1}'`
if [[ "`cat version|awk '{print $1}'`" =~ ^[0-9]+(\.[0-9]+)*$ ]];then
	vers=(`echo $ver |tr '.' ' '`)
else
	die "The first word of file, 'version' cannot interpreted as version number ('$ver').
Note that you cannot use non-numeric characters in it."
fi


function v(){
	if [ -n "$1" ];then
		local grade="$1"
		local num=${vers[$grade]}
		if [ -z "$num" ];then
			echo -n 0
		else
			echo -n $num
		fi
	else
		local v
		local fst=1
		for v in "${vers[@]}";do
			if [ -n "$fst" ];then
				fst=
			else
				echo -n "."
			fi
			echo -n $v
		done
	fi
}



function commit(){
	echo -E "`v` $*" > version
	git commit -a -m "`v` $*"
	git push
	if [ -e .git/.ssh_clone ]; then
		local url=`git config --get remote.origin.url`
		url=https://github.com/${url#*:}
		url=${url%%.git}
		local tdir=`pwd`
		tdir=${tdir##*/}
		while read ln; do
			ssh_param $ln -x -q
			ssh_do git-force-clone $url $tdir
		done < .git/.ssh_clone
	fi
}


vers=($(cat version | awk '{print $1}' | tr '.' ' '))

cmd="$(__CMD_NAME__)"

if [ "$cmd" = "g" ];then
	if [ -e .git/.g ];then
		cmd=`cat .git/.g`
	else
		cmd=g2
	fi
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

commit "$@"





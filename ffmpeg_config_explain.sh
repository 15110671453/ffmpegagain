#!/bin/sh
LC_ALL=C
export LC_ALL

#这里是先执行一段测试程序 确保该脚本可以在当前主机上运行

try_exec(){
    echo "Trying shell $1"
    for skill in Ada Coffe Action Java; do
    echo "I am good at ${skill}Script"
	done
    type "$1" > /dev/null 2>&1 && exec "$@"
}

#stdin的文件描述符为0 stdout 的文件描述符为1 stderr的文件描述符为2

unset foo
#这里命令执行的错误信息 通过stderr 重定向到file
(: ${foo%%bar}) 2> /dev/null
E1="$?"

(: ${foo?}) 2> /dev/null
E2="$?"


#如果希望将 stdout 和 stderr 合并后重定向到 file
#下面就是将ls -l 命令执行的结果 和错误信息 一起输出到指定的文件中
#ls -l > ./loglog 2>&1

#test 检查$E1 变量字符串为 0
if test "$E1" != 0 || test "$E2" = 0; then
    echo "Broken shell detected.  Trying alternatives."
    export FF_CONF_EXEC
    if test "0$FF_CONF_EXEC" -lt 1; then
        FF_CONF_EXEC=1
        try_exec bash "$0" "$@"
    fi
    if test "0$FF_CONF_EXEC" -lt 2; then
        FF_CONF_EXEC=2
        try_exec ksh "$0" "$@"
    fi
    if test "0$FF_CONF_EXEC" -lt 3; then
        FF_CONF_EXEC=3
        try_exec /usr/xpg4/bin/sh "$0" "$@"
    fi
    echo "No compatible shell script interpreter found."
    echo "This configure script requires a POSIX-compatible shell"
    echo "such as bash or ksh."
    echo "THIS IS NOT A BUG IN FFMPEG, DO NOT REPORT IT AS SUCH."
    echo "Instead, install a working POSIX-compatible shell."
    echo "Disabling this configure test will create a broken FFmpeg."
    if test "$BASH_VERSION" = '2.04.0(1)-release'; then
        echo "This bash version ($BASH_VERSION) is broken on your platform."
        echo "Upgrade to a later version if available."
    fi
    exit 1
fi

#test 检查 如果文件存在且为目录则为真

test -d /usr/xpg4/bin && PATH=/usr/xpg4/bin:$PATH



#输出脚本参数个数 与所有脚本参数
echo "number:$#" >./loglog 2>&1
#这里为了不覆盖上面的log信息 这里 两个>>
echo "argume:$@" >>./loglog 2>&1
for each in $@;
do
echo "kong: ${each}" >>./loglog 2>&1
done
#输出当前系统的内核版本
uname -s >>./loglog 2>&1
uname -p >>./loglog 2>&1
uname -m >>./loglog 2>&1
#$0 获取到脚本自己的名字
echo $0
#获取当前脚本文件所在的目录
echo $(dirname "$0")
#注意生命变量 与 赋值运算符之间不得有空格  负责提示找不到命令
source_path=$(cd $(dirname "$0"); pwd)
echo ${source_path}

#命令替换 变量替换 完成括号里的命令行，然后将其结果替换出来，再重组命令行
#$( ) 与 ` ` (反引号) 都是来将括号中的 当作命令执行 将执行结果返回当作新的命令
$(uname -m) >>./loglog 2>&1

echo "who am i">>./loglog 2>&1
tolower(){
    echo "$@" | tr ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz
}
#这里调用了函数 tolower
target_os_default=$(tolower $(uname -s))
#echo ${target_os_default} >>./loglog 2>&1
echo "who am i 2">>./loglog 2>&1
host_os2=$target_os_default
echo ${host_os2} >>./loglog 2>&1
echo "who am i 3">>./loglog 2>&1

LIBPREF="lib"
LIBSUF=".a"
FULLNAME='$(NAME)$(BUILDSUF)'
LIBNAME='$(LIBPREF)$(FULLNAME)$(LIBSUF)'

echo ${NAME}
echo ${LIBPREF}
echo ${FULLNAME}
echo ${LIBNAME}


#生成一个文件夹
mkdir -p ffbuild
find_things_test()
{
	thing=$1
	pattern=$2
	
    files=$3
	out=$4
	#文件路径 通过上面获取的文件跟路径拼接指定的目录路径
    filepath=$source_path
	out2=${4:-$thing}

	echo ${thing}>>./loglog 2>&1
	echo ${pattern}>>./loglog 2>&1
	echo ${files}>>./loglog 2>&1
	echo ${out}>>./loglog 2>&1

	echo ${filepath}>>./loglog 2>&1
	echo ${out2}>>./loglog 2>&1
}
find_things_extern(){
    thing=$1
    pattern=$2
    #文件路径 通过上面获取的文件跟路径拼接指定的目录路径
    file=$source_path/$3
    out=${4:-$thing}

    #sed 文件内容查找替换
    #-n∶使用安静(silent)模式。sed是一个管道命令
    #s/^[^#]####/\1_$out/p
    # 搜索前面的模式字符串 并在这些字符串搜索结果 后 拼接_$out 最后将这些输出
    #这里是搜寻alldevice.c定义的所有extern变量名
    #extern AVOutputFormat ff_xv_muxer; 
    #c声明了一个AVOutputFormat结构体的外部变量 ff_xv_muxer
    sed  -n "s/^[^#]*extern.*$pattern *ff_\([^ ]*\)_$thing;/\1_$out/p" "$file"
}

OUTDEV_LIST=$(find_things_test muxer AVOutputFormat libavdevice/alldevices.c outdev)

#INDEV_LIST=$(find_things_extern demuxer AVInputFormat libavdevice/alldevices.c indev)
#echo ${INDEV_LIST}
#alsa_indev android_camera_indev avfoundation_indev 
#bktr_indev decklink_indev libndi_newtek_indev 
#dshow_indev fbdev_indev gdigrab_indev iec61883_indev 
#jack_indev kmsgrab_indev lavfi_indev openal_indev 
#oss_indev pulse_indev sndio_indev v4l2_indev 
#vfwcap_indev xcbgrab_indev libcdio_indev 
#libdc1394_indev


#shell 中enable 用于载入自定义的一些命令 或者 shell内建命令

enable env

for e in $env; do
   echo ${e}
done








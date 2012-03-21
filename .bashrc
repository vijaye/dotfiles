# .bashrc

# User specific aliases and functions

function ..() {
    cd ..
}

function cd..() {
    cd ..
}

function dirs() {
    find -name $*
}

function gdiff() {
    local cdata='<![CDATA['
    local payload="${cdata} $(git diff HEAD -U600000) ]]>"
    echo "<command>diff</command><content>${payload}</content>" > /dev/tcp/localhost/11256
}

function gdiffn() {
    local cdata='<![CDATA['
    local payload="${cdata} $(git diff HEAD~$1 -U600000) ]]>"
    echo "<command>diff</command><content>${payload}</content>" > /dev/tcp/localhost/11256
}

function gf() {
    git fetch; git svn rebase
}

function md() {
    mkdir "$*"
}

function n2() {
    local PORT=11256
    local filename="$*"
    [[ "${filename:0:1}" = "/" ]] || filename=$(pwd)/$filename

    # Try remote edit first, then use local vim
    (echo "$filename" > /dev/tcp/localhost/$PORT) 2>/dev/null
    if [ $? -ne 0 ]; then
      vim "$*"
    fi
}

function n() {
    local filename="$*"
    [[ "${filename:0:1}" = "/" ]] || filename=$(pwd)/$filename

    transmitCommand notepad $filename
    if [ $? -ne 0 ]; then
      vim "$*"
    fi
}

function pushd.() {
    pushd ..
}

function start() {
    local filename="$*"
    [[ "${filename:0:1}" = "/" ]] || filename=$(pwd)/$filename

    transmitCommand start $filename
}

function start.() {
    transmitCommand start. $(pwd)
}

function transmit() {
    local PORT=11256
    (echo $1 > /dev/tcp/localhost/$PORT) 2>/dev/null
}

function transmitCommand() {
    transmit "<command>$1</command><arg1>$2</arg1><arg2>$3</arg2><arg3>$4</arg3><arg4>$5</arg4><pwd>$(pwd)</pwd>"
}

function az() {
#    export SSH_AUTH_SOCK=`ls -lt /tmp/ssh-*/agent.* | grep \`whoami\` | cut -d' ' -f10 | head -n 1`
    export SSH_AUTH_SOCK=`ls -lt /tmp/ssh-*/agent.* | grep \`whoami\` | awk '{print $9}' | head -n 1`
    echo $SSH_AUTH_SOCK
    echo Ready.
}

function fix_ssh() {
    ln -sf $SSH_AUTH_SOCK /tmp/ssh-agent-$USER-screen
    export SSH_AUTH_SOCK="/tmp/ssh-agent-$USER-screen"
}

function fixauth() { 
    if [[ -n $TMUX ]]; then 
      #TMUX gotta love it 
      eval $(tmux showenv | grep -vE "^-" | awk -F = '{print "export "$1"=\""$2"\""}') 
    fi 
} 

# hook for preexec 
preexec () { fixauth; } 
preexec_invoke_exec () { 
    [ -n "$COMP_LINE" ] && return # do nothing if completing 
    local this_command=`history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g"`; 
    preexec "$this_command" 
} 
trap 'preexec_invoke_exec' DEBUG

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source Facebook definitions
if [ -f /home/engshare/admin/scripts/master.bashrc ]; then
	. /home/engshare/admin/scripts/master.bashrc
fi

#################### FUNCTIONS
function addPath() {
    export PATH="$PATH:$1"
}

# ----------------------Hive stuff-----------------------------------------
export HIVE_RLWRAP=true
source /mnt/vol/hive/dis/lib/utils/hive.include
hive_select_release silver
export HIVE_LIB=$HADOOP_HOME/lib
#-----------------------------------------------------------------------------

#################### EXPORTS
export GREP_OPTIONS='--color=auto'
# export LS_COLORS="no=00:\
    # # fi=00:\
    # # di=01;36:\
    # # ln=01;36:\
    # # pi=40;33:\
    # # so=01;35:\
    # # do=01;35:\
    # # bd=40;33;01:\
    # # cd=40;33;01:\
    # # or=40;31;01:\
    # # ex=01;32:\
    # # *.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:\
    # # *.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:\
    # # *.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:\
    # # *.ogg=01;35:*.mp3=01;35:*.wav=01;35:\
    # # "
export PS1="\e[1;36m[\u@\h \w] \e[1;33m\$(git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/{\1}/')\e[0m\n::\> "
export PAGER=cat
export LESS=-Ri

PATH=/usr/kerberos/bin:/opt/local/bin:/usr/local/bin:/bin:/usr/bin:/usr/facebook/scripts:/home/engshare/devtools/arcanist/bin:/home/engshare/svnroot/tfb/trunk/www/scripts/bin:/home/engshare/admin/scripts/git:/home/engshare/admin/scripts:/home/vijaye/www/scripts/bin:/home/vijaye/bin:~/local/bin/
export PATH

#################### ALIASES
alias checkpoint='git commit -am Checkpoint'
alias flib='cd ~/www/flib'
alias html='cd ~/www/html'
alias ut='~/www-git/scripts/bin/t'
alias www='~/www'
alias gs='git show --name-only'
alias tbgs='tbgs -ic'
#alias ls='ls -h $LS_COLOR'


#fix_ssh
#tmux -2 attach # || tmux -2 new


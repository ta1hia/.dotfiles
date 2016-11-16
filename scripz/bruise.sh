#!/usr/bin/env bash

# tabstop: 4

_VENV_BASE=$HOME/.venvs

## get the name of the branch, within the following revision control systems
function __fetch_repo_details() {

    if [ -d ".git" ]; then
        BRANCHNAME=`git rev-parse --abbrev-ref HEAD`

        # create an SSH wrapper if the tree we're in is "special"
        # then use that special wrapper
        BBNAME=`cat .git/config|grep bitbucket|cut -d "@" -f 2|cut -d "." -f 1`
        if [ $? -eq 0 ]; then
            if [ -f "~/bin/${BBNAME}bitbucketwrapper.sh" ]; then
                GIT_SSH="~/bin/${BBNAME}bitbucketwrapper.sh"
            fi
        fi
    elif [ -d ".hg" ]; then
        BRANCHNAME=`hg branch`
    elif [ -d ".bzr" ]; then
        BRANCHNAME=`cat .bzr/branch/branch.conf|awk -F/ '{print $(NF-1)}'`
    fi

    if [ -z $BRANCHNAME ]; then
        return
    else
        REPONAME=`basename "$PWD"`
    fi

    # figure out our virtual env type
    if [ -f requirements.txt ]; then
        VENV_TYPE="python"
        _VENV_ROOT=$_VENV_BASE/python
    fi

    if [ ! -d $_VENV_ROOT ]; then
        mkdir -p $_VENV_ROOT
    fi

    # pyenv users get an environment prefixed with python version
    if [ -f .python-version ]; then
        PYTHON_VERSION=`cat .python-version`
        VENV_NAME=$PYTHON_VERSION.$REPONAME.$BRANCHNAME
    else
        VENV_NAME=$REPONAME.$BRANCHNAME
    fi
    VENV_PATH=$_VENV_ROOT/$VENV_NAME

}

# create the pythonbrew venv combination
# if there's a requirements.txt we'll pip that puppy
function bruisemake() {

    if [ -z $VENV_TYPE ]; then
        echo "You are not in a repository root"
        return 1
    fi

    if [ $VENV_TYPE == "python" ]; then
        if [ ! -z $1 ]; then
            VENV_PATH=$_VENV_BASE/python/$1
        fi

        if [ ! -d $VENV_PATH ]; then
            virtualenv --no-site-packages $VENV_PATH
        fi
        source $VENV_PATH/bin/activate
        pip install -r requirements.txt
    fi

}

function __bruise() {

    if [ -z $PYTHON_VERSION ]; then
        VENV_PREFIX="${PYTHON_VERSION}"
    else
        VENV_PREFIX="${PYTHON_VERSION}-"
    fi

    if [ -d $VENV_PATH ]; then
        BRUISE_DIR=$VENV_PATH
    elif [ -d ${_VENV_ROOT}/${VENV_PREFIX}${REPONAME}.master ]; then
        BRUISE_DIR=${_VENV_ROOT}/${VENV_PREFIX}${REPONAME}.master
    elif [ -d $_VENV_ROOT/${VENV_PREFIX}${REPONAME} ]; then
        BRUISE_DIR=$_VENV_ROOT/${VENV_PREFIX}${REPONAME}
    elif [ -d $_VENV_ROOT/${REPONAME}.master ]; then
        BRUISE_DIR=$_VENV_ROOT/${REPONAME}.master
    elif [ -d $_VENV_ROOT/${REPONAME} ]; then
        BRUISE_DIR=$_VENV_ROOT/${REPONAME}
    fi

    if [ -z $BRUISE_DIR ]; then
        echo "No environment exists, try running bruisemake"
        return 1
    fi

    if [ $VENV_TYPE == "python" ]; then
        source $BRUISE_DIR/bin/activate
    fi

    # todo, compare modified times on requirements.txt and the $VENV_PATH
    if [ requirements.txt -nt $BRUISE_DIR ]; then
        pip install -r requirements.txt
    fi
}

function bruiselist() {
    for i in `ls $_VENV_BASE`; do
        ls $_VENV_BASE/$i
    done
}

function bruiseuse() {
    if [ -z $1 ]; then
      __bruise
    else
        source $_VENV_BASE/python/$1/bin/activate
    fi
}

function bruisedelete() {

    if [ -z $1 ]; then
        echo "bruisedelete bruise_to_delete"
        return 1
    fi

    for i in `ls $_VENV_BASE`; do
        envs=`ls $_VENV_BASE/$i`
        for e in $envs; do
            if [ "X$e" == "X$1" ]; then
                rm -rf $_VENV_BASE/$i/$e
            fi
        done
    done

}

cd() {
    builtin cd "$@"
    __fetch_repo_details
    if [ ! -z $VENV_TYPE ]; then
        __bruise
    fi
}

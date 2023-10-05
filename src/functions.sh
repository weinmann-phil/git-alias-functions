#!/bin/bash
#
# Description:
#   Functions to define `.bashrc` alias for custom git operations
# Author: mnv1c (philip.weinmann)
#
# Version: v0.0.1

# Imports
source ./helpers.sh

# git add a single reference and add commit message
function git_add_item_commit {
    validate_required_inputs $1 
    validate_required_inputs $2
    validate_git_commit_message $2
    git add $1 && git commit -m '$2'
}

function git_add_all_commit {
    validate_required_inputs $1
    validate_git_commit_message $1
    git add . && git commit -m "$1"
}

function git_create_feature_branch {
    git checkout main
    git pull
    BRANCH_NAME=$(validate_branch_name $1)
    git checkout -B $BRANCH_NAME
}

function git_push_to_origin {
    CURRENT_BRANCH=$(git branch)
    echo "Will push staged files to branch $CURRENT_BRANCH in origin."
    git push --upstream origin $CURRENT_BRANCH
}

function git_merge_branch_into_current {
    CURRENT_BRANCH=$(git branch)
    read -p "You're on branch $CURRENT_BRANCH. Continue? (Y/N): " confirm && \ 
        [[ $confirm == [yY] || $confirm == [yY][eE] || exit 1 ]]
    TARGET_BRANCH=$1
    TARGET_BRANCH=$(validate_branch_name $TARGET_BRANCH)
    echo "Merging $TARGET_BRANCH into $CURRENT_BRANCH..."
    git merge $TARGET_BRANCH
    echo "Deleting source branch $TARGET_BRANCH"
    git branch -d $TARGET_BRANCH
}

function git_initialize_repo {
    validate_git_repository $1
}
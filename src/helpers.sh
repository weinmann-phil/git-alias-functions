#!/bin/bash
#
# Helper functions 

function validate_required_inputs {
    if [ -z "$1" ]; then 
        write_error_message empty_string
        exit 1
    exit 0
    fi
}

function validate_git_commit_message {
    validate_required_inputs $1
    validate_base_structure $1
    TYPE=$(get_commit_type $1)
    LENGTH=${#1}
    if [ $LENGTH -gt 72 ]; then
        write_error_message invalid_git_commit_message_length
        exit 1
    fi
    echo "Creating commit with type: $TYPE"
}

function validate_base_structure {
    if [ ":" != *"$1"* ]; then
        write_error_message invalid_git_commit_message_form
        exit 1
    fi
    exit 0
}

function get_commit_type {
    INPUT=$1
    if [ ":" != *"$1"* ]; then
        write_error_message invalid_git_commit_message_form
        exit 1
    fi
    TYPE=$(echo $INPUT | sed 's/:.*//')
    if [ "(" == *"$TYPE"* ]; then
        TYPE=$(echo $TYPE | sed 's/(.*//')
    fi
    case $TYPE in
        feat | fix | docs | style | refactor | test | chore)
            exit 0
            ;;
        *)
            write_error_message invalid_git_commit_message_type;
            exit 1
            ;;
    esac
    return $TYPE
}

function validate_branch_name {
    INPUT=$1
    if [ -z "$1" ]; then
        read -p "Please provide a name for your branch: " branch_name
        INPUT=$branch_name
        return $INPUT
    fi
    INPUT=$(choose_branch_prefix $INPUT)
    return $INPUT
}

function validate_git_repository {
    INPUT=$1
    if [ -z "$1" ]; then
        read -p "Provide a name for the git repository: " repository_name
        INPUT=$repository_name
    fi
    case $INPUT in
        .)
            git init . --initial-branch=main
            ;;
        *)
            git init $INPUT --initial-branch=main
            ;;
    esac
}

function choose_branch_prefix {
    INPUT=$1
    if [ "/" == *"$1"* ]; then
        TYPE=$(echo $INPUT | cut -d '/' -f 1)
        case $TYPE in
            feat | fix | docs | style | refactor | test | chore)
                return $TYPE
                ;;
        esac
    else 
        case $INPUT in
            development | dev | staging | production | prod)
                return $TYPE
                ;;
            *)
                return $(define_branch_type)
        esac
    fi
}

function define_branch_type {
    print -p "Please describe the type of your branch: [default: feat]" branch_type
    case $branch_type in
        feat | fix | docs | refactor)
            return $branch_type;
            ;;
        *)
            return "feat";
            ;;
    esac
}

function write_error_message {
    case $1 in
        empty_string)
            echo "Error: A non-empty input parameter is required."
            ;;
        invalid_git_commit_message_form)
            echo "Error: Commit message with invalid form"
            echo "Please make sure to write messages of the form: "
            echo "        <commit-message-type>[(*)]: <commit-message>"
            ;;
        invalid_git_commit_message_type)
            echo "Error: An invalid commit message type is required. \n"
            echo "Valid types include:  `feat`, `fix`, `docs`, `style`, `refactor`, `test`, and `chore`"
            ;;
        invalid_git_commit_message_length)
            echo "Error: The commit message exceeds the allowed 72 characters"
    esac
    echo "exiting with status code: 1"
}

## Test examples
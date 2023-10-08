#!/bin/bash

# Initialize an associative array to store tasks and their dates
declare -A tasks

# File Remove and Create Another One #
create_file()
{
    # Print all tasks and their dates
    if test -e "todolist.txt"; then  
        rm todolist.txt 
    fi

    for task in "${!tasks[@]}"; do
        date="${tasks[$task]}"
        if [ -n "$date" ]; then
            echo "$task,$date" >> todolist.txt

        else
            echo "$task," >> todolist.txt
        fi
    done
}

# Print Tasks #
print_task()
{
    # ${#myarray[@]} --> array_size
    if [ "${#tasks[@]}" -eq 0 ]; then
        echo "No tasks yet!"
    else
        # Print all tasks and their dates
        for task in "${!tasks[@]}"; do
            date="${tasks[$task]}"
            if [ -n "$date" ]; then
                echo "Task: $task, Date: $date"
            else
                echo "Task: $task"
            fi
        done
    fi
}

# Check if file exists #
check_file_exists()
{
    if [ -e "todolist.txt" ]; then  
       while read -r line; do   

       # Process the line   
       task_name=$( echo "$line" | cut -d ',' -f1)
       task_date=$( echo "$line" | cut -d ',' -f2)
       tasks["$task_name"]=$task_date   

    done < todolist.txt

    else
        echo "No tasks yet!"
    fi  
}

# Insert Tasks Function #
insert_task()
{
    while true; do
        read -p "Enter a new task (or '0' to return to the main menu): " user_task

        # Check if the user wants to exit
        if [ "$user_task" == "0" ]; then
            break
        fi

        read -p "Enter a date (optional, format DD-MM-YYYY): " user_date

        # Add the task and date (if provided) to the associative array
        tasks["$user_task"]=$user_date
    done
    create_file
}

# Remove Task Function #
remove_task()
{ 
    
    # Initialize a flag to indicate whether the element was found
    found=false

    read -p "Enter task to be removed: " remove 

    # Iterate through the array and search for the element
    #here the for loop, if loops upon the array and you want the elemnt itself [its value], you won't use ! or #, if you want its index --> # , if map --> !
    for element in "${!tasks[@]}"; do
        if [ "$element" == "$remove" ]; then
            found=true
            break  # Exit the loop as soon as the element is found
        fi
    done

    # Check if the element was not found
    if [ "$found" == false ]; then
        echo "Element '$element_to_find' does not exist in the array."
    else
        unset tasks["$remove"]
        create_file
    fi
        
}

PS3="Select an option: "  # Prompt message for the select menu
options=("Load" "Add" "Remove" "Quit")
check_file_exists

user_didnt_quit=true 

#if you want to make conidtion as == , you should use either test or []
while [ $user_didnt_quit == true ]; do
# while true; do
    select choice in "${options[@]}"; do
        case "$choice" in
            "Load")
                print_task
                ;;
            "Add")
                insert_task
                ;;
            "Remove")
                remove_task
                ;;
            "Quit")
                echo "Goodbye!"
                user_didnt_quit=false
                break
                ;;
            *) 
                echo "Invalid option, please try again."
                ;;
        esac
    done
done




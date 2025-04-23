#!/bin/bash

# === Configuration ===
# !!! IMPORTANT: Replace placeholder START_COMMAND variables and potentially refine PATTERN variables !!!

# --- Process 1: toolbox.sh ---
PATTERN_TOOLBOX="toolbox"
START_COMMAND_TOOLBOX="./toolbox --tools_file "tools.yaml" &"

# --- Process 2: alloydb-auth-proxy ---
PATTERN_ALLOYDB="alloydb-auth-proxy"
START_COMMAND_ALLOYDB="./alloydb-auth-proxy "projects/my-first-project-424319/locations/us-central1/clusters/my-alloydb1/instances/my-alloydb1-primary" --public-ip &"

# --- General Settings ---
WAIT_AFTER_TERM=5 # Seconds to wait after sending SIGTERM

# === End Configuration ===


# === Function definitions ===

# Function to print usage instructions and exit
usage() {
  echo "Usage: $0 {start|stop|restart}"
  echo "  start   - Start processes only if they are not running."
  echo "  stop    - Stop running processes."
  echo "  restart - Stop running processes, then start them."
  exit 1
}

# Function to handle checking, killing, and starting a single process based on action
# Arguments: $1=Pattern, $2=StartCommand, $3=ProcessNameForLogging, $4=Action(start|stop|restart)
handle_process() {
  local pattern="$1"
  local start_cmd="$2"
  local process_name="$3"
  local action="$4"

  echo "----------------------------------------"
  echo "[$(date)] Handling process: $process_name - Action: $action"
  echo "  Pattern: '$pattern'"

  local pids
  pids=$(pgrep -f "$pattern") # Use pgrep -f to match full command line

  # --- STOP Logic (executed for 'stop' and 'restart' actions) ---
  if [[ "$action" == "stop" || "$action" == "restart" ]]; then
    if [ -n "$pids" ]; then
      echo "  Process '$process_name' found with PID(s): $pids"
      echo "  Attempting graceful termination (SIGTERM)..."
      pkill -TERM -f "$pattern"

      echo "  Waiting ${WAIT_AFTER_TERM} seconds..."
      sleep ${WAIT_AFTER_TERM}

      local pids_after_term
      pids_after_term=$(pgrep -f "$pattern")
      if [ -n "$pids_after_term" ]; then
        echo "  Process '$process_name' ($pids_after_term) did not terminate gracefully. Sending force kill (SIGKILL)..."
        pkill -KILL -f "$pattern"
        sleep 1 # Short pause after SIGKILL
      else
        echo "  Process '$process_name' terminated successfully after SIGTERM."
      fi
    else
      # Only print "not found" if the action was explicitly 'stop'
      if [[ "$action" == "stop" ]]; then
         echo "  Process '$process_name' matching pattern was not found running (nothing to stop)."
      fi
    fi
  fi # End STOP Logic

  # --- START Logic (executed for 'start' and 'restart' actions) ---
  if [[ "$action" == "start" || "$action" == "restart" ]]; then
    # If action is 'start', check if it's *already* running (after potential stop in 'restart')
    if [[ "$action" == "start" ]]; then
        pids=$(pgrep -f "$pattern") # Re-check PIDs
        if [ -n "$pids" ]; then
            echo "  Process '$process_name' is already running with PID(s): $pids. Skipping start."
            echo "----------------------------------------"
            return # Exit function for this process if trying to 'start' an already running one
        fi
    fi

    # Check if the start command is still a placeholder
    if [[ "$start_cmd" == PLEASE_REPLACE* ]]; then
        echo "  SKIPPING start for '$process_name' - Start command is still a placeholder."
        echo "  Please edit the script and provide the correct start command."
        echo "----------------------------------------"
        return # Exit the function for this process
    fi

    echo "  Starting '$process_name'..."
    echo "  Executing: ${start_cmd}"
    # Execute the start command using bash -c
    bash -c "${start_cmd}"
    local exit_code=$?

    echo "  Waiting ${WAIT_AFTER_TERM} seconds..."
    sleep ${WAIT_AFTER_TERM}
    local pids_after_start
    pids_after_start=$(pgrep -f "$pattern")

    if [ ${exit_code} -eq 0 ] && [ -n "$pids_after_start" ]; then
       echo "  Start command for '$process_name' executed. Process appears to be running with PID(s): $pids_after_start"
       echo "  Details:"
       # Use ps options that work widely; adjust if needed
       ps -p $pids_after_start -o pid,ppid,user,start,etime,cmd || ps fp $pids_after_start # Fallback
    else
       echo "  WARNING: Start command for '$process_name' exited with code ${exit_code}. Process may not have started successfully (PID found: '$pids_after_start'). Please check manually."
    fi
  fi # End START Logic
  echo "----------------------------------------"
} # End handle_process function


# === Main Script Execution ===

# 1. Check for Action Argument
if [ -z "$1" ]; then
  echo "Error: No action specified."
  usage
fi

# 2. Validate Action Argument
ACTION=$(echo "$1" | tr '[:upper:]' '[:lower:]') # Convert action to lowercase
case "$ACTION" in
  start|stop|restart)
    # Action is valid, proceed
    ;;
  *)
    echo "Error: Invalid action '$1'."
    usage
    ;;
esac

echo "##################################################"
echo "Starting Multi-Process Script at $(date)"
echo "Action: $ACTION"
echo "##################################################"

# Call the function for each configured process with the specified action
handle_process "$PATTERN_TOOLBOX" "$START_COMMAND_TOOLBOX" "toolbox.sh" "$ACTION"
handle_process "$PATTERN_ALLOYDB" "$START_COMMAND_ALLOYDB" "alloydb-auth-proxy" "$ACTION"

echo ""
echo "##################################################"
echo "Multi-Process Script finished at $(date)"
echo "##################################################"

exit 0
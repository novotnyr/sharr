# Return an previous index of specified index in an array
# Arguments
#   1: index to find a predecessor
#   2: array that will be parsed for a previous index
# Returns
#   Writes a previous index or -1 if no index can be found
# Status code:
#   0: on success
#   1: on illegal index
arr_previous_index() {
  INDEX="${1?:'Missing index'}"
  # Shift all arguments to left, evicting INDEX.
  # Now all array elements are in $1, $2 etc.
  shift
  ARRAY=${1?:'Missing array glob'}
  # No double quoting here, we need separate words
  # Requesting previous element of the first one is an immediate failure
  [ "$INDEX" -ne 0 ] || { printf -- '-1'; return 1; } #out of bounds
  I=0;
  for E in $ARRAY
  do
    if [ "$I" -eq "$INDEX" ]
    then
       echo "$((INDEX - 1))"
       return
    fi
    : "$(( I = I + 1 ))"
  done
  printf -- '-1' # unavailable element index
  return 1 #out of bounds
}

# Return the next index of specified index in an array
# Arguments
#   1: index to find a predecessor
#   2: array that will be parsed for the following index
# Returns
#   Writes the subsequent index or -1 if no index can be found
# Status code:
#   0: on success
#   1: on illegal index
arr_next_index() {
  INDEX="${1?:'Missing index'}"
  # Shift all arguments to left, evicting INDEX.
  # Now all array elements are in $1, $2 etc.
  shift
  # No double quoting here, we need separate words
  ARRAY=${1?:'Missing array glob'}
  I=0;
  MATCH=
  for E in $ARRAY
  do
    if [ -z "$MATCH" ] && [ "$I" -eq "$INDEX" ]
    then
       MATCH="$INDEX"
    fi
    : "$(( I = I + 1 ))"
  done
  # If we hit a last element, `I` is set to the length of array.
  # We must ensure that INDEX is in the array bounds _and_ not the last element.
  [ "$INDEX" -lt "$(( I - 1 ))" ] || { printf -- '-1'; return 1; }
  echo "$(( MATCH + 1 ))"
}

# Return an element on the specified index
# Arguments
#   1: index to find a predecessor
#   2: array that will be parsed for the following index
# Returns
#   Writes the corresponding element value on the specified index or nothing when element is not found.
# Status code:
#   0: on success
#   1: on illegal index
arr_element_at() {
  INDEX="${1?:'Missing index'}"
  # Shift all arguments to left, evicting INDEX.
  # Now all array elements are in $1, $2 etc.
  shift
  # No double quoting here, we need separate words
  ARRAY=${1?:'Missing array glob'}
  I=0;
  for ELEMENT in $ARRAY
  do
    if [ "$I" -eq "$INDEX" ]
    then
       echo "$ELEMENT"
       return 0
    fi
    : "$(( I = I + 1 ))"
  done
  return 1;
}

# Return a previous element to the element specified by index
# Arguments
#   1: index to find a predecessor
#   2, 3, 4, 5, etc: elements of the array
# Returns
#   Writes a previous element or -1 if no such element is available
# Status code:
#   0: on success
#   1: on illegal index or out of bounds index
arr_prev() {
  index="${1?:'Missing index'}"
  # Shift all arguments to left, evicting INDEX.
  # Now all array elements are in $1, $2 etc.
  shift

  [ "$index" -gt 0 ] || { echo '-1'; return 1; }
  [ "$index" -lt "$#" ] || { echo '-1'; return 1; }
  i=0
  prev=
  for e
  do
    [ "$i" -eq "$index" ] && { echo "$prev"; return; }
    : $(( i = i + 1 ))
    prev="$e"
  done
  printf -- '\0' # unavailable element index
  return 1
}

# Return a next element to the element specified by index
# Arguments
#   1: index to find a successor
#   2, 3, 4, 5, etc: elements of the array
# Returns
#   Writes a following element or -1 if no such element is available
# Status code:
#   0: on success
#   1: on illegal index or out of bounds index
arr_next() {
  index="${1?:'Missing index'}"
  # Shift all arguments to left, evicting INDEX.
  # Now all array elements are in $1, $2 etc.
  shift

  i=0
  match_index=
  match=
  for e
  do
    if [ "$match_index" ]
    then
      match="$e"
      match_index=
    fi
    if [ "$i" -eq "$index" ]
    then
       match_index="$index"
    fi
    : "$((i = i + 1))"
  done
  # If we hit a last element, `i` is set to the length of array.
  # We must ensure that `index` is within array bounds _and_ not pointing to the last element.
  [ "$index" -lt "$(( i - 1 ))" ] || { printf -- '-1'; return 1; }
  echo "$match"
}
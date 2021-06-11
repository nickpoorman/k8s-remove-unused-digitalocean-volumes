#!/bin/bash

contains() {
    [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && echo "yes" || echo "no"
}

PVCS=$(kubectl get pv | tail -n +2 | awk '{print $1}')
DO_VOLUMES_FULL=$(doctl compute volume list | tail -n +2)
DO_VOLUMES=$(echo "$DO_VOLUMES_FULL" | awk '{print $2}')
DO_VOLUMES_IDS=$(echo "$DO_VOLUMES_FULL" | awk '{print $1}')

do_volumes_full=()
while IFS= read -r line; do
    do_volumes_full+=( "$line" )
done < <( printf '%s\n' "${DO_VOLUMES_FULL[@]}" )

echo "==== doctl output ===="
printf '%s\n' "${DO_VOLUMES_FULL[@]}"
echo ""

echo "===kube volumes==="
printf '%s\n' "${PVCS[@]}"
echo ""

echo "===do volumes==="
printf '%s\n' "${DO_VOLUMES[@]}"
echo ""

echo "===do volumes ids==="
printf '%s\n' "${DO_VOLUMES_IDS[@]}"
echo ""

echo "===volumes to cleanup==="
toRemove=()
do_pvcs_array=($DO_VOLUMES)
do_volue_ids_array=($DO_VOLUMES_IDS)
for i in ${!do_pvcs_array[@]}; 
do
    item="${do_pvcs_array[$i]}"
    if [ $(contains "$PVCS" "$item") == "no" ]; then
    toRemove+=($i)
    fi
done

removed=()
for i in  "${toRemove[@]}"
do
    echo "Removing:"
    echo "=>id: ${do_volue_ids_array[$i]}"
    echo "=>pvc: ${do_pvcs_array[$i]}"
    echo "doctl line:"
    echo "=>${do_volumes_full[$i]}"
    read -r -p "Are you sure? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        doctl compute volume delete "${do_volue_ids_array[$i]}"
        removed+=("${do_volue_ids_array[$i]}")
    fi
    echo ""
done

echo "removed ${#removed[@]} unused volumes"
for value in "${removed[@]}"
do
     echo $value
done

echo "done."

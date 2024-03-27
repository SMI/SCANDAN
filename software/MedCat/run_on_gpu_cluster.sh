#!/bin/bash

# Usage:
#  status  - displays your current persistent volumes, pods and jobs
#  delete  - deletes your current persistent volumes, pods and jobs
#  mount   - start a pod which mounts the storage, so you can copy in/out
#  unmount - stop the pod which has mounted the storage
#  shell [pod] - start a /bin/sh shell in the pod, default is storage pod
#  <id>   - creates and runs a job called 'id'
#  <id> <image> - creates and runs a job called 'id' pulling container 'image'
# When running an image, it does this:
# 1. creates some storage and runs a pod to manage it ("mount" it)
# 2. copies the "input" directory into the storage via the pod
# 3. stops the pod ("unmount" the storage)
# 4. starts a pod to run your image, which will have the storage in it
# 5. as for "input", it copies the "output" back from the storage
# NOTE: if the storage exists and you try to overwrite files in it
# then, even if the files are identical, the new files take up more space,
# so your storage may run out of space.
# 6. it can "unmount" and "delete" the storage at the end if you want.

ns="eidf040ns"
user=$(id -un)
id="medcat"
image_name="howff/medcat"

msg()
{
	echo "$(date) -- $1"
}

storage_created()
{
	# Returns 0 (success) if storage exists, 1 (error) if no storage
	# Call it like this: if storage_created; then echo OK
	pvname="pvc-ceph-${id}-${ns}-${user}"
	if kubectl -n "${ns}" get pvc 2>/dev/null | grep --quiet "$pvname"; then
		return 0
	else
		return 1
	fi
}

create_storage()
{
	pvname="pvc-ceph-${id}-${ns}-${user}"
	pvcfile=tmp_pvc.yml
	cat <<_EOF > "${pvcfile}"
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
 name: ${pvname}
 #namespace: ${ns}
spec:
 accessModes:
  - ReadWriteOnce
 resources:
  requests:
   storage: 4Gi
 storageClassName: csi-rbd-sc
_EOF
	msg "Creating volume: $pvname"
	kubectl -n "${ns}" create -f "${pvcfile}"
}

delete_storage()
{
	pvname="pvc-ceph-${id}-${ns}-${user}"
	msg "Deleting volume: $pvname"
	kubectl -n "${ns}" delete pvc "${pvname}"
	msg "Deleted volume: $pvname"
}

# ---------------------------------------------------------------------

storage_mounted()
{
	pvmountjobname="pvc-mount-${id}-${ns}-${user}-job"
	if kubectl -n "${ns}" get jobs 2>/dev/null | grep --quiet "$pvmountjobname"; then
		return 0
	else
		return 1
	fi
}

mount_storage()
{
	pvname="pvc-ceph-${id}-${ns}-${user}"
	pvmountjobname="pvc-mount-${id}-${ns}-${user}-job"
	pvmountpodname="pvc-mount-${id}-${ns}-${user}-pod"
	pvmountpath="/mnt/ceph_rbd"
	pvmountfile=tmp_pvmount.yml
	cat <<_EOF > "${pvmountfile}"
apiVersion: batch/v1
kind: Job
metadata:
    name: ${pvmountjobname}
    labels:
        kueue.x-k8s.io/queue-name:  ${ns}-user-queue
spec:
    completions: 1
    template:
        metadata:
            name: ${pvmountpodname}
        spec:
            containers:
            - name: sleeper
              image: busybox
              args: ["sleep", "infinity"]
              resources:
                    requests:
                        cpu: 1
                        memory: '1Gi'
                    limits:
                        cpu: 1
                        memory: '1Gi'
              volumeMounts:
                    - mountPath: ${pvmountpath}
                      name: volume
            restartPolicy: Never
            volumes:
                - name: volume
                  persistentVolumeClaim:
                    claimName: ${pvname}
_EOF
	msg "Mounting volume: $pvname"
	kubectl -n "${ns}" create -f "${pvmountfile}"
}

unmount_storage()
{
	pvname="pvc-ceph-${id}-${ns}-${user}"
	pvmountjobname="pvc-mount-${id}-${ns}-${user}-job"
	msg "Unmounting volume: $pvname"
	kubectl -n "${ns}" delete job "${pvmountjobname}"
}

find_mount_job()
{
	pvmountjobname="pvc-mount-${id}-${ns}-${user}-job"
	job=$(kubectl -n "${ns}" get pods 2>/dev/null | grep "${pvmountjobname}" | awk '{print$1}')
	echo "$job"
}

find_running_mount_job()
{
	pvmountjobname="pvc-mount-${id}-${ns}-${user}-job"
	while true; do
		job=$(kubectl -n "${ns}" get pods 2>/dev/null | grep "${pvmountjobname}.*Running" | awk '{print$1}')
		if [ "$job" != "" ]; then
			break
		fi
		msg "Waiting for job $pvmountjobname to start..." >&2
		sleep 1
	done
	echo "$job"
}

copy_files_in()
{
	pvmountpodname="pvc-mount-${id}-${ns}-${user}-pod"
	pvmountpath="/mnt/ceph_rbd"
	jobname=$(find_running_mount_job)
	msg "Copying from $1 into the container at ${pvmountpath}/$2"
	kubectl -n "${ns}" cp "$1" "${jobname}":"${pvmountpath}"/"$2"
}

copy_files_out()
{
	pvmountpodname="pvc-mount-${id}-${ns}-${user}-pod"
	pvmountpath="/mnt/ceph_rbd"
	jobname=$(find_running_mount_job)
	msg "Copying from the container at ${pvmountpath}/$1 into $2"
	kubectl -n "${ns}" cp "${jobname}":"${pvmountpath}"/"$1" "$2"
}

# ---------------------------------------------------------------------

run_container()
{
	containername="$1"
	containerfile="tmp_container.yml"
	pvname="pvc-ceph-${id}-${ns}-${user}"
	cat <<_EOF > "${containerfile}"
apiVersion: batch/v1
kind: Job
metadata:
    generateName: ${id}-
    labels:
        kueue.x-k8s.io/queue-name:  ${ns}-user-queue
spec:
    completions: 1
    template:
        metadata:
            name: whatisthat
        spec:
            containers:
            - name: whatisthis
              image: ${containername}
              args: ["$2", "$3", "$4"]
              resources:
                    requests:
                        cpu: 2
                        memory: '1Gi'
                        nvidia.com/gpu: 1
                    limits:
                        cpu: 2
                        memory: '32Gi'
                        nvidia.com/gpu: 1
              volumeMounts:
                    - mountPath: ${pvmountpath}
                      name: volume
            restartPolicy: Never
            volumes:
                - name: volume
                  persistentVolumeClaim:
                    claimName: ${pvname}

_EOF
	msg "Starting container: $containername"
	msg "Running: kubectl -n ${ns} create -f ${containerfile}"
	kubectl -n "${ns}" create -f "${containerfile}"

	jobname=$(find_container_job)
	msg "Waiting for container to complete: $containername as job $jobname"
	msg "Running: kubectl -n ${ns} wait --for=condition=complete --timeout=-1s job.batch/$jobname"
	kubectl -n "${ns}" wait --for=condition=complete --timeout=-1s "job.batch/${jobname}"
}

find_container_job()
{
	job=$(kubectl -n "${ns}" get jobs 2>/dev/null | grep "${id}" | awk '{print$1}')
	echo "$job"
}


# ---------------------------------------------------------------------

status()
{
	if storage_created; then msg "PVC Storage exists"; fi
	if storage_mounted; then msg "PVC Storage is mounted in a sleeping job"; fi
	printf "PVC "; kubectl -n "${ns}" get pvc
	printf "POD "; kubectl -n "${ns}" get pods
	printf "JOB "; kubectl -n "${ns}" get jobs
	jobname=$(find_mount_job)
	msg "Mount job name : '$jobname'"
}

# ---------------------------------------------------------------------

delete_all()
{
	msg "Deleting any jobs..."
	kubectl -n "${ns}" get jobs | grep ^pvc | awk '{print$1}' | xargs -n 1 --no-run-if-empty kubectl -n "${ns}" delete job
	kubectl -n "${ns}" get jobs | grep / | awk '{print$1}' | xargs -n 1 --no-run-if-empty kubectl -n "${ns}" delete job
	msg "Deleting any PVCs..."
	kubectl -n "${ns}" get pvc | grep ^pvc | awk '{print$1}' | xargs -n 1 --no-run-if-empty kubectl -n "${ns}" delete pvc
}

# ---------------------------------------------------------------------

shell()
{
	# by default starts a shell into the container which has mounted the volume
	# but you can specify any other pod as an argument.
	msg "Running kubectl -n "${ns}" exec <jobname> -it -- /bin/sh"
	if [ "$1" == "" ]; then
		jobname=$(find_mount_job)
	else
		jobname="$1"
	fi
	kubectl -n "${ns}" exec ${jobname} -it -- /bin/sh
}

# ---------------------------------------------------------------------


usage()
{
	echo "Usage: $0 [status|delete|mount|unmount|shell <pod>] [id [image]]" >&2
	echo " where id is your choice of name for this job, and" >&2
	echo " image is the container to pull, e.g. myname/myimage" >&2
	echo " (can be a URL to dockerhub/ghcr/etc)" >&2
	exit 1
}

if [ "$1" == "status" ]; then status; exit 0; fi
if [ "$1" == "delete" ]; then delete_all; exit 0; fi
if [ "$1" == "shell" ]; then shell "$2"; exit 0; fi
if [ "$1" == "mount" ]; then mount_storage; exit 0; fi
if [ "$1" == "unmount" ]; then unmount_storage; exit 0; fi
if [ "$1" != "" ]; then
	id="$1"
	if [ "$2" != "" ]; then
		image_name="$2"
	fi
fi
if [ "$id" == "" -o "$image_name" == "" ]; then usage; fi

if ! storage_created; then
	create_storage
fi

if ! storage_mounted; then
	mount_storage
fi

copy_files_in  input  input

# Make sure an empty output directory exists:
copy_files_in  output output

# Unmount volume from sleeping container so that job can mount it.
# Sadly EIDF doesn't support multiple readers/writers for a volume.
unmount_storage

pvmountpath="/mnt/ceph_rbd"
run_container "${image_name}" \
	"${pvmountpath}/input/models/mc_modelpack_snomed_int_16_mar_2022_25be3857ba34bdd5.zip" \
	"${pvmountpath}/input/docs/doc1.txt" \
	"${pvmountpath}/output/doc1.json"

mount_storage
copy_files_out output output_

# If you are going to re-run your container then keep the storage
# otherwise it can be unmounted.
#if storage_mounted; then
#	unmount_storage
#fi

# If you are going to re-run your container then keep the storage
# otherwise it can be deleted (assuming you've copied the output).
#if storage_created; then
#	delete_storage
#fi

status

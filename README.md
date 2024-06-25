# Testing nf-float staging speed

## Goal

Figure out if there's a bottleneck staging many large files.

## Instructions

1. Specify list of files to stage in `nextflow_command`.

2. Adjust `outdir` and `env BUCKET`

3. Run the workflow

```
./float submit --hostInit transient_JFS_AWS.sh \
-i docker.io/memverge/juiceflow \
--vmPolicy '[onDemand=true]' \
--migratePolicy '[disable=true]' \
--dataVolume '[size=60]:/mnt/jfs_cache' \
--dirMap /mnt/jfs:/mnt/jfs \
-c 2 -m 4 \
-n staging-testing-speed-1 \
--securityGroup sg-0e3a2750bdf58794c \
--env BUCKET=https://cfdx-juicefs.s3.us-east-1.amazonaws.com \
-j job_submit_AWS.sh
```

## Results

#!/bin/bash


if [ $# -ne 1 ]; then echo "usage $0; variable"; exit 1; fi

VAR=$1
MODELS=("CESM2" "MRI-ESM2-0")

#download files
for MODEL in ${MODELS[1]}; do
    DATA_DIR="/data/team/bnb32/cmip_data/CMIP6/${MODEL}/${VAR}"
    python ../mip-tools/retriever.py CMIP6 -t mon -ex historical -var $VAR -m ${MODEL} -d ${DATA_DIR}

#read in files

    FILES="`ls ${DATA_DIR}/*.nc`"

#cdo average files
    echo "creating average file: $OUTFILE"
    OUTFILE="${DATA_DIR}/${MODEL}_${VAR}.nc"
    ncra -O -d time,0, -v ${VAR} ${FILES} ${OUTFILE}

#plot avg fields
    echo "plotting average file"
    python ./plot_avg_map.py ${OUTFILE}
    echo "done"
done    

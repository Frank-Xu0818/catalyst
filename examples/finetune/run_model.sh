#!/usr/bin/env bash
set -e

echo "Training..."
catalyst-dl train \
    --expdir=finetune \
    --config=finetune/train.yml \
    --logdir=${LOGDIR} --verbose

echo "Inference..."
catalyst-dl inference \
   --expdir=finetune \
   --resume=${LOGDIR}/checkpoint.best.pth.tar \
   --out-prefix=${LOGDIR}/dataset.predictions.{suffix}.npy \
   --config=${LOGDIR}/config.json,./finetune/inference.yml \
   --verbose

# docker trick
if [ "$EUID" -eq 0 ]; then
  chmod -R 777 ${LOGDIR}
fi

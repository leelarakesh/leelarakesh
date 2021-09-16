export RUNENV="BDRMASKED"
echo "excute Initialize_Environment_Parameters"
source G_Initialize_Environment_Parameters.sh
rsync -av "$migspoolloc/Spool" "$spoolloc"